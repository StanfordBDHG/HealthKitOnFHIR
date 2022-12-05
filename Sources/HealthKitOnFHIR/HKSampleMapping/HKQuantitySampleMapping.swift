//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct HKQuantitySampleMapping: Codable {
    public static let `default`: [String: HKQuantitySampleMapping] = {
        var mappings = HKSampleMapping.default.quantitySampleMapping
        for mapping in mappings {
            guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: mapping.key)) else {
                fatalError("HKQuantityType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
            }

            // Unfortunately this method throws an Objective-C exception when an error occurs, we can not catch this here.
            _ = HKUnit(from: mapping.value.unit.hkunit)
        }
        return mappings
    }()


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
