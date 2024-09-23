// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "Search",
            targets: ["Search"]),
        .library(
            name: "Clip",
            targets: ["Clip"]),
        .library(
            name: "Widget",
            targets: ["Widget"]),
        .library(
            name: "Activity",
            targets: ["Activity"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.0"),
        .package(url: "https://github.com/CoreOffice/XMLCoder", from: "0.17.1"),
    ],
    targets: [
        .target(
            name: "Search",
            dependencies: [
                "Domain",
                "Company",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources"),
            ]),
        .target(
            name: "Company",
            dependencies: [
                "Domain",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources"),
            ]),
        .target(
            name: "Domain",
            dependencies: [
                "Data",
                "Activity",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "Data",
            dependencies: ["XMLCoder", "Extension"]),
        .target(
            name: "Extension",
            dependencies: []),
        .target(
            name: "Clip",
            dependencies: [
                "Domain",
                "Company",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "Widget",
            dependencies: [
                "Extension",
            ],
            resources: [
                .process("Resources"),
            ]),
        .target(
            name: "Activity",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]),
        .testTarget(
            name: "PackageTests",
            dependencies: [
                "Data",
                "Domain",
            ]),
    ]
)
