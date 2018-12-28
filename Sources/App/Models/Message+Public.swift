import Vapor

extension Message {
    struct Public: Content {
        var id: UUID?
        var roomId: Room.ID
        var sender: User
        var text: String
        var createdAt, updatedAt, deletedAt: Date?

        init(_ message: Message, sender: User) {
            self.id = message.id
            self.roomId = message.roomId
            self.sender = sender
            self.text = message.text
            self.createdAt = message.createdAt
            self.updatedAt = message.updatedAt
            self.deletedAt = message.deletedAt
        }
    }
}
