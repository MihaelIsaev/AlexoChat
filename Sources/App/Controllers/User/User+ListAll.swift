import Foundation
import Vapor
import FluentSQL

extension UserController {
    func listAll(_ req: Request) throws -> Future<[User]> {
        let limit = (try? req.query.get(Int.self, at: "limit")) ?? 20
        let offset = (try? req.query.get(Int.self, at: "offset")) ?? 0
        let user = try req.requireAuthenticated(User.self)
        guard user.isAdmin == true else { throw Abort(.forbidden) }
        return User.query(on: req).filter(\.id != user.id!).range(lower: limit, upper: limit + offset).all()
    }
}
