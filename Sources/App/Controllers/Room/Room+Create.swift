import Foundation
import Vapor
import FluentSQL

extension RoomController {
    struct CreateRequest: Content {
        var name: String
        var shared: Bool
    }
    
    func create(_ req: Request, payload: CreateRequest) throws -> Future<Room.Public> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        let room = Room(name: payload.name,
                                  type: payload.shared ? .open : .closed,
                                  members: [userId],
                                  owners: [userId])
        return req.transaction(on: .psql) { conn in
            return room.create(on: conn).map { room in
                return room.convertToPublic()
            }
        }
    }
}
