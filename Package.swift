// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DoubanParser",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DoubanParser",
            targets: ["DoubanParser"]),
    ],
    dependencies: [
        .package(url: "github.com/scinfu/SwiftSoup.git", from: "2.7.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DoubanParser",
            dependencies: ["SwiftSoup"]
        ),
        .testTarget(
            name: "DoubanParserTests",
            dependencies: ["DoubanParser"],
            resources: [
                .process("Resources")
            ]),
    ]
)
