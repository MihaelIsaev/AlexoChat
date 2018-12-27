import Vapor

extension User {
    final class Public: Content {
        var id: UUID?
        var email, nickname: String
        var isAdmin: Bool = false
        
        init(_ user: User) {
            self.id = user.id
            self.email = user.email
            self.nickname = user.nickname
            self.isAdmin = user.isAdmin == true
        }
    }
}
