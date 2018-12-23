import Foundation
import Vapor
import FluentSQL
import WS

extension RoomController {
    func addMember(_ req: Request) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return try req.parameters.next(Room.self).flatMap { room in
            guard let owners = room.owners, owners.contains(userId) else { throw Abort(.forbidden, reason: "It's not your group") }
            return try req.parameters.next(User.self).flatMap { member in
                guard !room.members.contains(member.id!) else { throw Abort(.conflict, reason: "User is already in the group") }
                room.members.append(member.id!)
                return room.save(on: req).flatMap { _ in
                    let ws = try req.make(WS.self)
                    // Send notification to member
                    return try ws.broadcast(asBinary: .addedToRoom,
                                                       AddedToRoomPayload(roomId: room.id!),
                                                       to: member.id!.uuidString,
                                                       on: req).flatMap {
                        // Send notification to group
                        return try ws.broadcast(asBinary: .roomMemberAdded,
                                                           RoomMemberAddedPayload(roomId: room.id!, member: User.Public(member)),
                                                           to: room.id!.uuidString,
                                                           on: req).transform(to: .ok)
                    }
                }
            }
        }
    }
}
