import Foundation
import Vapor
import WS

public struct RoomCreatedPayload: Codable {
    public var userId: UUID
    public var text: String
}

extension WSEventIdentifier {
    public static var roomCreated: WSEventIdentifier<RoomCreatedPayload> { return .init("roomCreated") }
}

extension WSController {
    func roomCreated(_ client: WSClient, _ payload: RoomCreatedPayload) {
        
    }
}
