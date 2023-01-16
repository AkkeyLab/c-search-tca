// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
        .library(
            name: "Domain",
            targets: ["Domain"]),
        .library(
            name: "Data",
            targets: ["Data"]),
        .library(
            name: "Extension",
            targets: ["Extension"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.48.0"),
        .package(url: "https://github.com/ishkawa/APIKit", from: "5.4.0"),
        .package(url: "https://github.com/CoreOffice/XMLCoder", from: "0.15.0"),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                "Domain",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "Domain",
            dependencies: [
                "Data",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "Data",
            dependencies: ["APIKit", "XMLCoder", "Extension"]),
        .target(
            name: "Extension",
            dependencies: []),
        .testTarget(
            name: "PackageTests",
            dependencies: [
                "Data",
                "Domain",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
    ]
)
