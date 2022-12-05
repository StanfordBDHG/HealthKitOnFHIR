//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct HKQuantitySampleMapping: Codable {
    public static let `default` = HKSampleMapping.default.quantitySampleMapping
    public let codes: [MappedCode]
    public let unit: MappedUnit


    public init(
        codes: [MappedCode],
        unit: MappedUnit
    ) {
        self.codes = codes
        self.unit = unit
    }
}
