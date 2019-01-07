import Foundation
import Vapor
import FluentSQL
import WS

public struct TypingPayload: Codable {
    enum Action: String, Codable {
        case started, ended
    }
    var user: User.Public?
    var roomId: Room.ID
    var action: Action
}

extension WSEventIdentifier {
    public static var typing: WSEventIdentifier<TypingPayload> { return .init("typing") }
}

extension WSController {
    func typing(_ client: WSClient, _ payload: TypingPayload) {
        guard let user: User = try? client.req.requireAuthenticated() else { return }
        guard let userId = user.id else { return }
        _ = Room.query(on: client).filter(\.id == payload.roomId).first().map { room -> Void in
            guard let room = room else { return }
            guard room.members.contains(userId) else { return }
            let broadcastPayload = TypingPayload(user: user.convertToPublic(), roomId: payload.roomId, action: payload.action)
            try client.broadcast(asBinary: .typing, broadcastPayload, to: payload.roomId.uuidString, on: client)
        }
    }
}
