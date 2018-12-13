import Vapor
import FluentPostgreSQL
import Authentication

final class User: Content {
    public static var createdAtKey: TimestampKey? { return \.createdAt }
    public static var updatedAtKey: TimestampKey? { return \.updatedAt }
    public static var deletedAtKey: TimestampKey? { return \.deletedAt }
    
    var id: UUID?
    var email, password, nickname: String
    var admin: Bool = false
    var createdAt, updatedAt, deletedAt: Date?
    
    init(id: User.ID? = nil, email: String, password: String, nickname: String, admin: Bool) {
        self.id = id
        self.email = email
        self.password = password
        self.nickname = nickname
        self.admin = admin
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.email)
        }
    }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.email
    static let passwordKey: PasswordKey = \User.password
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, email: email, nickname: nickname)
    }
}

extension Future where T: User {
    func convertToPublic() -> Future<User.Public> {
        return map(to: User.Public.self) { user in
            return user.convertToPublic()
        }
    }
}
