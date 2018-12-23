import Foundation
import Vapor
import WS

struct RoomMemberAddedPayload: Codable {
    var roomId: Room.ID
    var member: User.Public
    init (roomId: Room.ID, member: User.Public) {
        self.roomId = roomId
        self.member = member
    }
}

extension WSEventIdentifier {
    static var roomMemberAdded: WSEventIdentifier<RoomMemberAddedPayload> { return .init("roomMemberAdded") }
}

extension WSController {
    func roomMemberAdded(_ client: WSClient, _ payload: RoomMemberAddedPayload) {
        
    }
}
