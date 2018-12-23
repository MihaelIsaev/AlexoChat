import Foundation
import Vapor
import FluentQuery
import WS

extension RoomController {
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return try req.parameters.next(Room.self).flatMap { room in
            guard let owners = room.owners, owners.contains(userId) else { throw Abort(.forbidden, reason: "It's not your room") }
            return room.delete(on: req).flatMap {
                let ws = try req.make(WS.self)
                return try ws.broadcast(asBinary: .roomDeleted,
                                        RoomDeletedPayload(id: room.id!),
                                        to: room.id!.uuidString,
                                        on: req).transform(to: .ok)
            }
        }
    }
}
