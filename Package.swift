// swift-tools-version:5.7

//
// This source file is part of the HealthKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "HealthKitOnFHIR",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "HealthKitOnFHIR", targets: ["HealthKitOnFHIR"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels.git", .upToNextMajor(from: "0.4.0"))
    ],
    targets: [
        .target(
            name: "HealthKitOnFHIR",
            dependencies: [
                .product(name: "ModelsR4", package: "FHIRModels")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "HealthKitOnFHIRTests",
            dependencies: [
                .target(name: "HealthKitOnFHIR")
            ]
        )
    ]
)
