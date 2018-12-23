import Foundation
import Vapor
import WS
import FluentQuery

class WSController: WSBindController {
    override func onOpen(_ client: WSClient) {
        guard let user: User = try? client.req.requireAuthenticated() else { print("user not authenticated"); return }
        _ = client.req.requestPooledConnection(to: .psql).flatMap { conn -> Future<Void> in
            let fq = FQL().select(all: Room.self).from(Room.self)
            fq.where(\Room.deletedAt == nil && \Room.members ~~ [user.id!]) //FIXME: ~~ operator doesn't work, should use SwifQL lib instead
            return try fq.execute(on: conn, andDecode: Room.self).map { rooms in
                var channels = rooms.compactMap { $0.id?.uuidString }
                channels.append(user.id!.uuidString)
                client.subscribe(to: channels)
            }
        }.catchMap { error in
            print("subscribe error: \(error)")
        }.always {
            print("connected user subscribed")
        }
    }
    override func onClose(_ client: WSClient) {}
}
