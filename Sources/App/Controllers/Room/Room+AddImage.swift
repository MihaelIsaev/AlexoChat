import Foundation
import Vapor
import FluentQuery

extension RoomController {
    struct AddImagePayload: Content {
        let image: File
    }
    
    func addImage(_ req: Request, payload: AddImagePayload) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Room.self).map { room in
            try room.saveImage(data: payload.image.data)
            return .ok
        }
    }
}
