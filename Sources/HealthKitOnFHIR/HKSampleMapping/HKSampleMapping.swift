//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``HKSampleMapping`` instance is used to specify the mapping of ``HKSample``s to FHIR observations allowing the customization of, e.g., codings and units.
public struct HKSampleMapping: Decodable {
    private enum CodingKeys: String, CodingKey {
        case quantitySampleMapping = "HKQuantitySample"
        case correlationMapping = "HKCorrelation"
    }
    
    
    /// A default instance of an ``HKSampleMapping`` instance allowing developers to customize the ``HKSampleMapping``.
    ///
    /// The default values are loaded from the `HKSampleMapping.json` resource in the ``HealthKitOnFHIR`` Swift Package.
    public static let `default`: HKSampleMapping = {
        Bundle.module.decode(HKSampleMapping.self, from: "HKSampleMapping.json")
    }()
    
    
    /// The ``HKSampleMapping/quantitySampleMapping`` property defines the mapping of `HKQuantitySample`s to FHIR observations.
    /// ``HealthKitOnFHIR`` uses the string keys to identify the correct `HKQuantityType` using its `identifier` property.
    public var quantitySampleMapping: [String: HKQuantitySampleMapping]
    /// The ``HKSampleMapping/correlationMapping`` property defines the mapping of `HKCorrelation`s to FHIR observations.
    /// ``HealthKitOnFHIR`` uses the string keys to identify the correct `HKCorrelationType` using its `identifier` property.
    public var correlationMapping: [String: HKCorrelationMapping]
    
    
    public init(from decoder: Decoder) throws {
        let mappings = try decoder.container(keyedBy: CodingKeys.self)
        let quantitySampleMapping = try mappings.decode(
            Dictionary<String, HKQuantitySampleMapping>.self,
            forKey: .quantitySampleMapping
        )
        let correlationMapping = try mappings.decode(
            Dictionary<String, HKCorrelationMapping>.self,
            forKey: .correlationMapping
        )
        self.init(
            quantitySampleMapping: quantitySampleMapping,
            correlationMapping: correlationMapping
        )
    }
    
    /// A ``HKSampleMapping`` instance is used to specify the mapping of ``HKSample``s to FHIR observations allowing the customization of, e.g., codings and units.
    /// - Parameters:
    ///   - quantitySampleMapping: The ``HKSampleMapping/quantitySampleMapping`` property defines the mapping of `HKQuantitySample`s to FHIR observations.
    ///                            ``HealthKitOnFHIR`` uses the string keys to identify the correct `HKQuantityType` using its `identifier` property.
    ///   - correlationMapping: The ``HKSampleMapping/correlationMapping`` property defines the mapping of `HKCorrelation`s to FHIR observations.
    ///                         ``HealthKitOnFHIR`` uses the string keys to identify the correct `HKCorrelationType` using its `identifier` property.
    public init(
        quantitySampleMapping: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default,
        correlationMapping: [String: HKCorrelationMapping] = HKCorrelationMapping.default
    ) {
        for mapping in quantitySampleMapping {
            guard HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: mapping.key)) != nil else {
                fatalError("HKQuantityType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
            }
        }
        self.quantitySampleMapping = quantitySampleMapping
        
        for mapping in correlationMapping {
            guard HKCorrelationType.correlationType(forIdentifier: HKCorrelationTypeIdentifier(rawValue: mapping.key)) != nil else {
                fatalError("HKCorrelationType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
            }
        }
        self.correlationMapping = correlationMapping
    }
}
