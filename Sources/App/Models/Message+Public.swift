import Vapor

extension Message {
    struct Public: Content {
        var id: UUID?
        var roomId: Room.ID
        var sender: User
        var text: String
        var createdAt, updatedAt, deletedAt: Date?
    }
}
