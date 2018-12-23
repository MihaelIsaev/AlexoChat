import Foundation
import Vapor
import WS

struct MessageDeletedPayload: Codable {
    var id: Message.ID
    init (id: Message.ID) {
        self.id = id
    }
}

extension WSEventIdentifier {
    static var messageDeleted: WSEventIdentifier<MessageDeletedPayload> { return .init("messageDeleted") }
}

extension WSController {
    func messageEdited(_ client: WSClient, _ payload: MessageDeletedPayload) {
        
    }
}
