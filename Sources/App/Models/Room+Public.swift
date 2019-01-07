import Vapor

extension Room {
    struct Public: Content {
        static var imagePath = "/Rooms/Images/"
        
        var id: UUID
        var name: String?
        var type: RoomType
        /// Relative image link
        var imageLink: String
        var members: [User.ID]
        var owners: [User.ID]?
        var createdAt, updatedAt: Date?
        
        init (_ room: Room) {
            id = room.id ?? UUID()
            name = room.name
            type = room.type
            imageLink = Public.imagePath + id.uuidString + ".jpg"
            members = room.members
            owners = room.owners
            createdAt = room.createdAt
            updatedAt = room.updatedAt
        }
    }
}
