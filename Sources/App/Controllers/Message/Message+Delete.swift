import Foundation
import Vapor
import FluentQuery
import WS

extension MessageController {
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return try req.parameters.next(Message.self).flatMap { message in
            guard message.senderId == userId else { throw Abort(.forbidden, reason: "It's not your message") }
            return message.delete(on: req).flatMap {
                let ws = try req.make(WS.self)
                return try ws.broadcast(asBinary: .messageDeleted,
                                        MessageDeletedPayload(id: message.id!),
                                        to: message.roomId.uuidString,
                                        on: req).transform(to: .ok)
            }
        }
    }
}
