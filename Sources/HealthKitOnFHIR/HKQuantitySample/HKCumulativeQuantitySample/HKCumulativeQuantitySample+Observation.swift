//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKCumulativeQuantitySample {
    func buildCumulativeQuantitySampleObservation(_ builder: inout ObservationBuilder) throws {
        switch self.sampleType {
        case HKQuantityType(.stepCount):
            // Convert data to FHIR types
            let unit = "steps"
            let value = self.quantity.doubleValue(for: HKUnit.count())

            // Set observation category
            let categoryCode = "68130003"
            guard let categorySystem = URL(string: "http://snomed.info/sct") else {
                return
            }
            let categoryDisplay = "Physical activity (observable entity)"
            let categoryCoding = Coding(
                code: categoryCode.asFHIRStringPrimitive(),
                display: categoryDisplay.asFHIRStringPrimitive(),
                system: categorySystem.asFHIRURIPrimitive()
            )
            let category = CodeableConcept(coding: [categoryCoding])

            // Set observation code
            let loincCode = "55423-8"
            guard let loincSystem = URL(string: "http://loinc.org") else {
                return
            }
            let loincDisplay = "Number of steps in unspecified time Pedometer"
            let loincCoding = Coding(
                code: loincCode.asFHIRStringPrimitive(),
                display: loincDisplay.asFHIRStringPrimitive(),
                system: loincSystem.asFHIRURIPrimitive()
            )

            builder
                .addCategory(category)
                .addCoding(loincCoding)
                .setEffective(startDate: self.startDate, endDate: self.endDate)
                .setValue(
                    Quantity(
                        unit: unit.asFHIRStringPrimitive(),
                        value: value.asFHIRDecimalPrimitive()
                    )
                )
        default:
            throw HealthKitOnFHIRError.notSupported
        }
    }
}
