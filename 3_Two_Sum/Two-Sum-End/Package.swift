// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Two-Sum",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Two-Sum",
            targets: ["Two-Sum"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Two-Sum"),
        .testTarget(
            name: "Two-SumTests",
            dependencies: ["Two-Sum"]),
    ]
)
