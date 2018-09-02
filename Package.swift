// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "CustomModule",
    products: [
        .library(
            name: "CustomModule",
            targets: ["CustomModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBDecodable/IBLinter.git", .revision("5e9af9735360c85e3071826e364619f57243426e")),
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
