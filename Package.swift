// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftAgent",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftAgent",
            targets: ["SwiftAgent"]
        ),
        .library(
            name: "MCPAdapter",
            targets: ["MCPAdapter"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/tomieq/WebResponse", branch: "master"),
        .package(url: "https://github.com/tomieq/SwiftExtensions", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/tomieq/Logger", .upToNextMajor(from: "1.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftAgent",
            dependencies: [
                .product(name: "WebResponse", package: "WebResponse"),
                .product(name: "SwiftExtensions", package: "SwiftExtensions"),
                .product(name: "Logger", package: "Logger")
            ]
        ),
        .target(
            name: "MCPAdapter",
            dependencies: [
                .target(name: "SwiftAgent")
            ]
        ),
        .testTarget(
            name: "SwiftAgentTests",
            dependencies: ["SwiftAgent"]
        ),
        .testTarget(
            name: "MCPAdapterTests",
            dependencies: ["MCPAdapter"]
        )
    ]
)
