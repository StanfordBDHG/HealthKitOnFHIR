//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit


/// An ``HKStateOfMindSampleMapping`` allows developers to customize the mapping of `HKStateOfMind` samples to FHIR Observations.
public struct HKStateOfMindSampleMapping: Decodable, Sendable {
    /// A default instance of an ``HKStateOfMindSampleMapping`` allowing developers to customize the ``HKStateOfMindSampleMapping``
    /// The default values are loaded from the `HKSampleMapping.json` resource in the ``HealthKitOnFHIR`` Swift Package.
    public static let `default` = HKSampleMapping.default.stateOfMindSampleMapping

    /// The FHIR codings defined as ``MappedCode``s to be used for `HKStateOfMind` samples
    public var codings: [MappedCode]
    /// The FHIR categories defined as ``MappedCode``s to be used for `HKStateOfMind` samples
    public var categories: [MappedCode]


    /// An ``HKWorkoutSampleMapping`` allows developers to customize the mapping of `HKStateOfMind`s to FHIR observations.
    /// - Parameters:
    ///   - codings: The FHIR codings defined as ``MappedCode``s used for the `HKStateOfMind` sample
    ///   - categories: The FHIR categories defined as ``MappedCode``s used for the `HKStateOfMind` sample
    public init(
        codings: [MappedCode] = Self.default.codings,
        categories: [MappedCode] = Self.default.categories
    ) {
        self.codings = codings
        self.categories = categories
    }
}
