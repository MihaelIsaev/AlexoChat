import Vapor
import FluentPostgreSQL
import Authentication
import WS

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a PSQL database
    let database = PostgreSQLDatabase(config: PostgreSQLDatabaseConfig())
    var databaseConfig = DatabasesConfig()
    databaseConfig.add(database: database, as: .psql)
    //databaseConfig.enableLogging(on: .psql)
    services.register(databaseConfig)
    
    //By default here only 1 opened connection and that's it!
    let poolConfig = DatabaseConnectionPoolConfig(maxConnections: 100)
    services.register(poolConfig)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(migration: RoomType.self, database: .psql)
    migrations.add(model: Room.self, database: .psql)
    migrations.add(model: Message.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(migration: InitialFilling.self, database: .psql)
    services.register(migrations)
    
    // Register WebSocket Handler
    let tokenAuthMiddleware = User.tokenAuthMiddleware()
    let guardAuthMiddleware = User.guardAuthMiddleware()
    
    let ws = WS(at: "ws", protectedBy: [tokenAuthMiddleware, guardAuthMiddleware], delegate: WSController())
    ws.logger.level = .debug
    services.register(ws, as: WebSocketServer.self)
}
