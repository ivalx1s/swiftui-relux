// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftui-relux",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftUIRelux",
            targets: ["SwiftUIRelux"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ivalx1s/darwin-relux.git", .upToNextMajor(from: "7.0.1")),
        .package(url: "https://github.com/ivalx1s/swiftui-reluxrouter.git", .upToNextMajor(from: "6.0.2"))
    ],
    targets: [
        .target(
            name: "SwiftUIRelux",
            dependencies: [
                .product(name: "Relux", package: "darwin-relux"),
                .product(name: "ReluxRouter", package: "swiftui-reluxrouter"),
            ],
            path: "Sources"
        )
    ]
)
