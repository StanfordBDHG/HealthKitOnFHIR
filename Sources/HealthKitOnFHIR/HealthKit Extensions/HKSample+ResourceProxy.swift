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
    /// A `ResourceProxy` containing an FHIR  `Observation` based on the concrete subclass of `HKSample`.
    ///
    /// - parameter mapping: A mapping to map `HKSample`s to corresponding FHIR observations allowing the customization of, e.g., codings and units. See ``HKSampleMapping``.
    /// - parameter issuedDate: `Instant` specifying when this version of the resource was made available. Defaults to `Date.now`.
    /// - parameter extensions: Any ``FHIRExtension``s that should be applied to each of the produced observations, e.g. ``FHIRExtension/includeAbsoluteTimeRange``.
    /// - returns: A `ResourceProxy`containing an FHIR  `Observation` based on the concrete subclass of `HKSample`.
    /// - throws: If a specific `HKSample` type is currently not supported the property returns an ``HealthKitOnFHIRError/notSupported`` error.
    ///
    /// - Important: When mapping an array of HKSample objects into ResourceProxies, for performance reasons always prefer ``Swift/Sequence/mapIntoResourceProxies(using:)`` or ``Swift/Sequence/compactMapIntoResourceProxies(using:)``.
    public func resource(
        withMapping mapping: HKSampleMapping = .default,
        issuedDate: FHIRPrimitive<Instant>? = nil,
        extensions: [FHIRExtensionBuilder] = []
    ) throws -> ResourceProxy {
        #if !os(watchOS)
        if let self = self as? HKClinicalRecord {
            return try self.resource()
        }
        #endif
        let observation = Observation(
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
        if let self = self as? any FHIRObservationBuildable {
            try self.build(observation, mapping: mapping)
        } else {
            throw HealthKitOnFHIRError.notSupported
        }
        for `extension` in extensions + [.sourceDevice, .sourceRevision] {
            try `extension`.apply(input: self, observation: observation)
        }
        return ResourceProxy(with: observation)
    }
}


extension Sequence where Element: HKSample {
    /// Produces an Array of FHIR `ResourceProxies`.
    ///
    /// - Note: This method provides significant performance improvements as compared to calling ``ResourceProxyProviding/resource()`` for each element in the collection.
    public func mapIntoResourceProxies(
        using mapping: HKSampleMapping = .default,
        extensions: [FHIRExtensionBuilder] = []
    ) throws -> [ResourceProxy] {
        let issuedDate = FHIRPrimitive<Instant>(try Instant(date: .now))
        return try map { try $0.resource(withMapping: mapping, issuedDate: issuedDate, extensions: extensions) }
    }
    
    /// Produces an Array of FHIR `ResourceProxies`.
    ///
    /// - Note: This method provides significant performance improvements as compared to calling ``ResourceProxyProviding/resource()`` for each element in the collection.
    public func compactMapIntoResourceProxies(
        using mapping: HKSampleMapping = .default,
        extensions: [FHIRExtensionBuilder] = []
    ) throws -> [ResourceProxy] {
        let issuedDate = FHIRPrimitive<Instant>(try Instant(date: .now))
        return compactMap { try? $0.resource(withMapping: mapping, issuedDate: issuedDate, extensions: extensions) }
    }
}
