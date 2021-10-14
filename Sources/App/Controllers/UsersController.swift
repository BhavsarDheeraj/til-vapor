import Vapor
import Fluent
import Crypto

struct UsersController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post("signup", use: createHandler)
        usersRoute.post("login", use: loginHandler)
        
        let authenticatedRoutes = usersRoute.grouped(JWTBearerAuthenticator())
        authenticatedRoutes.get("me", use: meHandler)
        authenticatedRoutes.get(":userID", "acronyms", use: getAcronymsHandler)
    }
    
    func loginHandler( _ req: Request) throws -> EventLoopFuture<User.Public> {
        let userToLogin = try req.content.decode(User.Login.self)
        return User.query(on: req.db)
            .filter(\.$username == userToLogin.username)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { user in
                let verified = try user.verify(password: userToLogin.password)
                if !verified {
                    throw Abort(.unauthorized)
                }
                req.auth.login(user)
                let user = try req.auth.require(User.self)
                let token = try user.generateToken(req.application)
                let publicUser = user.convertToPublic()
                publicUser.token = token
                return publicUser
            }
    }
    
    func meHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.auth.require(User.self)
        return User.query(on: req.db)
            .filter(\.$username == user.username)
            .first()
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[User]> {
        return User
            .query(on: req.db)
            .all()
    }
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<User> {
        return User
            .find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map { user.convertToPublic() }
    }
    
    func getAcronymsHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        return User
            .find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$acronyms.get(on: req.db)
            }
    }
}
