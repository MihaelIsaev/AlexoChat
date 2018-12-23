import Foundation
import Vapor
import WS

public struct JoinedRoomPayload: Codable {
    public var userId: UUID
    public var text: String
}

extension WSEventIdentifier {
    public static var joinedRoom: WSEventIdentifier<JoinedRoomPayload> { return .init("joinedRoom") }
}

extension WSController {
    func joinedRoom(_ client: WSClient, _ payload: JoinedRoomPayload) {
        
    }
}
