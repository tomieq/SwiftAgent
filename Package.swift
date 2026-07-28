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
    ],
    dependencies: [
        .package(url: "https://github.com/tomieq/WebResponse", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftAgent",
            dependencies: [
                .product(name: "WebResponse", package: "WebResponse")
            ]
        ),
        .testTarget(
            name: "SwiftAgentTests",
            dependencies: ["SwiftAgent"]
        ),
    ]
)
