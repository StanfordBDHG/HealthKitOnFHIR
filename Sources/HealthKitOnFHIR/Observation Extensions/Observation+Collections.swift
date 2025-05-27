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
    private func appendElement<C: RangeReplaceableCollection>(_ element: C.Element, to keyPath: ReferenceWritableKeyPath<Observation, C?>) {
        appendElements(CollectionOfOne(element), to: keyPath)
    }
    
    private func appendElements<C: RangeReplaceableCollection>(
        _ elements: some Collection<C.Element>,
        to keyPath: ReferenceWritableKeyPath<Observation, C?>
    ) {
        if self[keyPath: keyPath] == nil {
            self[keyPath: keyPath] = C()
            self[keyPath: keyPath]?.reserveCapacity(elements.count)
        } else {
            self[keyPath: keyPath]?.reserveCapacity((self[keyPath: keyPath]?.count ?? 0) + elements.count)
        }
        self[keyPath: keyPath]?.append(contentsOf: elements)
    }
    
    
    /// Appends an `Identifier` to the `Observation`
    public func appendIdentifier(_ identifier: Identifier) {
        appendElement(identifier, to: \.identifier)
    }
    
    /// Appends multiple `Identifier`s to the `Observation`
    public func appendIdentifiers(_ identifiers: some Collection<Identifier>) {
        appendElements(identifiers, to: \.identifier)
    }
    
    /// Appends a `CodeableConcept` to the `Observation`
    public func appendCategory(_ category: CodeableConcept) {
        appendElement(category, to: \.category)
    }
    
    /// Appends multiple `CodeableConcept`s to the `Observation`
    public func appendCategories(_ categories: some Collection<CodeableConcept>) {
        appendElements(categories, to: \.category)
    }
    
    /// Appends a `Coding` to the `Observation`
    public func appendCoding(_ coding: Coding) {
        appendElement(coding, to: \.code.coding)
    }
    
    /// Appends multiple `Coding`s to the `Observation`
    public func appendCodings(_ codings: some Collection<Coding>) {
        appendElements(codings, to: \.code.coding)
    }
    
    /// Appends an `ObservationComponent` to the `Observation`
    public func appendComponent(_ component: ObservationComponent) {
        appendElement(component, to: \.component)
    }
    
    /// Appends multiple `ObservationComponent`s to the `Observation`
    public func appendComponents(_ components: some Collection<ObservationComponent>) {
        appendElements(components, to: \.component)
    }
}
