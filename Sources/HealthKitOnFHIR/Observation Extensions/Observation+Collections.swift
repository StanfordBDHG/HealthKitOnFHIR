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
    
    
    func appendIdentifier(_ identifier: Identifier) {
        appendElement(identifier, to: \.identifier)
    }
    
    func appendIdentifiers(_ identifiers: [Identifier]) {
        appendElements(identifiers, to: \.identifier)
    }
    
    func appendCategory(_ category: CodeableConcept) {
        appendElement(category, to: \.category)
    }
    
    func appendCategories(_ categories: [CodeableConcept]) {
        appendElements(categories, to: \.category)
    }
    
    func appendCoding(_ coding: Coding) {
        appendElement(coding, to: \.code.coding)
    }
    
    func appendCodings(_ codings: [Coding]) {
        appendElements(codings, to: \.code.coding)
    }

    func appendComponent(_ component: ObservationComponent) {
        appendElement(component, to: \.component)
    }

    func appendComponents(_ components: [ObservationComponent]) {
        appendElements(components, to: \.component)
    }
}
