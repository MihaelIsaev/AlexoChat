import Foundation
import Vapor
import FluentSQL
import WS

public struct TypingPayload: Codable {
    enum Action: String, Codable {
        case started, ended
    }
    var userId: User.ID
    var roomId: Room.ID
    var action: Action
}

extension WSEventIdentifier {
    public static var typing: WSEventIdentifier<TypingPayload> { return .init("typing") }
}

extension WSController {
    func typing(_ client: WSClient, _ payload: TypingPayload) {
        _ = Room.query(on: client).filter(\.id == payload.roomId).first().map { room -> Void in
            guard let room = room else { return }
            guard room.members.contains(payload.userId) else { return }
            try client.broadcast(asBinary: .typing, payload, to: payload.roomId.uuidString, on: client)
        }
    }
}
