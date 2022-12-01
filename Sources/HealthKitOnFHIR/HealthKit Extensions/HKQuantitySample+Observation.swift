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
    func buildQuantitySampleObservation(_ observation: inout Observation) throws {
        let unit: String
        let value: Double
        
        switch self.quantityType {
        case HKQuantityType(.stepCount):
            unit = "steps"
            value = self.quantity.doubleValue(for: HKUnit.count())
        case HKQuantityType(.bloodGlucose):
            unit = "mg/dL"
            value = self.quantity.doubleValue(for: HKUnit(from: "mg/dL"))
        case HKQuantityType(.bodyMass):
            unit = "kg"
            value = self.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
        case HKQuantityType(.bodyTemperature):
            unit = "degC"
            value = self.quantity.doubleValue(for: HKUnit.degreeCelsius())
        case HKQuantityType(.heartRate):
            unit = "count/min"
            value = self.quantity.doubleValue(for: HKUnit(from: "count/min"))
        case HKQuantityType(.height):
            unit = "m"
            value = self.quantity.doubleValue(for: HKUnit.meter())
        case HKQuantityType(.oxygenSaturation):
            unit = "%"
            value = self.quantity.doubleValue(for: HKUnit.percent())
        case HKQuantityType(.respiratoryRate):
            unit = "count/min"
            value = self.quantity.doubleValue(for: HKUnit(from: "count/min"))
        default:
            throw HealthKitOnFHIRError.notSupported
        }
        
        observation.setValue(
            Quantity(
                unit: unit.asFHIRStringPrimitive(),
                value: value.asFHIRDecimalPrimitive()
            )
        )
    }
}
