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
        switch self {
        case let cumulativeQuantitySample as HKCumulativeQuantitySample:
            try cumulativeQuantitySample.buildCumulativeQuantitySampleObservation(&observation)
        case let discreteQuantitySample as HKDiscreteQuantitySample:
            try discreteQuantitySample.buildDiscreteQuantitySampleObservation(&observation)
        default:
            throw HealthKitOnFHIRError.notSupported
        }
    }
}
