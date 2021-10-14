import JWT
import Vapor

struct MyJWTPayload: Authenticatable, JWTPayload {
    var id: UUID?
    var username: String
    var expiry: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try self.expiry.verifyNotExpired()
    }
}
