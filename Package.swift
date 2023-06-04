// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RestaurantGame",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(
            name: "RestaurantGame",
            targets: ["RestaurantGame"])
    ],
    dependencies: [
        .package(url: "https://github.com/STREGAsGate/GateEngine", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "RestaurantGame",
            dependencies: [
                "GateEngine",
                "GateUI",
                "JAsync"
            ],
            resources: [.copy("Resources")]
        ),
        .target(name: "JAsync"),
        .target(name: "GateUI",
                dependencies: ["GateEngine"]),
        .testTarget(
            name: "RestaurantGameTests",
            dependencies: ["RestaurantGame"]),
    ]
)
