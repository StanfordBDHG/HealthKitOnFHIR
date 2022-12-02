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
        mappings: [String: HKQuanitySampleMapping] = HKQuanitySampleMapping.default
    ) throws {
        guard let mapping = mappings[self.quantityType.identifier] else {
            throw HealthKitOnFHIRError.notSupported
        }
        
        observation.setValue(
            Quantity(
                unit: (mapping.unit.unitAlias ?? mapping.unit.hkunit).asFHIRStringPrimitive(),
                value: self.quantity.doubleValue(for: HKUnit(from: mapping.unit.hkunit)).asFHIRDecimalPrimitive()
            )
        )
    }
}
