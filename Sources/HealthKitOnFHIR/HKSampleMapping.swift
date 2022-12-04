//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable type_contents_order file_types_order
public struct HKSampleMapping: Codable {
    public let quantitySampleMapping: [String: HKQuantitySampleMapping]
    public let correlationMapping: [String: HKCorrelationMapping]

    public static let `default`: HKSampleMapping = {
        Bundle.module.decode(HKSampleMapping.self, from: "HKSampleMapping.json")
    }()

    public init(
        hkQuantitySampleMapping: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default,
        hkCorrelationMapping: [String: HKCorrelationMapping] = HKCorrelationMapping.default
    ) {
        self.correlationMapping = hkCorrelationMapping
        self.quantitySampleMapping = hkQuantitySampleMapping
    }
}

public struct HKCorrelationMapping: Codable {
    public let codes: [MappedCode]
    public let categories: [MappedCode]

    public static let `default`: [String: HKCorrelationMapping] = {
        var mappings = HKSampleMapping.default.correlationMapping
        for mapping in mappings {
            guard let correlationType = HKCorrelationType.correlationType(forIdentifier: HKCorrelationTypeIdentifier(rawValue: mapping.key)) else {
                fatalError("HKCorrelationType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
            }
        }
        return mappings
    }()
}

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

public struct MappedUnit: Codable {
    public let hkunit: String
    public let unitAlias: String?


    public init(
        hkunit: String,
        unitAlias: String?
    ) {
        self.hkunit = hkunit
        self.unitAlias = unitAlias
    }
}

public struct MappedCode: Codable {
    public let code: String
    public let display: String
    public let system: String


    public init(
        code: String,
        display: String,
        system: String
    ) {
        self.code = code
        self.display = display
        self.system = system
    }
}
