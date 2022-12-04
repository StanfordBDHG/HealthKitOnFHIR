//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKQuantitySample {
    func buildQuantitySampleObservation(
        _ observation: inout Observation,
        mappings: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default
    ) throws {
        guard let mapping = mappings[self.quantityType.identifier] else {
            throw HealthKitOnFHIRError.notSupported
        }
        
        observation.setValue(buildQuantity(mapping))
    }

    func buildQuantitySampleObservationComponent(
        _ observation: inout Observation,
        mappings: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default
    ) throws {
        guard let mapping = mappings[self.quantityType.identifier] else {
            throw HealthKitOnFHIRError.notSupported
        }

        let component = ObservationComponent(code: CodeableConcept(coding: mapping.codes as? [Coding]))
        component.value = .quantity(buildQuantity(mapping))
        observation.appendComponent(component)
    }

    private func buildQuantity(_ mapping: HKQuantitySampleMapping) -> Quantity {
        Quantity(
            unit: (mapping.unit.unitAlias ?? mapping.unit.hkunit).asFHIRStringPrimitive(),
            value: self.quantity.doubleValue(for: HKUnit(from: mapping.unit.hkunit)).asFHIRDecimalPrimitive()
        )
    }
}
