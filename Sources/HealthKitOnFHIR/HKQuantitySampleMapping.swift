//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public struct HKQuantitySampleMapping: Codable {
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
    
    public struct Unit: Codable {
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
    
    
    public static let `default`: [String: HKQuantitySampleMapping] = {
        let mappings = Bundle.module.decode([String: HKQuantitySampleMapping].self, from: "HKQuantitySampleMapping.json")
        
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
    public let unit: Unit
    
    
    public init(
        codes: [MappedCode],
        unit: Unit
    ) {
        self.codes = codes
        self.unit = unit
    }
}
