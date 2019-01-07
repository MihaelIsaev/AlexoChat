import Foundation
import Vapor
import FluentPostgreSQL

final class Room: Content {
    public static var createdAtKey: TimestampKey? { return \.createdAt }
    public static var updatedAtKey: TimestampKey? { return \.updatedAt }
    public static var deletedAtKey: TimestampKey? { return \.deletedAt }
    
    var id: UUID?
    var name: String?
    var type: RoomType
    var members: [User.ID]
    var owners: [User.ID]?
    var createdAt, updatedAt, deletedAt: Date?
    
    init(id: Room.ID? = nil, name: String? = nil, type: RoomType, members: [User.ID], owners: [User.ID]? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.members = members
        self.owners = owners
    }
}

extension Room: PostgreSQLUUIDModel {}
extension Room: Parameter {}
extension Room: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
        }
    }
}
extension Room {
    func saveImage(data: Data) throws {
        guard let id = id else { throw Abort(.internalServerError, reason: "Unable to save image cause room's id is nil") }
        let workDir = DirectoryConfig.detect().workDir
        let imageFolder = workDir.appending("/Public").appending(Room.Public.imagePath)
        let filePath = imageFolder.appending(id.uuidString + ".jpg")
        try data.write(to: URL(fileURLWithPath: filePath))
    }
}
