//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import ModelsR4


extension Observation {
    private func appendElement<T>(_ element: T, to collection: ReferenceWritableKeyPath<Observation, [T]?>) {
        // swiftlint:disable:previous discouraged_optional_collection
        // Unfortunately we need to use an optional collection here as the ModelsR4 modules uses optional collections in the Observation type.
        guard self[keyPath: collection] != nil else {
            self[keyPath: collection] = [element]
            return
        }
        self[keyPath: collection]?.append(element)
    }
    
    
    private func appendElements<T>(_ elements: [T], to collection: ReferenceWritableKeyPath<Observation, [T]?>) {
        // swiftlint:disable:previous discouraged_optional_collection
        // Unfortunately we need to use an optional collection here as the ModelsR4 modules uses optional collections in the Observation type.
        if self[keyPath: collection] == nil {
            self[keyPath: collection] = []
            self[keyPath: collection]?.reserveCapacity(elements.count)
        } else {
            self[keyPath: collection]?.reserveCapacity((self[keyPath: collection]?.count ?? 0) + elements.count)
        }
        for element in elements {
            appendElement(element, to: collection)
        }
    }
    
    
    /// Appends an `Identifier` to the `Observation`
    public func appendIdentifier(_ identifier: Identifier) {
        appendElement(identifier, to: \.identifier)
    }
    
    /// Appends multiple `Identifier`s to the `Observation`
    public func appendIdentifiers(_ identifiers: [Identifier]) {
        appendElements(identifiers, to: \.identifier)
    }
    
    /// Appends a `CodeableConcept` to the `Observation`
    public func appendCategory(_ category: CodeableConcept) {
        appendElement(category, to: \.category)
    }
    
    /// Appends multiple `CodeableConcept`s to the `Observation`
    public func appendCategories(_ categories: [CodeableConcept]) {
        appendElements(categories, to: \.category)
    }
    
    /// Appends a `Coding` to the `Observation`
    public func appendCoding(_ coding: Coding) {
        appendElement(coding, to: \.code.coding)
    }
    
    /// Appends multiple `Coding`s to the `Observation`
    public func appendCodings(_ codings: [Coding]) {
        appendElements(codings, to: \.code.coding)
    }
    
    /// Appends an `ObservationComponent` to the `Observation`
    public func appendComponent(_ component: ObservationComponent) {
        appendElement(component, to: \.component)
    }
    
    /// Appends multiple `ObservationComponent`s to the `Observation`
    public func appendComponents(_ components: [ObservationComponent]) {
        appendElements(components, to: \.component)
    }
}
