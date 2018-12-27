import Vapor

final class UserController {
    @discardableResult
    init(_ router: Router) {
        let usersGroup = router.grouped("users").guardedByToken()
        usersGroup.get(use: listAll)
        let profileGroup = usersGroup.grouped("profile")
        profileGroup.get(use: getProfile)
    }
}
