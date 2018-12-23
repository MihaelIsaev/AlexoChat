import Foundation
import Vapor
import FluentQuery

extension RoomController {
    func listAll(_ req: Request) throws -> Future<[Room]> {
        let user = try req.requireAuthenticated(User.self)
        guard user.isAdmin == true else { throw Abort(.forbidden) }
        return Room.query(on: req).all()
    }
}
