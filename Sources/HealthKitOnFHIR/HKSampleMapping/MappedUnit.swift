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
        case unit
        case system
        case code
    }
    
    
    /// The specified `HKUnit` that should be mapped.
    public var hkunit: HKUnit
    /// <#Description#>
    public let unit: String
    /// <#Description#>
    public let system: URL?
    /// <#Description#>
    public let code: String?
    
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let hkunit = try HKUnit(from: values.decode(String.self, forKey: .hkunit))
        let unit = try values.decode(String.self, forKey: .unit)
        let system = try values.decodeIfPresent(URL.self, forKey: .system)
        let code = try values.decodeIfPresent(String.self, forKey: .code)
        
        self.init(
            hkunit: hkunit,
            unit: unit,
            system: system,
            code: code
        )
    }
    
    /// A ``MappedUnit`` instance is used to specify a unit mapping for FHIR observations mapped from HealthKit's `HKUnit`s.
    /// - Parameters:
    ///   - hkunit: The specified `HKUnit` that should be mapped.
    ///   - unit: <#unit description#>
    ///   - system: <#system description#>
    ///   - code: <#code description#>
    public init(
        hkunit: HKUnit,
        unit: String,
        system: URL?,
        code: String?
    ) {
        self.hkunit = hkunit
        self.unit = unit
        self.system = system
        self.code = code
    }
}
