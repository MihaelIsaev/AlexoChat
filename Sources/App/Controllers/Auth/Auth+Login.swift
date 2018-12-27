import Vapor

extension AuthController {
    struct AuthResponse: Content {
        var id: UUID?
        var token, nickname: String
        var isAdmin: Bool
    }
    
    func login(_ req: Request) throws -> Future<AuthResponse> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req).map { token in
            return AuthResponse(id: user.id, token: token.token, nickname: user.nickname, isAdmin: user.isAdmin == true)
        }
    }
}
