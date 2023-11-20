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
        _ observation: inout Observation,
        mappings: HKSampleMapping = HKSampleMapping.default
    ) throws {
        let mapping = mappings.workoutSampleMapping

        for code in mapping.codings {
            observation.appendCoding(code.coding)
        }

        for category in mapping.categories {
            observation.appendCategory(
                CodeableConcept(coding: [category.coding])
            )
        }
        
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
