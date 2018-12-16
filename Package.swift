// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "AlexoChat",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/auth.git", from:"2.0.0"),
        .package(url: "https://github.com/MihaelIsaev/VaporWs.git", .branch("master")),
    ],
    targets: [
        .target(name: "App", dependencies: ["WS", "Authentication", "FluentPostgreSQL", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

