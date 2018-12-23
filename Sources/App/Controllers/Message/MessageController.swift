import Vapor

final class MessageController {
    @discardableResult
    init(_ router: Router) {
        let messagesGroup = router.grouped("messages").guardedByToken()
        messagesGroup.post(SendDirectPayload.self, use: sendToUser)
        messagesGroup.post(SendGroupPayload.self, use: sendToGroup)
        messagesGroup.patch(EditPayload.self, at: Message.parameter, use: edit)
        messagesGroup.delete(Message.parameter, use: delete)
        messagesGroup.get(Room.parameter, use: list)
    }
}
