import Foundation
import Vapor
import WS

struct MessageEditedPayload: Codable {
    var id: Message.ID
    var text: String
    init (id: Message.ID, text: String) {
        self.id = id
        self.text = text
    }
}

extension WSEventIdentifier {
    static var messageEdited: WSEventIdentifier<MessageEditedPayload> { return .init("messageEdited") }
}

extension WSController {
    func messageEdited(_ client: WSClient, _ payload: MessageEditedPayload) {
        
    }
}
