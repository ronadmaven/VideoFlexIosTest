// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDK",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SDK",
            targets: ["SDK"]
        )
    ],

    targets: [
        .target(
            name: "SDK"
        ),
        .testTarget(
            name: "SDKTests",
            dependencies: ["SDK"]
        )
    ]
)
