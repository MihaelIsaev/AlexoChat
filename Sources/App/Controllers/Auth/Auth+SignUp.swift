import Vapor
import Crypto

extension AuthController {
    func signup(_ req: Request, user: User) throws -> Future<User.Public> {
        user.password = try BCrypt.hash(user.password)
        user.isAdmin = false
        return user.save(on: req).convertToPublic()
    }
}
