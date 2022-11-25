//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKDiscreteQuantitySample {
    func buildDiscreteQuantitySampleObservation(_ builder: inout ObservationBuilder) throws {
        builder.setEffective(startDate: self.startDate, endDate: self.endDate)

        switch self.sampleType {
        case HKQuantityType(.heartRate):
            let unit = "count/min"
            let value = self.quantity.doubleValue(for: HKUnit(from: unit))

            builder
                .addCodings(self.sampleType.convertToCodes())
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
