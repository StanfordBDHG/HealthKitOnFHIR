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
    @available(
        *, deprecated,
         renamed: "resource()",
         // swiftlint:disable:next line_length
         message: "Important: When mapping an array of HKSample objects into ResourceProxies, for performance reasons always prefer 'Sequence.mapIntoResourceProxies()' or 'Sequence.compactMapIntoResourceProxies()'"
    )
    public var resource: ResourceProxy {
        get throws {
            try resource()
        }
    }
    
    
    /// A `ResourceProxy` containing an FHIR  `Observation` based on the concrete subclass of `HKSample`.
    ///
    /// - parameter mapping: A mapping to map `HKSample`s to corresponding FHIR observations allowing the customization of, e.g., codings and units. See ``HKSampleMapping``.
    /// - parameter issuedDate: `Instant` specifying when this version of the resource was made available. Defaults to `Date.now`.
    /// - returns: A `ResourceProxy`containing an FHIR  `Observation` based on the concrete subclass of `HKSample`.
    /// - throws: If a specific `HKSample` type is currently not supported the property returns an ``HealthKitOnFHIRError/notSupported`` error.
    public func resource(withMapping mapping: HKSampleMapping = .default, issuedDate: FHIRPrimitive<Instant>? = nil) throws -> ResourceProxy {
        var observation = Observation(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        // Set basic elements applicable to all observations
        observation.id = self.uuid.uuidString.asFHIRStringPrimitive()
        observation.appendIdentifier(Identifier(id: observation.id))
        try observation.setEffective(
            startDate: self.startDate,
            endDate: self.endDate,
            timeZone: self.timeZone ?? .current
        )
        if let issuedDate {
            observation.issued = issuedDate
        } else {
            try observation.setIssued(on: Date())
        }
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


extension Sequence where Element: HKSample {
    /// Produces an Array of FHIR `ResourceProxies`.
    ///
    /// - Note: This method provides significant performance improvements as compared to calling ``ResourceProxyProviding/resource()`` for each element in the collection.
    public func mapIntoResourceProxies(using mapping: HKSampleMapping = .default) throws -> [ResourceProxy] {
        let issuedDate = FHIRPrimitive<Instant>(try Instant(date: .now))
        return try map { try $0.resource(withMapping: mapping, issuedDate: issuedDate) }
    }
    
    /// Produces an Array of FHIR `ResourceProxies`.
    ///
    /// - Note: This method provides significant performance improvements as compared to calling ``ResourceProxyProviding/resource()`` for each element in the collection.
    public func compactMapIntoResourceProxies(using mapping: HKSampleMapping = .default) throws -> [ResourceProxy] {
        let issuedDate = FHIRPrimitive<Instant>(try Instant(date: .now))
        return compactMap { try? $0.resource(withMapping: mapping, issuedDate: issuedDate) }
    }
}
