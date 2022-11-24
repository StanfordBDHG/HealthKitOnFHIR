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
    func buildQuantitySampleObservation(_ builder: inout ObservationBuilder) throws {
        switch self {
        case let cumulativeQuantitySample as HKCumulativeQuantitySample:
            try cumulativeQuantitySample.buildCumulativeQuantitySampleObservation(&builder)
        case let discreteQuantitySample as HKDiscreteQuantitySample:
            try discreteQuantitySample.buildDiscreteQuantitySampleObservation(&builder)
        default:
            throw HealthKitOnFHIRError.notSupported
        }
    }
}
