import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    AuthController(router)
    MessageController(router)
    RoomController(router)
}
