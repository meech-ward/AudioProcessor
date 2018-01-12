// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "AudioIO",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AudioIO",
            targets: ["AudioIO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ObserveSocial/Observe", from: "0.4.0"),
        .package(url: "https://github.com/ObserveSocial/Focus", from: "0.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AudioIO",
            dependencies: []),
        .testTarget(
            name: "AudioIOTests",
            dependencies: ["AudioIO", "Observe", "Focus"]),
    ]
)
