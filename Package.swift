// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "tcakit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "ComposableArchitectureKit", targets: ["ComposableArchitectureKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.38.3"),
    ],
    targets: [
        .target(
            name: "ComposableArchitectureKit",
            dependencies: [.product(name: "ComposableArchitecture", package: "swift-composable-architecture")],
            path: "Sources"
        ),
        .testTarget(
            name: "ComposableArchitectureKitTests",
            dependencies: ["ComposableArchitectureKit"],
            path: "Tests"
        ),
    ]
)
