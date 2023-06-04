// swift-tools-version: 5.7

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
                "JAsync",
                "KeyboardLayout"
            ],
            resources: [.copy("Resources")]
        ),
        .target(name: "JAsync",
                exclude: ["README.md"]),
        .target(name: "GateUI",
                dependencies: ["GateEngine"]),
        .target(name: "KeyboardLayout_mac",
                path: "Sources/KeyboardLayout/mac"),
        .target(name: "KeyboardLayout",
                dependencies: {
                    var dependencies: [Target.Dependency] = ["GateEngine"]
                    #if os(macOS)
                    dependencies.append("KeyboardLayout_mac")
                    #endif
                    return dependencies
                }(),
                path: "Sources/KeyboardLayout/shared"
        ),
        .testTarget(
            name: "RestaurantGameTests",
            dependencies: ["RestaurantGame"]),
    ]
)
