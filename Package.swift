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
        .target(name: "JAsync"),
        .target(name: "GateUI",
                dependencies: ["GateEngine"]),
        .target(name: "KeyboardLayout",
                sources: {
                    var sources = ["Sources/KeyboardLayout/keyboardLayout.swift"]
                    #if os(macOS)
                    sources.append("Sources/KeyboardLayout/mac")
                    #endif
                    return sources
                }()),
        
        .testTarget(
            name: "RestaurantGameTests",
            dependencies: ["RestaurantGame"]),
    ]
)
