//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKCorrelation {
    func buildCorrelationObservation(
        _ observation: inout Observation,
        mappings: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default
    ) throws {
        // Blood Pressure is the only correlation type currently supported
        guard self.correlationType == HKCorrelationType(.bloodPressure) else {
            throw HealthKitOnFHIRError.notSupported
        }

        observation.appendCoding(Coding(
            code: "85354-9",
            display: "Blood pressure panel",
            system: FHIRPrimitive(FHIRURI(stringLiteral: "http://loinc.org"))
        ))

        observation.appendCategory(
            CodeableConcept(coding: [Coding(
                code: "vital-signs".asFHIRStringPrimitive(),
                display: "Vital Signs".asFHIRStringPrimitive(),
                system: FHIRPrimitive(FHIRURI(stringLiteral: "http://terminology.hl7.org/CodeSystem/observation-category"))
                )]
            )
        )

        for object in self.objects {
            guard let sample = object as? HKQuantitySample,
                  let mapping = mappings[sample.quantityType.identifier] else {
                throw HealthKitOnFHIRError.notSupported
            }

            let component = ObservationComponent(code: CodeableConcept(coding: mapping.codes as? [Coding]))
            component.value = ObservationComponent.ValueX.quantity(Quantity(
                    unit: (mapping.unit.unitAlias ?? mapping.unit.hkunit).asFHIRStringPrimitive(),
                    value: sample.quantity.doubleValue(for: HKUnit(from: mapping.unit.hkunit)).asFHIRDecimalPrimitive()
                )
            )
            observation.appendComponent(component)

        }
    }
}
