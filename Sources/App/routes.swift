import Vapor
import WS

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("wstest") { req -> Future<HTTPStatus> in
        let ws = try req.make(WS.self)
        return try ws.broadcast("any text", on: req).transform(to: .ok)
    }
    AuthController(router)
    MessageController(router)
    RoomController(router)
}
