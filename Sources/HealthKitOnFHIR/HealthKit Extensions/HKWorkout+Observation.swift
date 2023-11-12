//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKWorkout {
    /// Generates an observation that captures the type of physical activity performed for a single instance of physical activity, based on https://build.fhir.org/ig/HL7/physical-activity/StructureDefinition-pa-observation-activity-measure.html
    /// Note:  An `HKWorkout` object can also act as a container for other `HKSample` objects, which will need to be converted to observations individually.
    func buildWorkoutObservation(
        _ observation: inout Observation
    ) throws {
        observation.appendCategory(
            CodeableConcept(
                coding: [
                    Coding(
                        code: "activity".asFHIRStringPrimitive(),
                        system: "http://terminology.hl7.org/CodeSystem/observation-category".asFHIRURIPrimitive()
                    ),
                    Coding(
                        code: "PhysicalActivity".asFHIRStringPrimitive(),
                        system: "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes".asFHIRURIPrimitive()
                    )
                ]
            )
        )

        observation.code = CodeableConcept(coding: [
            Coding(
                code: "73985-4".asFHIRStringPrimitive(),
                display: "Exercise activity".asFHIRStringPrimitive(),
                system: "http://loinc.org".asFHIRURIPrimitive()
            )
        ])
        
        let activityTypeString = self.workoutActivityType.description.asFHIRStringPrimitive()

        let valueCodeableConcept = CodeableConcept(
            coding: [
                Coding(
                    code: activityTypeString,
                    system: "http://developer.apple.com/documentation/healthkit".asFHIRURIPrimitive()
                )
            ]
        )

        observation.value = .codeableConcept(valueCodeableConcept)
    }
}
