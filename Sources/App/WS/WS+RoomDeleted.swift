import Foundation
import Vapor
import WS

struct RoomDeletedPayload: Codable {
    var id: Room.ID
}

extension WSEventIdentifier {
    static var roomDeleted: WSEventIdentifier<RoomDeletedPayload> { return .init("roomDeleted") }
}

extension WSController {
    func roomRemoved(_ client: WSClient, _ payload: RoomDeletedPayload) {
        
    }
}
