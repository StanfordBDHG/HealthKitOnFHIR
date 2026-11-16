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


/// Tests for how the metadata extension builder encodes boolean and numeric metadata values.
struct MetadataExtensionTests {
    private static func observation(metadata: [String: Any]) throws -> Observation {
        let sample = HKQuantitySample(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: Date(timeIntervalSince1970: 1_000_000),
            end: Date(timeIntervalSince1970: 1_000_060),
            metadata: metadata
        )
        return try #require(sample.resource().get(if: Observation.self))
    }

    private static func metadataExtension(of observation: Observation) throws -> Extension {
        try #require(observation.extension?.first { $0.url == FHIRExtensionUrls.metadata })
    }


    @Test
    func booleanMetadataIsEncodedAsBoolean() throws {
        let observation = try Self.observation(metadata: [
            HKMetadataKeyWasUserEntered: true,
            "customFlag": false,
            "customCount": 3
        ])
        let metadata = try Self.metadataExtension(of: observation)
        try checkProperty(in: metadata, [HKMetadataKeyWasUserEntered], value: .boolean(true))
        try checkProperty(in: metadata, ["customFlag"], value: .boolean(false))
        // Numbers that are not booleans are still encoded as decimals.
        try checkProperty(in: metadata, ["customCount"], value: .decimal(FHIRPrimitive(FHIRDecimal(3))))
    }


    @Test
    func unrepresentableNumericMetadataIsSkipped() throws {
        let observation = try Self.observation(metadata: [
            "positiveInfinity": Double.infinity,
            "negativeInfinity": -Double.infinity,
            "notANumber": Double.nan,
            "tooLargeForDecimal": Double.greatestFiniteMagnitude,
            "finite": 1.5
        ])
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
    func onlyUnrepresentableMetadataAddsNoExtension() throws {
        let observation = try Self.observation(metadata: ["positiveInfinity": Double.infinity])
        #expect(observation.extension?.contains { $0.url == FHIRExtensionUrls.metadata } != true)
    }
}
