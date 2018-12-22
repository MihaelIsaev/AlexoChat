import Vapor
import WS

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("wstest") { req -> Future<HTTPStatus> in
        let ws = try req.make(WS.self)
        let client = try ws.requireClientByAuthToken(on: req)
        return client.emit("hello", on: req).transform(to: .ok)
    }
    AuthController(router)
    MessageController(router)
    RoomController(router)
}
