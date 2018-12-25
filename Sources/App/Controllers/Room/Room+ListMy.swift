import Foundation
import Vapor
import FluentQuery

extension RoomController {
    func listMy(_ req: Request) throws -> Future<[Room]> {
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return req.requestPooledConnection(to: .psql).flatMap { conn in
            let fq = FQL()
            fq.select(all: Room.self)
            fq.from(Room.self)
            fq.where(\Room.deletedAt == nil && FQWhere("members @> ARRAY['\(userId.uuidString)']::uuid[]")) //FIXME: ~~ operator doesn't work, should use SwifQL lib instead
            return try fq.execute(on: conn, andDecode: Room.self)
        }
    }
}
