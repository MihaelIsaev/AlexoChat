import Foundation
import Vapor
import WS

public struct TypingPayload: Codable {
    public var userId: UUID
    public var text: String
}

extension WSEventIdentifier {
    public static var typing: WSEventIdentifier<TypingPayload> { return .init("typing") }
}

extension WSController {
    func typing(_ client: WSClient, _ payload: TypingPayload) {
        
    }
}
