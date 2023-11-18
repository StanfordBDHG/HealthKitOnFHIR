//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import HealthKit


public struct HKWorkoutSampleMapping: Decodable {
    public static let `default` = HKSampleMapping.default.workoutSampleMapping

    public var codings: [MappedCode]
    public var categories: [MappedCode]

    public init(
        codings: [MappedCode],
        categories: [MappedCode]
    ){
        self.codings = codings
        self.categories = categories
    }
}
