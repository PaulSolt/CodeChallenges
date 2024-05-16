// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LRU Cache",
    products: [
        .library(
            name: "LRU Cache",
            targets: ["LRU Cache"]),
    ],
    targets: [
        .target(
            name: "LRU Cache"),
        .testTarget(
            name: "LRU CacheTests",
            dependencies: ["LRU Cache"]),
    ]
)
