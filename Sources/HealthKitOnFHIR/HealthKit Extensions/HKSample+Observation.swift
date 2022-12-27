//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_exported import HealthKit
@_exported import ModelsR4


extension HKSample {
    /// A FHIR observation based on the concrete subclass of `HKSample`.
    ///
    /// If a specific `HKSample` type is currently not supported the property returns an ``HealthKitOnFHIRError/notSupported`` error.
    public var observation: Observation {
        get throws {
            try observation()
        }
    }
    
    /// A FHIR observation based on the concrete subclass of `HKSample`.
    ///
    /// If a specific `HKSample` type is currently not supported the property returns an ``HealthKitOnFHIRError/notSupported`` error.
    /// - Parameter withMapping: A mapping to map `HKSample`s to corresponding FHIR observations allowing the customization of, e.g., codings and units. See ``HKSampleMapping``.
    /// - Returns: A FHIR observation based on the concrete subclass of `HKSample`.
    public func observation(withMapping mapping: HKSampleMapping = HKSampleMapping.default) throws -> Observation {
        var observation = Observation(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        
        // Set basic elements applicable to all observations
        observation.appendIdentifier(Identifier(id: self.uuid.uuidString.asFHIRStringPrimitive()))
        observation.setEffective(startDate: self.startDate, endDate: self.endDate)
        observation.setIssued(on: Date())
        
        // Set specific data based on HealthKit type
        switch self {
        case let quantitySample as HKQuantitySample:
            try quantitySample.buildQuantitySampleObservation(&observation, mappings: mapping)
        case let correlation as HKCorrelation:
            try correlation.buildCorrelationObservation(&observation, mappings: mapping)
        case let categorySample as HKCategorySample:
            try categorySample.buildCategoryObservation(&observation)
        case let electrocardiogram as HKElectrocardiogram:
            try electrocardiogram.buildObservation(&observation, mappings: mapping)
        default:
            throw HealthKitOnFHIRError.notSupported
        }
        
        return observation
    }
}
