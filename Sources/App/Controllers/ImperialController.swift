import Vapor
import Imperial

struct ImperialController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        guard let googleCallbackURL = Environment.get("GOOGLE_CALLBACK_URL") else {
            fatalError("Google callback url not set")
        }
        
        try routes.oauth
    }
    
    func processGoogleLogin(req: Request, token: String) throws -> EventLoopFuture<ResponseEncodable> {
        req.eventLoop.future(req.redirect(to: "/api/users/me"))
    }
}
