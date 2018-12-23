import Foundation
import Vapor
import FluentQuery
import WS

extension MessageController {
    struct EditPayload: Content {
        var text: String
    }
    
    func edit(_ req: Request, payload: EditPayload) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return try req.parameters.next(Message.self).flatMap { message in
            guard message.senderId == userId else { throw Abort(.forbidden, reason: "It's not your message") }
            message.text = payload.text
            return message.save(on: req).flatMap { _ in
                let ws = try req.make(WS.self)
                return try ws.broadcast(asBinary: .messageEdited,
                                                   MessageEditedPayload(id: message.id!, text: message.text),
                                                   to: message.roomId.uuidString,
                                                   on: req).transform(to: .ok)
            }
        }
    }
}
