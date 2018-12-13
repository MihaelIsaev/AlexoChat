import Vapor
import FluentPostgreSQL

final class Message: Content {
    public static var createdAtKey: TimestampKey? { return \.createdAt }
    public static var updatedAtKey: TimestampKey? { return \.updatedAt }
    public static var deletedAtKey: TimestampKey? { return \.deletedAt }
    
    var id: UUID?
    var roomId: Room.ID
    var senderId: User.ID
    var text: String
    var createdAt, updatedAt, deletedAt: Date?
    
    init(id: Message.ID? = nil, roomId: Room.ID, senderId: User.ID, text: String) {
        self.id = id
        self.roomId = roomId
        self.senderId = senderId
        self.text = text
    }
}

extension Message: PostgreSQLUUIDModel {}
extension Message: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
        }
    }
}
