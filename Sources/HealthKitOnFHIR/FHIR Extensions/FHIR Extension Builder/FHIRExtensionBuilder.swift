//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import ModelsR4


/// Namespace containing URLs of some custom FHIR Extensions.
public enum FHIRExtensionUrls {}


/// Type-erased version of a ``FHIRExtensionBuilder``
public protocol FHIRExtensionBuilderProtocol<Input> {
    /// The extension builder's input type.
    associatedtype Input
    
    /// Applies the extension builder to an `Observation`, using the specified input.
    func apply(input: Input, to observation: Observation) throws
}


/// Defines a custom Extension Builder that can be applied to a FHIR `Observation` representing a HeathKit sample.
///
/// ## Topics
///
/// ### Creating an Extension Builder
/// - ``init(_:)-((Input,Observation)->Void)``
/// - ``init(_:)-((Observation)->Void)``
///
/// ### Applying Extensions
/// - ``apply(input:to:)``
/// - ``apply(to:)``
/// - ``apply(typeErasedInput:to:)``
///
/// ### Supporting Types
/// - ``FHIRExtensionUrls``
/// - ``FHIRExtensionBuilderProtocol``
///
/// ### Other
/// - ``ModelsR4/Observation/apply(_:input:)``
/// - ``ModelsR4/Observation/apply(_:)``
public struct FHIRExtensionBuilder<Input>: FHIRExtensionBuilderProtocol, Sendable {
    private let impl: @Sendable (_ input: Input, _ observation: Observation) throws -> Void
    
    /// Creates a new Extension Builder.
    public init(_ action: @escaping @Sendable (_ input: Input, _ observation: Observation) throws -> Void) {
        self.impl = action
    }
    
    /// Creates a new Extension Builder.
    public init(_ action: @escaping @Sendable (_ observation: Observation) throws -> Void) where Input == Void {
        self.init { _, observation in
            try action(observation)
        }
    }
    
    public func apply(input: Input, to observation: Observation) throws {
        try impl(input, observation)
    }
}


extension FHIRExtensionBuilderProtocol {
    /// Applies the extension builder to an `Observation`.
    public func apply(to observation: Observation) throws where Input == Void {
        try apply(input: (), to: observation)
    }
    
    /// Attempts to apply the extension builder to an `Observation`, using the specified input.
    ///
    /// This function will have no effect if `typeErasedInput` doesn't match the extension builder's input type.
    /// An exception is if the extension builder's input type is `Void`; in this case any input is allowed, and will simply be discarded.
    ///
    /// - returns: A boolean value indicating whether the input was able to be coerced to the expected input type, and the builder was invoked.
    @discardableResult
    public func apply(typeErasedInput input: Any, to observation: Observation) throws -> Bool {
        if let input = input as? Input {
            try apply(input: input, to: observation)
            return true
        } else if let self = self as? any FHIRExtensionBuilderProtocol<Void> {
            // if the observation builder takes Void
            try self.apply(to: observation)
            return true
        } else {
            return false
        }
    }
}


extension Observation {
    /// Applies a ``FHIRExtensionBuilder`` to the `Observation`.
    public func apply<Input>(_ builder: FHIRExtensionBuilder<Input>, input: Input) throws {
        try builder.apply(input: input, to: self)
    }
    
    /// Applies a ``FHIRExtensionBuilder`` to the `Observation`.
    public func apply(_ builder: FHIRExtensionBuilder<Void>) throws {
        try builder.apply(to: self)
    }
}
