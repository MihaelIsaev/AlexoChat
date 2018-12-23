import Foundation
import Vapor
import FluentQuery
import WS

extension MessageController {
    struct SendDirectPayload: Content {
        var toUserId: User.ID
        var text: String
    }
    
    func sendToUser(_ req: Request, payload: SendDirectPayload) throws -> Future<Message> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        guard payload.toUserId != userId else {
            throw Abort(.badRequest, reason: "Sending a direct message to yourself is prohibited")
        }
        return req.requestPooledConnection(to: .psql).flatMap { conn in
            let fq = FQL()
            fq.select(all: Room.self)
            fq.from(Room.self)
            fq.where(\Room.type == .direct && \Room.members ~~ [userId] && \Room.members ~~ [payload.toUserId])
            return try fq.execute(on: conn, andDecode: Room.self).flatMap { rooms in
                guard rooms.count <= 1 else {
                    throw Abort(.internalServerError, reason: "Unable to create direct room for that message cause there are more that one rooms in the database already")
                }
                let createMessage: (Room) throws -> Future<Message> = { room in
                    defer { try? req.releasePooledConnection(conn, to: .psql) }
                    return Message(roomId: room.id!, senderId: userId, text: payload.text).create(on: conn).flatMap { message in
                        let ws = try req.make(WS.self)
                        return try ws.broadcast(asBinary: .message,
                                                           MessagePayload(type: .direct, fromUser: User.Public(user), room: room, text: message.text),
                                                           to: userId.uuidString,
                                                           on: req).map {
                            return message
                        }
                    }
                }
                if let room = rooms.first {
                    return try createMessage(room)
                } else {
                    return Room(type: .direct, members: [userId, payload.toUserId]).create(on: conn).flatMap { room in
                        return try createMessage(room)
                    }
                }
            }.catchMap { error in
                try? req.releasePooledConnection(conn, to: .psql)
                throw error
            }
        }
    }
}
