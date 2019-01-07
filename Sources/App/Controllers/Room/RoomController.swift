import Vapor

final class RoomController {
    @discardableResult
    init(_ router: Router) {
        let roomsGroup = router.grouped("rooms").guardedByToken()
        roomsGroup.delete(Room.parameter, use: delete)
        roomsGroup.post(CreateRequest.self, use: create)
        roomsGroup.post(AddImagePayload.self, at: Room.parameter, use: addImage)
        roomsGroup.post(Room.parameter, User.parameter, use: addMember)
        roomsGroup.get(use: listAll)
        roomsGroup.get("my", use: listMy)
        roomsGroup.get(String.parameter, use: search)
    }
}
