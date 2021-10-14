import Vapor
import Fluent
import JWT

final class User: Model, Content {
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$user)
    var acronyms: [Acronym]
    
    init() {}
    
    init(id: UUID? = nil, name: String, username: String, password: String) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
    }
    
    final class Public: Content {
        var id: UUID?
        var name: String
        var username: String
        
        var token: String?
        
        init(id: UUID?, name: String, username: String, token: String? = nil) {
            self.id = id
            self.name = name
            self.username = username
            self.token = token
        }
    }
    
    final class Login: Content {
        var username: String
        var password: String
        
        init(username: String, password: String) {
            self.username = username
            self.password = password
        }
    }
}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, name: name, username: username)
    }
}

extension EventLoopFuture where Value: User {
    func convertToPublic() -> EventLoopFuture<User.Public> {
        return self.map { user in
            return user.convertToPublic()
        }
    }
}

extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        return self.map { $0.convertToPublic() }
    }
}

extension EventLoopFuture where Value == Array<User> {
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        return self.map { $0.convertToPublic() }
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$username
    
    static var passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.password)
    }
}

struct JWTBearerAuthenticator: JWTAuthenticator {
    typealias Payload = MyJWTPayload
    
    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do {
            try jwt.verify(using: request.application.jwt.signers.get()!)
            return User.find(jwt.id, on: request.db)
            .unwrap(or: Abort(.unauthorized))
            .map { user in
                request.auth.login(user)
            }
        } catch {
            return request.eventLoop.makeSucceededVoidFuture()
        }
    }
}

extension User {
    func generateToken(_ app: Application) throws -> String {
        var expiryDate = Date()
        let oneWeekInSeconds: Double = 7 * 24 * 60 * 60
        expiryDate.addTimeInterval(oneWeekInSeconds)
        let expirationClaim = ExpirationClaim(value: expiryDate)
        let payload = MyJWTPayload(id: self.id, username: self.username, expiry: expirationClaim)
        return try app.jwt.signers.sign(payload)
    }
}

extension User: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String, is: .count(3...))
        validations.add("username", as: String, is: .count(3...))
        validations.add("password", as: String, is: .count(5...))
    }
}
