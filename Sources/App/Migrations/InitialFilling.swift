import FluentPostgreSQL
import Crypto

struct InitialFilling: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let insertions = [createUser(email: "admin@admin.com", password: "qwerty", nickname: "admin", isAdmin: true, on: conn)]
        return insertions.flatten(on: conn)
    }
    static func revert(on conn: PostgreSQLConnection) -> Future<Void> {
        let deletions = [User.query(on: conn).delete()]
        return deletions.flatten(on: conn)
    }
}

extension InitialFilling {
    static func createUser(email: String, password: String, nickname: String, isAdmin: Bool, on conn: PostgreSQLConnection) -> Future<Void> {
        let password = try? BCrypt.hash(password)
        guard let hashedPassword = password else {
            fatalError("Failed to create admin user")
        }
        let user = User(email: email, password: hashedPassword, nickname: nickname, isAdmin: isAdmin)
        return user.save(on: conn).transform(to: ())
    }
}
