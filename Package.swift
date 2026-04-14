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

/// Whether the package should run SwiftLint as part of its build process.
///
/// Set this to `false` before committing any changes.
let enableSwiftLintPlugin = false


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
        .package(url: "https://github.com/apple/FHIRModels.git", "0.8.0"..<"0.9.0"),
        .package(url: "https://github.com/StanfordBDHG/FHIRModelsExtensions.git", from: "0.1.1"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.1"),
        .package(url: "https://github.com/StanfordSpezi/SpeziFoundation.git", from: "2.7.0")
    ] + swiftLintPackage,
    targets: [
        .macro(
            name: "HealthKitOnFHIRMacrosImpl",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")],
            plugins: [] + swiftLintPlugin
        ),
        .target(
            name: "HealthKitOnFHIRMacros",
            dependencies: [
                .target(name: "HealthKitOnFHIRMacrosImpl")
            ],
            plugins: [] + swiftLintPlugin
        ),
        .target(
            name: "HealthKitOnFHIR",
            dependencies: [
                .target(name: "HealthKitOnFHIRMacros"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "FHIRModelsExtensions", package: "FHIRModelsExtensions")
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")],
            plugins: [] + swiftLintPlugin
        ),
        .testTarget(
            name: "HealthKitOnFHIRTests",
            dependencies: [
                .target(name: "HealthKitOnFHIR"),
                .product(name: "SpeziFoundation", package: "SpeziFoundation")
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")],
            plugins: [] + swiftLintPlugin
        ),
        .testTarget(
            name: "HealthKitOnFHIRMacrosTests",
            dependencies: [
                .target(name: "HealthKitOnFHIRMacros"),
                .target(name: "HealthKitOnFHIRMacrosImpl"),
                .product(name: "FHIRModelsExtensions", package: "FHIRModelsExtensions"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ],
            plugins: [] + swiftLintPlugin
        )
    ]
)


// MARK: SwiftLint support

var swiftLintPlugin: [Target.PluginUsage] {
    if enableSwiftLintPlugin {
        [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    } else {
        []
    }
}

var swiftLintPackage: [PackageDescription.Package.Dependency] {
    if enableSwiftLintPlugin {
        [.package(url: "https://github.com/SimplyDanny/SwiftLintPlugins.git", from: "0.63.2")]
    } else {
        []
    }
}
