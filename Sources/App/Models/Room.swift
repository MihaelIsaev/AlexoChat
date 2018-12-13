import Vapor
import FluentPostgreSQL

final class Room: Content {
    public static var createdAtKey: TimestampKey? { return \.createdAt }
    public static var updatedAtKey: TimestampKey? { return \.updatedAt }
    public static var deletedAtKey: TimestampKey? { return \.deletedAt }
    
    var id: UUID?
    var name: String
    var shared: Bool = false
    var members: [User.ID]
    var createdAt, updatedAt, deletedAt: Date?
    
    init(id: Room.ID? = nil, name: String, shared: Bool, members: [User.ID]) {
        self.id = id
        self.name = name
        self.shared = shared
        self.members = members
    }
}

extension Room: PostgreSQLUUIDModel {}
extension Room: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
        }
    }
}
