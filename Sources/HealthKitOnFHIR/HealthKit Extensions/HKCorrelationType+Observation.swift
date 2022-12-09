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
        
        for code in mapping.codings {
            observation.appendCoding(code.coding)
        }
        
        for category in mapping.categories {
            observation.appendCategory(
                CodeableConcept(coding: [category.coding])
            )
        }
        
        for object in self.objects {
            guard let sample = object as? HKQuantitySample else {
                throw HealthKitOnFHIRError.notSupported
            }
            
            try sample.buildQuantitySampleObservationComponent(&observation)
        }
    }
}
