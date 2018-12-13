import Vapor
import FluentPostgreSQL

extension PostgreSQLDatabaseConfig {
    init() {
        let pgHost = Environment.get("PG_HOST") ?? "127.0.0.1"
        let pgPort = Environment.get("PG_PORT") ?? "5432"
        let pgUser = Environment.get("PG_USER") ?? "postgres"
        let pgPassword = Environment.get("PG_PWD")
        let pgDatabase = Environment.get("PG_DB")
        self.init(hostname: pgHost, port: Int(pgPort) ?? 5432, username: pgUser, database: pgDatabase, password: pgPassword)
    }
}
