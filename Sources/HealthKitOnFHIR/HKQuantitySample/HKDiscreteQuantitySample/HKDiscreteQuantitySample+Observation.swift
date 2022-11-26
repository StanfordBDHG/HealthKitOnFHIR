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
        var unit: String?
        var value: Double?

        switch self.quantityType {
        case HKQuantityType(.heartRate):
            unit = "count/min"
            value = self.quantity.doubleValue(for: HKUnit(from: "count/min"))
        case HKQuantityType(.bloodGlucose):
            unit = "mg/dL"
            value = self.quantity.doubleValue(for: HKUnit(from: "mg/dL"))
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
                    unit: unit?.asFHIRStringPrimitive(),
                    value: value?.asFHIRDecimalPrimitive()
                )
            )
    }
}
