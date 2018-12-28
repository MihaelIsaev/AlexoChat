import Foundation
import Vapor
import Fluent
import WS

extension MessageController {
    struct SendGroupPayload: Content {
        var roomId: Room.ID
        var text: String
    }
    
    func sendToGroup(_ req: Request, payload: SendGroupPayload) throws -> Future<Message.Public> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return Room.query(on: req).filter(\.id == payload.roomId).first().unwrap(or: Abort(.notFound)).flatMap { room in
            guard room.type == .open || room.members.contains(userId) else { throw Abort(.forbidden, reason: "This closed room isn't available for you") }
            return Message(roomId: room.id!, senderId: userId, text: payload.text).create(on: req).flatMap { message in
                let ws = try req.make(WS.self)
                return try ws.broadcast(asBinary: .message,
                                                   MessagePayload(type: .group, fromUser: User.Public(user), room: room, text: message.text),
                                                   to: room.id!.uuidString,
                                                   on: req).map {
                    return Message.Public(message, sender: user)
                }
            }
        }
    }
}
