// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VaultSwift",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8), .tvOS(.v15), .visionOS(.v1)],
    products: [
        .library(
            name: "VaultSwift",
            targets: ["VaultSwift"])
    ],
    targets: [
        .target(name: "VaultSwift")
    ]
)
