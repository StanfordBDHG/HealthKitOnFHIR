//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKQuantitySample: FHIRObservationBuildable {
    func build(_ observation: Observation, mapping: HKSampleMapping) throws {
        guard let mapping = mapping.quantitySampleMapping[self.quantityType] else {
            throw HealthKitOnFHIRError.notSupported
        }
        for code in mapping.codings {
            observation.appendCoding(code.coding)
        }
        observation.setValue(quantity.buildQuantity(mapping: mapping))
    }
    
    
//    func buildQuantitySampleObservationComponent(
//        _ observation: Observation,
//        mappings: [HKQuantityType: HKQuantitySampleMapping] = HKQuantitySampleMapping.default
//    ) throws {
//        guard let mapping = mappings[self.quantityType] else {
//            throw HealthKitOnFHIRError.notSupported
//        }
//        
//        let component = ObservationComponent(code: CodeableConcept(coding: mapping.codings.map(\.coding)))
//        component.value = .quantity(quantity.buildQuantity(mapping: mapping))
//        observation.appendComponent(component)
//    }
}


extension HKQuantity {
    func buildObservationComponent(
        for quantityType: HKQuantityType,
        mappings: [HKQuantityType: HKQuantitySampleMapping] = HKQuantitySampleMapping.default
    ) throws -> ObservationComponent {
        guard let mapping = mappings[quantityType] else {
            throw HealthKitOnFHIRError.notSupported
        }
        return buildObservationComponent(mapping: mapping)
    }
    
    func buildObservationComponent(mapping: HKQuantitySampleMapping) -> ObservationComponent {
        ObservationComponent(
            code: CodeableConcept(coding: mapping.codings.map(\.coding)),
            value: .quantity(buildQuantity(mapping: mapping))
        )
    }
    
    
    func buildQuantity(
        for quantityType: HKQuantityType,
        mappings: [HKQuantityType: HKQuantitySampleMapping] = HKQuantitySampleMapping.default
    ) throws -> Quantity {
        guard let mapping = mappings[quantityType] else {
            throw HealthKitOnFHIRError.notSupported
        }
        return self.buildQuantity(mapping: mapping)
    }
    
    
    func buildQuantity(mapping: HKQuantitySampleMapping) -> Quantity {
        Quantity(
            code: mapping.unit.code?.asFHIRStringPrimitive(),
            system: mapping.unit.system?.asFHIRURIPrimitive(),
            unit: mapping.unit.unit.asFHIRStringPrimitive(),
            value: self.doubleValue(for: mapping.unit.hkunit).asFHIRDecimalPrimitive()
        )
    }
}
