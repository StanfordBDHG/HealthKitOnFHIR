//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRModelsExtensions
import Foundation
import HealthKit
@testable import HealthKitOnFHIR
import ModelsR4
import Testing


/// Tests for parts of the generated `Observation` that are shared by all sample types: the identifier, the issued date, and the metadata extension.
struct ObservationOutputTests {
    private static func makeSample(metadata: [String: Any] = [:]) -> HKQuantitySample {
        HKQuantitySample(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: Date(timeIntervalSince1970: 1_000_000),
            end: Date(timeIntervalSince1970: 1_000_060),
            metadata: metadata
        )
    }

    private static func observation(for sample: HKQuantitySample) throws -> Observation {
        try #require(sample.resource().get(if: Observation.self))
    }

    private static func metadataExtension(of observation: Observation) throws -> Extension {
        try #require(observation.extension?.first { $0.url == FHIRExtensionUrls.metadata })
    }


    @Test
    func identifierCarriesTheSampleUUID() throws {
        let sample = Self.makeSample()
        let observation = try Self.observation(for: sample)
        let identifier = try #require(observation.identifier?.first)
        #expect(observation.identifier?.count == 1)
        #expect(identifier.system?.value?.url.absoluteString == "urn:ietf:rfc:3986")
        #expect(identifier.value?.value?.string == "urn:uuid:\(sample.uuid.uuidString.lowercased())")
        #expect(identifier.id == nil)
        #expect(observation.id?.value?.string == sample.uuid.uuidString)
    }


    @Test
    func booleanMetadataIsEncodedAsBoolean() throws {
        let observation = try Self.observation(for: Self.makeSample(metadata: [
            HKMetadataKeyWasUserEntered: true,
            "customFlag": false,
            "customCount": 3
        ]))
        let metadata = try Self.metadataExtension(of: observation)
        try checkProperty(in: metadata, [HKMetadataKeyWasUserEntered], value: .boolean(true))
        try checkProperty(in: metadata, ["customFlag"], value: .boolean(false))
        // Numbers that are not booleans are still encoded as decimals.
        try checkProperty(in: metadata, ["customCount"], value: .decimal(FHIRPrimitive(FHIRDecimal(3))))
    }


    @Test
    func unrepresentableNumericMetadataIsSkipped() throws {
        let observation = try Self.observation(for: Self.makeSample(metadata: [
            "positiveInfinity": Double.infinity,
            "negativeInfinity": -Double.infinity,
            "notANumber": Double.nan,
            "tooLargeForDecimal": Double.greatestFiniteMagnitude,
            "finite": 1.5
        ]))
        let metadata = try Self.metadataExtension(of: observation)
        #expect(metadata.extension?.count == 1)
        try checkProperty(in: metadata, ["positiveInfinity"], value: nil)
        try checkProperty(in: metadata, ["negativeInfinity"], value: nil)
        try checkProperty(in: metadata, ["notANumber"], value: nil)
        try checkProperty(in: metadata, ["tooLargeForDecimal"], value: nil)
        try checkProperty(in: metadata, ["finite"], value: .decimal(FHIRPrimitive(FHIRDecimal(NSNumber(value: 1.5).decimalValue))))

        // The encoded observation is valid JSON, and its metadata decodes back unchanged.
        let decoded = try JSONDecoder().decode(Observation.self, from: JSONEncoder().encode(observation))
        #expect(try Self.metadataExtension(of: decoded) == metadata)
    }


    @Test
    func onlyNonFiniteMetadataAddsNoExtension() throws {
        let observation = try Self.observation(for: Self.makeSample(metadata: ["positiveInfinity": Double.infinity]))
        #expect(observation.extension?.contains { $0.url == FHIRExtensionUrls.metadata } != true)
    }


    @Test
    func dateMetadataUsesAFixedOffset() throws {
        let date = Date(timeIntervalSince1970: 1_793_525_400) // 2026-11-01T09:30:00Z
        let observation = try Self.observation(for: Self.makeSample(metadata: ["customDate": date]))
        let metadata = try Self.metadataExtension(of: observation)
        try checkProperty(
            in: metadata,
            ["customDate"],
            value: .dateTime(FHIRPrimitive(try DateTime(date: date, timeZone: TimeZone.current.fixedOffset(at: date))))
        )
    }


    @Test
    func defaultIssuedDateUsesAFixedOffset() throws {
        let proxies = try [Self.makeSample(), Self.makeSample()].mapIntoResourceProxies()
        let issued = try proxies.map { try #require($0.get(if: Observation.self)?.issued?.value) }
        #expect(issued.count == 2)
        // All observations in one batch share one issued date.
        #expect(issued[0] == issued[1])
        let instant = try issued[0].asNSDate()
        #expect(issued[0].timeZone == TimeZone.current.fixedOffset(at: instant))
    }
}
