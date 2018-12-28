import Foundation
import Vapor
import FluentPostgreSQL

extension RoomController {
    func listAll(_ req: Request) throws -> Future<[Room]> {
        let limit = (try? req.query.get(Int.self, at: "limit")) ?? 20
        let offset = (try? req.query.get(Int.self, at: "offset")) ?? 0
        let user = try req.requireAuthenticated(User.self)
        guard user.isAdmin == true else { throw Abort(.forbidden) }
        return Room.query(on: req).range(lower: limit, upper: limit + offset).sort(\.name, .ascending).all()
    }
}
