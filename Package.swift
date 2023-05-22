// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIRtc",
    platforms: [.iOS(.v14)], // .macOS(.v12)],
    products: [
        .library(name: "SwiftUIRtc", targets: ["SwiftUIRtc"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AgoraIO/AgoraRtcEngine_iOS", from: "4.1.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIRtc",
            dependencies: [
                .product(name: "RtcBasic", package: "AgoraRtcEngine_iOS"),
            ]
        ),
        .testTarget(
            name: "SwiftUIRtcTests",
            dependencies: ["SwiftUIRtc"]),
    ]
)
