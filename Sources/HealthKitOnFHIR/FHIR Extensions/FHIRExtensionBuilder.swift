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


/// Namespace containing URLs of some custom FHIR Extensions.
public enum FHIRExtensionUrls {}


/// Defines a custom Extension that can be applied to a FHIR `Observation` representing a HeathKit sample.
public struct FHIRExtensionBuilder: Sendable {
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
