import Foundation
import Vapor
import FluentSQL

extension UserController {
    func getProfile(_ req: Request) throws -> Future<User> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return User.query(on: req).filter(\.id == userId).first().unwrap(or: Abort(.notFound))
    }
}
