// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AgoraVideoSwiftUI",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "AgoraVideoSwiftUI", targets: ["AgoraVideoSwiftUI"]),
    ],
    dependencies: [
         .package(url: "https://github.com/AgoraIO/AgoraRtcEngine_iOS", from: "4.1.1"),
    ],
    targets: [
        .target(
            name: "AgoraVideoSwiftUI",
            dependencies: [.product(name: "RtcBasic", package: "AgoraRtcEngine_iOS")]
        ),
        .testTarget(
            name: "AgoraVideoSwiftUITests",
            dependencies: ["AgoraVideoSwiftUI"]),
    ]
)
