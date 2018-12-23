import Foundation
import Vapor
import FluentQuery

extension RoomController {
    func search(_ req: Request) throws -> Future<[Room]> {
        let query = try req.parameters.next(String.self)
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return req.requestPooledConnection(to: .psql).flatMap { conn in
            let fq = FQL()
            fq.select(all: Room.self)
            fq.from(Room.self)
            fq.where(\Room.deletedAt == nil && \Room.members !~~ [userId] && \Room.name %% query)
            return try fq.execute(on: conn, andDecode: Room.self)
        }
    }
}
