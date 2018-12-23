import Foundation
import Vapor
import FluentSQL

extension RoomController {
    struct CreateRequest: Content {
        var name: String
        var shared: Bool
    }
    
    func create(_ req: Request, payload: CreateRequest) throws -> Future<Room> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return Room(name: payload.name, type: payload.shared ? .open : .closed, members: [userId], owners: [userId]).create(on: req)
    }
}
