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
        mappings: HKSampleMapping = HKSampleMapping.default
    ) throws {
        guard let mapping = mappings.correlationMapping[self.correlationType.identifier] else {
            throw HealthKitOnFHIRError.notSupported
        }

        for coding in mapping.codes {
            observation.appendCoding(
                Coding(
                    code: coding.code.asFHIRStringPrimitive(),
                    display: coding.display.asFHIRStringPrimitive(),
                    system: FHIRPrimitive(FHIRURI(stringLiteral: coding.system))
                )
            )
        }

        for category in mapping.categories {
            observation.appendCategory(
                CodeableConcept(coding: [
                    Coding(
                        code: category.code.asFHIRStringPrimitive(),
                        display: category.display.asFHIRStringPrimitive(),
                        system: FHIRPrimitive(FHIRURI(stringLiteral: category.system))
                    )])
            )
        }

        for object in self.objects {
            guard let sample = object as? HKQuantitySample else {
                continue
            }

            try? sample.buildQuantitySampleObservationComponent(&observation)
        }
    }
}
