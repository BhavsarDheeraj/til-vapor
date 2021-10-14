import Fluent
import FluentPostgresDriver
import Vapor
import JWT

//extension String {
//    var bytes: [UInt8] { .init(self.utf8) }
//}

//extension JWKIdentifier {
//    static let `public` = JWKIdentifier(string: "public")
//    static let `private` = JWKIdentifier(string: "private")
//}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    
    if let url = Environment.get("DATABASE_URL") {
        try app.databases.use(.postgres(url: url), as: .psql)
    } else {
        
        let databaseName: String
        let databasePort: Int
        
        if app.environment == .testing {
            databaseName = "vapor-test"
            databasePort = 5433
        } else {
            databaseName = "vapor_database"
            databasePort = 5432
        }

        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: databasePort, // Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber
            username: Environment.get("DATABASE_USERNAME") ?? "root",
            password: Environment.get("DATABASE_PASSWORD") ?? "password",
            database: databaseName // Environment.get("DATABASE_NAME") ?? databaseName
        ), as: .psql)
        
    }
    
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateAcronym())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateAcronymCategoryPivot())
    
    app.logger.logLevel = .debug
    
    try app.autoMigrate().wait()
        
    // Configure
//    let privateKey = try String(contentsOfFile: "/Users/mobcast/Developer/vapor/TILApp/jwt.key")
//    let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))
//
//    let publicKey = try String(contentsOfFile: "/Users/mobcast/Developer/vapor/TILApp/jwt.key.pub")
//    let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))
//
//    app.jwt.signers.use(privateSigner, kid: .private)
//    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)
    
    
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SECRET")!))

    // register routes
    try routes(app)
}
