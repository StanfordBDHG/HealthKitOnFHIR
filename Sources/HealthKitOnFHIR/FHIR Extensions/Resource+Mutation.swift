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


protocol FHIRResourceMutationExtensions {}
extension Resource: FHIRResourceMutationExtensions {}


extension FHIRResourceMutationExtensions where Self: Resource {
    func appendElement<C: RangeReplaceableCollection>(_ element: C.Element, to keyPath: ReferenceWritableKeyPath<Self, C?>) {
        appendElements(CollectionOfOne(element), to: keyPath)
    }
    
    func appendElements<C: RangeReplaceableCollection>(
        _ elements: some Collection<C.Element>,
        to keyPath: ReferenceWritableKeyPath<Self, C?>
    ) {
        if self[keyPath: keyPath] == nil {
            self[keyPath: keyPath] = C()
            self[keyPath: keyPath]?.reserveCapacity(elements.count)
        } else {
            self[keyPath: keyPath]?.reserveCapacity((self[keyPath: keyPath]?.count ?? 0) + elements.count)
        }
        self[keyPath: keyPath]?.append(contentsOf: elements)
    }
    
    /// Removes the first element of the property that matches the predicate.
    ///
    /// Also sets the property to `nil` if there are no elements remaining after the removal.
    ///
    /// - returns: the removed element, if any.
    func removeFirstElement<C: RangeReplaceableCollection>(
        of keyPath: ReferenceWritableKeyPath<Self, C?>,
        where predicate: (C.Element) -> Bool
    ) -> C.Element? {
        guard var elements = self[keyPath: keyPath], let idx = elements.firstIndex(where: predicate) else {
            return nil
        }
        let element = elements.remove(at: idx)
        self[keyPath: keyPath] = elements.isEmpty ? nil : elements
        return element
    }
    
    /// Removes all elements of the property that matche the predicate.
    ///
    /// Also sets the property to `nil` if there are no elements remaining after the removal.
    ///
    /// - returns: the removed elements, if any.
    func removeAllElements<C: RangeReplaceableCollection>(
        of keyPath: ReferenceWritableKeyPath<Self, C?>,
        where predicate: (C.Element) -> Bool
    ) -> [C.Element]? { // swiftlint:disable:this discouraged_optional_collection
        guard var elements = self[keyPath: keyPath] else {
            return nil
        }
        let indices = elements.indices.filter { predicate(elements[$0]) }
        let removedElements = indices.map { elements[$0] }
        elements.removeElements(at: indices)
        self[keyPath: keyPath] = elements.isEmpty ? nil : elements
        return removedElements
    }
}
