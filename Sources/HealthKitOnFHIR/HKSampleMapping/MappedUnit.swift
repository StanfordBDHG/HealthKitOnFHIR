//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``MappedUnit`` instance is used to specify a unit mapping for FHIR observations mapped from HealthKit's `HKUnit`s.
public struct MappedUnit: Decodable {
    private enum CodingKeys: String, CodingKey {
        case hkunit
        case unitAlias
    }
    
    
    /// The specified `HKUnit` that should be mapped.
    public var hkunit: HKUnit
    /// The unit alias that is used for the FHIR obseration.
    public var unitAlias: String?
    
    
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let hkunit = try HKUnit(from: values.decode(String.self, forKey: .hkunit))
        let unitAlias = try values.decodeIfPresent(String.self, forKey: .unitAlias)
        
        self.init(hkunit: hkunit, unitAlias: unitAlias)
    }
    
    /// A ``MappedUnit`` instance is used to specify a unit mapping for FHIR observations mapped from HealthKit's `HKUnit`s.
    /// - Parameters:
    ///   - hkunit: The specified `HKUnit` that should be mapped.
    ///   - unitAlias: The unit alias that is used for the FHIR obseration.
    public init(
        hkunit: HKUnit,
        unitAlias: String?
    ) {
        self.hkunit = hkunit
        self.unitAlias = unitAlias
    }
}
