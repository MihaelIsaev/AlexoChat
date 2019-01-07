import Foundation
import Vapor
import FluentQuery

extension RoomController {
    func search(_ req: Request) throws -> Future<[Room.Public]> {
        let query = try req.parameters.next(String.self)
        let user = try req.requireAuthenticated(User.self)
        guard let userId = user.id else { throw Abort(.internalServerError) }
        return req.requestPooledConnection(to: .psql).flatMap { conn in
            defer { try? req.releasePooledConnection(conn, to: .psql) }
            let fq = FQL()
            fq.select(all: Room.self)
            fq.from(Room.self)
            fq.where(\Room.deletedAt == nil && FQWhere("members @> ARRAY['\(userId.uuidString)']::uuid[]") && \Room.name %% query) //FIXME: ~~ operator doesn't work, should use SwifQL lib instead
            return try fq.execute(on: conn, andDecode: Room.self).map {
                return $0.map { $0.convertToPublic() }
            }
        }
    }
}
