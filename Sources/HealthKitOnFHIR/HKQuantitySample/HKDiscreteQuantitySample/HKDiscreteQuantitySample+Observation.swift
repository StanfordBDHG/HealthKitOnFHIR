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
        var unit = ""
        var value = 0.0

        switch self.quantityType {
        case HKQuantityType(.heartRate):
            unit = "count/min"
            value = self.quantity.doubleValue(for: HKUnit(from: unit))
        case HKQuantityType(.bloodGlucose):
            unit = "mg/dL"
            value = self.quantity.doubleValue(for: HKUnit(from: unit))
        case HKQuantityType(.oxygenSaturation):
            unit = "%"
            value = self.quantity.doubleValue(for: HKUnit.percent())
        default:
            throw HealthKitOnFHIRError.notSupported
        }

        builder
            .setEffective(startDate: self.startDate, endDate: self.endDate)
            .addCodings(self.sampleType.convertToCodes())
            .setValue(
                Quantity(
                    unit: unit.asFHIRStringPrimitive(),
                    value: value.asFHIRDecimalPrimitive()
                )
            )
    }
}
