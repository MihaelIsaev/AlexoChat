import Foundation
import Vapor
import WS

struct AddedToRoomPayload: Codable {
    var roomId: Room.ID
    init (roomId: Room.ID) {
        self.roomId = roomId
    }
}

extension WSEventIdentifier {
    static var addedToRoom: WSEventIdentifier<AddedToRoomPayload> { return .init("addedToRoom") }
}

extension WSController {
    func addedToRoom(_ client: WSClient, _ payload: AddedToRoomPayload) {
        
    }
}
