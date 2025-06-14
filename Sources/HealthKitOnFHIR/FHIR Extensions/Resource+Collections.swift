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


extension DomainResource {
    /// Appends an `Extension` to the `DomainResource`
    public func appendExtension(_ extension: Extension, replaceAllExistingWithSameUrl: Bool) {
        appendExtensions(CollectionOfOne(`extension`), replaceAllExistingWithSameUrl: replaceAllExistingWithSameUrl)
    }
    
    /// Appends multiple `Extension`s to the `DomainResource`
    public func appendExtensions(_ extensions: some Collection<Extension>, replaceAllExistingWithSameUrl: Bool) {
        if replaceAllExistingWithSameUrl {
            for element in extensions {
                removeAllExtensions(withUrl: element.url)
            }
        }
        appendElements(extensions, to: \.extension)
    }
    
    /// Removes the first extension element that matches the specified url.
    ///
    /// - returns: the removed extension element, if any.
    @discardableResult
    public func removeFirstExtension(withUrl url: FHIRPrimitive<FHIRURI>) -> Extension? {
        removeFirstElement(of: \.extension) { $0.url == url }
    }
    
    /// Removes all extension elements that matches the specified url.
    ///
    /// - returns: the removed extension elements, if any.
    @discardableResult
    public func removeAllExtensions(withUrl url: FHIRPrimitive<FHIRURI>) -> [Extension]? { // swiftlint:disable:this discouraged_optional_collection
        removeAllElements(of: \.extension) { $0.url == url }
    }
}
