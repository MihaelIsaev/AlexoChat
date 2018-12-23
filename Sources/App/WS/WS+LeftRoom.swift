import Foundation
import Vapor
import WS

public struct LeftRoomPayload: Codable {
    public var userId: UUID
    public var text: String
}

extension WSEventIdentifier {
    public static var leftRoom: WSEventIdentifier<LeftRoomPayload> { return .init("leftRoom") }
}

extension WSController {
    func leftRoom(_ client: WSClient, _ payload: LeftRoomPayload) {
        
    }
}
