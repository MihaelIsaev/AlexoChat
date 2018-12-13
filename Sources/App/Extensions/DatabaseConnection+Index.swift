import Vapor
import FluentPostgreSQL

public protocol IndexKP {
    var modelName: String { get }
    var fullPath: String { get }
}

extension KeyPath: IndexKP where Root: Model {
    var pp: [String] {
        if let pp = try? Root.reflectProperty(forKey: self)?.path, let pathParts = pp {
            return pathParts
        }
        return []
    }
    
    public var modelName: String {
        return Root.entity
    }
    
    public var fullPath: String {
        return pp.joined(separator: "->")
    }
}

extension PostgreSQLConnection {
    func addIndexes(_ keypaths: IndexKP...) -> EventLoopFuture<Void> {
        return simpleQuery(keypaths.map { kp in
            var result = "CREATE INDEX "
            result.append("\"idx:\(kp.modelName).\(kp.fullPath)\"")
            result.append(" ON ")
            result.append("\"\(kp.modelName)\"")
            result.append(" ")
            result.append("(\"\(kp.fullPath)\")")
            return result
        }.joined(separator: ";")).transform(to: ())
    }
}
