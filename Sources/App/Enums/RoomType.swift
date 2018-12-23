import Foundation
import FluentPostgreSQL

enum RoomType: String, PostgreSQLEnum, PostgreSQLMigration {
    case open, closed, direct
}
