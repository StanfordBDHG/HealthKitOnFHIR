// swift-tools-version:6.2

//
// This source file is part of the HealthKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import CompilerPluginSupport
import class Foundation.ProcessInfo
import PackageDescription


let package = Package(
    name: "HealthKitOnFHIR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10)
    ],
    products: [
        .library(name: "HealthKitOnFHIR", targets: ["HealthKitOnFHIR"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels.git", .upToNextMajor(from: "0.7.0")),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.1")
    ] + swiftLintPackage(),
    targets: [
        .macro(
            name: "HealthKitOnFHIRMacrosImpl",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        ),
        .target(
            name: "HealthKitOnFHIRMacros",
            dependencies: [
                .target(name: "HealthKitOnFHIRMacrosImpl")
            ]
        ),
        .target(
            name: "HealthKitOnFHIR",
            dependencies: [
                .target(name: "HealthKitOnFHIRMacros"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "HealthKitOnFHIRTests",
            dependencies: [
                .target(name: "HealthKitOnFHIR")
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "HealthKitOnFHIRMacrosTests",
            dependencies: [
                .target(name: "HealthKitOnFHIRMacros"),
                .target(name: "HealthKitOnFHIRMacrosImpl"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)


func swiftLintPlugin() -> [Target.PluginUsage] {
    // Fully quit Xcode and open again with `open --env SPEZI_DEVELOPMENT_SWIFTLINT /Applications/Xcode.app`
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
    } else {
        []
    }
}

func swiftLintPackage() -> [PackageDescription.Package.Dependency] {
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.package(url: "https://github.com/realm/SwiftLint.git", from: "0.55.1")]
    } else {
        []
    }
}
