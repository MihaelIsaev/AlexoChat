import Foundation
import Vapor
import WS

struct MessagePayload: Codable {
    enum MessageType: String, Codable {
        case direct, group
    }
    var type: MessageType
    var fromUser: User.Public
    var room: Room
    var text: String
    init (type: MessageType, fromUser: User.Public, room: Room, text: String) {
        self.type = type
        self.fromUser = fromUser
        self.room = room
        self.text = text
    }
}

extension WSEventIdentifier {
    static var message: WSEventIdentifier<MessagePayload> { return .init("message") }
}

extension WSController {
    func message(_ client: WSClient, _ payload: MessagePayload) {
        
    }
}
