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
        mappings: HKSampleMapping = HKSampleMapping.default
    ) throws {
        guard let mapping = mappings.quantitySampleMapping[self.quantityType] else {
            throw HealthKitOnFHIRError.notSupported
        }
        
        for code in mapping.codings {
            observation.appendCoding(code.coding)
        }
        
        observation.setValue(buildQuantity(mapping))
    }
    
    func buildQuantitySampleObservationComponent(
        _ observation: inout Observation,
        mappings: [HKQuantityType: HKQuantitySampleMapping] = HKQuantitySampleMapping.default
    ) throws {
        guard let mapping = mappings[self.quantityType] else {
            throw HealthKitOnFHIRError.notSupported
        }
        
        let component = ObservationComponent(code: CodeableConcept(coding: mapping.codings.map(\.coding)))
        component.value = .quantity(buildQuantity(mapping))
        observation.appendComponent(component)
    }
    
    private func buildQuantity(_ mapping: HKQuantitySampleMapping) -> Quantity {
        Quantity(
            code: mapping.unit.code?.asFHIRStringPrimitive(),
            system: mapping.unit.system?.asFHIRURIPrimitive(),
            unit: mapping.unit.unit.asFHIRStringPrimitive(),
            value: self.quantity.doubleValue(for: mapping.unit.hkunit).asFHIRDecimalPrimitive()
        )
    }
}
