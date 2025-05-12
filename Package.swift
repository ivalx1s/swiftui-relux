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
        .package(url: "https://github.com/ivalx1s/darwin-relux.git", .upToNextMajor(from: "8.2.0")),
        .package(url: "https://github.com/ivalx1s/swiftui-reluxrouter.git", .upToNextMajor(from: "9.0.0"))
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
