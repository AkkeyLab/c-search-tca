// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
        .library(
            name: "Clip",
            targets: ["Clip"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.48.0"),
        .package(url: "https://github.com/ishkawa/APIKit", from: "5.4.0"),
        .package(url: "https://github.com/CoreOffice/XMLCoder", from: "0.15.0"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.0"),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                "Domain",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources"),
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
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
        .target(
            name: "Clip",
            dependencies: [
                "Domain",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .testTarget(
            name: "PackageTests",
            dependencies: [
                "Data",
                "Domain",
            ]),
    ]
)
