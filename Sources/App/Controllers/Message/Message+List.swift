import Foundation
import Vapor
import FluentSQL
import FluentQuery

extension MessageController {
    func list(_ req: Request) throws -> Future<[Message.Public]> {
        let user = try req.requireAuthenticated(User.self)
        let limit = (try? req.query.get(Int.self, at: "limit")) ?? 20
        let offset = (try? req.query.get(Int.self, at: "offset")) ?? 0
        return try req.parameters.next(Room.self).flatMap { room in
            guard room.members.contains(user.id!) || user.isAdmin == true else { throw Abort(.forbidden) }
            return req.requestPooledConnection(to: .psql).flatMap { conn in
                defer { try? req.releasePooledConnection(conn, to: .psql) }
                return try FQL()
                    .select(all: Message.self)
                    .select(.row(User.self), as: "sender")
                    .from(Message.self)
                    .where(\Message.roomId == room.id)
                    .join(.left, User.self, where: \Message.senderId == \User.id)
                    .limit(limit)
                    .orderBy(.desc(\Message.createdAt))
                    .offset(offset)
                    .execute(on: conn)
                    .decode(Message.Public.self)
            }
        }
    }
}
