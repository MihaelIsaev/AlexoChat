import Foundation
import Vapor
import WS

public struct MessagePayload: Codable {
    public var userId: UUID
    public var text: String
}

extension WSEventIdentifier {
    public static var message: WSEventIdentifier<MessagePayload> { return .init("message") }
}

extension WSController {
    func message(_ client: WSClient, _ payload: MessagePayload) {
        
    }
}
