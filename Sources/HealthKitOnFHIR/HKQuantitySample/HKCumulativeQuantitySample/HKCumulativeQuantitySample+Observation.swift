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
    func buildCumulativeQuantitySampleObservation(_ observation: inout Observation) throws {
        switch self.sampleType {
        case HKQuantityType(.stepCount):
            // Convert data to FHIR types
            let id = Identifier(id: FHIRPrimitive(FHIRString(UUID().uuidString)))
            let unit = "steps"
            let value = self.quantity.doubleValue(for: HKUnit.count())
            let periodStart = FHIRPrimitive(try DateTime(date: self.startDate))
            let periodEnd = FHIRPrimitive(try DateTime(date: self.endDate))

            // Set observation category (maps HK type to a category code (using SNOMED CT
            // since Observation.coding does not cover activity))
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

            // Create observation code (maps HK type to a LOINC code)
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

            // Build observation
            observation.identifier = [id]
            observation.category = [category]
            observation.code.coding = [loincCoding]
            observation.effective = .period(Period(end: periodEnd, start: periodStart))
            observation.issued = FHIRPrimitive(try Instant(date: Date()))
            observation.value = .quantity(
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
