import Vapor
import Crypto

final class AuthController {
    @discardableResult
    init(_ router: Router) {
        let group = router.grouped("auth")
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: login)
        
        group.post(User.self, at: "signup", use: signup)
    }
}
