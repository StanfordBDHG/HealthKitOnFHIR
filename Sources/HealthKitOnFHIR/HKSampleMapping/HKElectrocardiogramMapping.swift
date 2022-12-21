//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// An ``HKElectrocardiogramMapping`` allows developers to customize the mapping of an`HKElectrocardiogram` to a FHIR observation.
public struct HKElectrocardiogramMapping: Decodable {
    /// A default instance of an ``HKElectrocardiogramMapping`` instance allowing developers to customize the ``HKElectrocardiogramMapping``.
    ///
    /// The default values are loaded from the `HKSampleMapping.json` resource in the ``HealthKitOnFHIR`` Swift Package.
    public static let `default` = HKSampleMapping.default.electrocardiogramMapping
    
    
    /// The FHIR codings defined as ``MappedCode``s used for the `HKElectrocardiogram`.
    public var codings: [MappedCode]
    /// The FHIR categories defined as ``MappedCode``s used for the `HKElectrocardiogram`.
    public var categories: [MappedCode]
    /// Defines the mapping of the `classification` category sample  of an `HKElectrocardiogram` to a FHIR observation.
    public var classification: HKCategorySampleMapping
    /// Defines the mapping of the `symptomsStatus` category sample  of an `HKElectrocardiogram` to a FHIR observation.
    public var symptomsStatus: HKCategorySampleMapping
    /// Defines the mapping of the `numberOfVoltageMeasurements` quantity property of an `HKElectrocardiogram` to a FHIR observation.
    public var numberOfVoltageMeasurements: HKQuantitySampleMapping
    /// Defines the mapping of the `samplingFrequency` quantity property of an `HKElectrocardiogram` to a FHIR observation.
    public var samplingFrequency: HKQuantitySampleMapping
    /// Defines the mapping of the `averageHeartRate` quantity property of an `HKElectrocardiogram` to a FHIR observation.
    public var averageHeartRate: HKQuantitySampleMapping
    /// Defines the mapping of the `voltageMeasurements` of an `HKElectrocardiogram` to a FHIR observation.
    public var voltageMeasurements: HKQuantitySampleMapping
    
    
    /// An ``HKCorrelationMapping`` allows developers to customize the mapping of an`HKElectrocardiogram` to a FHIR observation.
    /// - Parameters:
    ///   - codings: The FHIR codings defined as ``MappedCode``s used for the specified `HKElectrocardiogram`
    ///   - categories: The FHIR categories defined as ``MappedCode``s used for the specified `HKElectrocardiogram`
    ///   - classification: Defines the mapping of the `classification` category sample  of an `HKElectrocardiogram` to a FHIR observation.
    ///   - symptomsStatus: Defines the mapping of the `symptomsStatus` category sample  of an `HKElectrocardiogram` to a FHIR observation.
    ///   - numberOfVoltageMeasurements: efines the mapping of the `numberOfVoltageMeasurements` quantity property of an `HKElectrocardiogram` to a FHIR observation.
    ///   - samplingFrequency: Defines the mapping of the `samplingFrequency` quantity property of an `HKElectrocardiogram` to a FHIR observation.
    ///   - averageHeartRate: Defines the mapping of the `averageHeartRate` quantity property of an `HKElectrocardiogram` to a FHIR observation.
    ///   - voltageMeasurements: Defines the mapping of the `voltageMeasurements` of an `HKElectrocardiogram` to a FHIR observation.
    public init(
        codings: [MappedCode],
        categories: [MappedCode],
        classification: HKCategorySampleMapping,
        symptomsStatus: HKCategorySampleMapping,
        numberOfVoltageMeasurements: HKQuantitySampleMapping,
        samplingFrequency: HKQuantitySampleMapping,
        averageHeartRate: HKQuantitySampleMapping,
        voltageMeasurements: HKQuantitySampleMapping
    ) {
        self.codings = codings
        self.categories = categories
        self.classification = classification
        self.symptomsStatus = symptomsStatus
        self.numberOfVoltageMeasurements = numberOfVoltageMeasurements
        self.samplingFrequency = samplingFrequency
        self.averageHeartRate = averageHeartRate
        self.voltageMeasurements = voltageMeasurements
    }
}
