// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
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
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.48.0"),
        .package(url: "https://github.com/ishkawa/APIKit", from: "5.4.0"),
        .package(url: "https://github.com/CoreOffice/XMLCoder", from: "0.15.0"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
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
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        .target(
            name: "Company",
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
                "Activity",
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
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        .target(
            name: "Activity",
            dependencies: [],
            resources: [
                .process("Resources"),
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        .testTarget(
            name: "PackageTests",
            dependencies: [
                "Data",
                "Domain",
            ]),
    ]
)
