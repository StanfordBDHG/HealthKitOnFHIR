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
    func buildCumulativeQuantitySampleObservation(_ builder: inout ObservationBuilder) throws {
        var unit: String?
        var value: Double?

        switch self.quantityType {
        case HKQuantityType(.stepCount):
            unit = "steps"
            value = self.quantity.doubleValue(for: HKUnit.count())
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
