import Foundation
import Vapor
import FluentSQL

extension MessageController {
    func list(_ req: Request) throws -> Future<[Message]> {
        let user = try req.requireAuthenticated(User.self)
        return try req.parameters.next(Room.self).flatMap { room in
            guard room.members.contains(user.id!) || user.isAdmin else { throw Abort(.forbidden) }
            return Message.query(on: req).filter(\.roomId == room.id!).all() //TODO: add paginating
        }
    }
}
