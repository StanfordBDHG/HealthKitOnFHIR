//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKSample {
    /// Converts an `HKSample` into an FHIR  resource, encapsulated in a `ResourceProxy`
    public var resource: ResourceProxy {
        get throws {
            try resource()
        }
    }
    
    
    /// A `ResourceProxy` containing an FHIR  `Observation` based on the concrete subclass of `HKSample`.
    ///
    /// If a specific `HKSample` type is currently not supported the property returns an ``HealthKitOnFHIRError/notSupported`` error.
    /// - Parameter withMapping: A mapping to map `HKSample`s to corresponding FHIR observations allowing the customization of, e.g., codings and units. See ``HKSampleMapping``.
    /// - Returns: A `ResourceProxy`containing an FHIR  `Observation` based on the concrete subclass of `HKSample`.
    public func resource(withMapping mapping: HKSampleMapping = HKSampleMapping.default) throws -> ResourceProxy {
        var observation = Observation(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        
        // Set basic elements applicable to all observations
        observation.id = self.uuid.uuidString.asFHIRStringPrimitive()
        observation.appendIdentifier(Identifier(id: observation.id))
        observation.setEffective(
            startDate: self.startDate,
            endDate: self.endDate,
            timeZone: self.timeZone ?? .current
        )
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
        #if !os(watchOS)
        case let clinicalRecord as HKClinicalRecord:
            return try clinicalRecord.resource()
        #endif
        case let workout as HKWorkout:
            try workout.buildWorkoutObservation(&observation)
        default:
            throw HealthKitOnFHIRError.notSupported
        }
        
        return ResourceProxy(with: observation)
    }
}
