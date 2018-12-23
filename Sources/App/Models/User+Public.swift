import Vapor

extension User {
    final class Public: Content {
        var id: UUID?
        var email, nickname: String
        
        init(_ user: User) {
            self.id = user.id
            self.email = user.email
            self.nickname = user.nickname
        }
        
        init(id: UUID?, email: String, nickname: String) {
            self.id = id
            self.email = email
            self.nickname = nickname
        }
    }
}
