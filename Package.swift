// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "CustomModule",
    products: [
        .library(
            name: "CustomModule",
            targets: ["CustomModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBDecodable/IBLinter.git", from: "0.4.0"),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.21.1"),
    ],
    targets: [
        .target(
            name: "CustomModule",
            dependencies: ["IBLinterKit", "SourceKittenFramework"]),
        .testTarget(
            name: "CustomModuleTests",
            dependencies: ["CustomModule"]),
    ]
)
