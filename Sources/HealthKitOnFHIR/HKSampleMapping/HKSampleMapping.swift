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
        case quantitySampleMapping = "HKQuantitySamples"
        case categorySampleMapping = "HKCategorySamples"
        case correlationMapping = "HKCorrelations"
        case electrocardiogramMapping = "HKElectrocardiogram"
    }
    
    
    /// A default instance of an ``HKSampleMapping`` instance allowing developers to customize the ``HKSampleMapping``.
    ///
    /// The default values are loaded from the `HKSampleMapping.json` resource in the ``HealthKitOnFHIR`` Swift Package.
    public static let `default`: HKSampleMapping = {
        Bundle.module.decode(HKSampleMapping.self, from: "HKSampleMapping.json")
    }()
    
    
    /// The ``HKSampleMapping/quantitySampleMapping`` property defines the mapping of `HKQuantityType`s to FHIR observations.
    public var quantitySampleMapping: [HKQuantityType: HKQuantitySampleMapping]
    /// The ``HKSampleMapping/categorySampleMapping`` property defines the mapping of `HKCategoryType`s to FHIR observations.
    public var categorySampleMapping: [HKCategoryType: HKCategorySampleMapping]
    /// The ``HKSampleMapping/correlationMapping`` property defines the mapping of `HKCorrelationType`s to FHIR observations.
    public var correlationMapping: [HKCorrelationType: HKCorrelationMapping]
    /// The ``HKSampleMapping/electrocardiogramMapping`` property defines the mapping of  an`HKElectrocardiogramMapping` to a FHIR observation.
    public var electrocardiogramMapping: HKElectrocardiogramMapping
    
    
    public init(from decoder: Decoder) throws {
        let mappings = try decoder.container(keyedBy: CodingKeys.self)
        let quantityStringBasedSampleMapping = try mappings.decode(
            [String: HKQuantitySampleMapping].self,
            forKey: .quantitySampleMapping
        )
        let quantitySampleMapping = Dictionary(
            uniqueKeysWithValues: quantityStringBasedSampleMapping.map { mapping in
                guard let hkquantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: mapping.key)) else {
                    fatalError("HKQuantityType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
                }
                return (hkquantityType, mapping.value)
            }
        )

        let categoryStringBasedSampleMapping = try mappings.decode(
            [String: HKCategorySampleMapping].self,
            forKey: .categorySampleMapping
        )

        let categorySampleMapping = Dictionary(
            uniqueKeysWithValues: categoryStringBasedSampleMapping.map { mapping in
                guard let hkcategorytype = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: mapping.key)) else {
                    fatalError("HKCategoryType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
                }
                return (hkcategorytype, mapping.value)
            }
        )
        
        let correlationStringBasedMapping = try mappings.decode(
            [String: HKCorrelationMapping].self,
            forKey: .correlationMapping
        )
        
        let correlationMapping = Dictionary(
            uniqueKeysWithValues: correlationStringBasedMapping.map { mapping in
                let hkcorrelationTypeIdentifier = HKCorrelationTypeIdentifier(rawValue: mapping.key)
                guard let hkcorrelationType = HKCorrelationType.correlationType(forIdentifier: hkcorrelationTypeIdentifier) else {
                    fatalError("HKCorrelationType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
                }
                return (hkcorrelationType, mapping.value)
            }
        )
        
        let electrocardiogramMapping = try mappings.decode(HKElectrocardiogramMapping.self, forKey: .electrocardiogramMapping)
        
        self.init(
            quantitySampleMapping: quantitySampleMapping,
            categorySampleMapping: categorySampleMapping,
            correlationMapping: correlationMapping,
            electrocardiogramMapping: electrocardiogramMapping
        )
    }
    
    /// A ``HKSampleMapping`` instance is used to specify the mapping of ``HKSample``s to FHIR observations allowing the customization of, e.g., codings and units.
    /// - Parameters:
    ///   - quantitySampleMapping: The ``HKSampleMapping/quantitySampleMapping`` property defines the mapping of `HKQuantityType`s to FHIR observations.
    ///   - correlationMapping: The ``HKSampleMapping/correlationMapping`` property defines the mapping of `HKCorrelationType`s to FHIR observations.
    public init(
        quantitySampleMapping: [HKQuantityType: HKQuantitySampleMapping] = HKQuantitySampleMapping.default,
        categorySampleMapping: [HKCategoryType: HKCategorySampleMapping] = HKCategorySampleMapping.default,
        correlationMapping: [HKCorrelationType: HKCorrelationMapping] = HKCorrelationMapping.default,
        electrocardiogramMapping: HKElectrocardiogramMapping = HKElectrocardiogramMapping.default
    ) {
        self.quantitySampleMapping = quantitySampleMapping
        self.categorySampleMapping = categorySampleMapping
        self.correlationMapping = correlationMapping
        self.electrocardiogramMapping = electrocardiogramMapping
    }
}
