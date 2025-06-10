//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable file_types_order

import Foundation
import HealthKit
import ModelsR4


/// Defines a custom Extension that can be applied to a FHIR `Observation` representing a HeathKit sample.
public struct FHIRExtension: Sendable {
    private let impl: @Sendable (_ input: HKSample, _ observation: Observation) throws -> Void
    
    /// Createa a new Extension, which uses a closure to apply itself to an `Observation` created from a `HKSample` (or a subclass thereof).
    public init<Input: HKSample>(_ action: @escaping @Sendable (_ input: Input, _ observation: Observation) throws -> Void) {
        self.impl = { (input: HKSample, observation: Observation) in
            guard let input = input as? Input else {
                return
            }
            try action(input, observation)
        }
    }
    
    func apply(input: HKSample, observation: Observation) throws {
        try impl(input, observation)
    }
}


enum FHIRExtensionUrls {
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    nonisolated(unsafe) static let absoluteTimeRangeStart = "https://bdh.stanford.edu/fhir/defs/absoluteTimeRangeStart".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
    
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    nonisolated(unsafe) static let absoluteTimeRangeEnd = "https://bdh.stanford.edu/fhir/defs/absoluteTimeRangeEnd".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
}


extension FHIRExtension {
    /// A FHIR Extension that writes the absolute time range (i.e., start and end date) of a HealthKit sample into a FHIR `Observation` created from the sample.
    public static let includeAbsoluteTimeRange = Self { (sample: HKSample, observation) in
        let timeRangeExtensions = [
            Extension(
                url: FHIRExtensionUrls.absoluteTimeRangeStart,
                value: .decimal(sample.startDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
            ),
            Extension(
                url: FHIRExtensionUrls.absoluteTimeRangeEnd,
                value: .decimal(sample.endDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
            )
        ]
        observation.appendExtensions(timeRangeExtensions, replaceAllExistingWithSameUrl: true)
    }
}
