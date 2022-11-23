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
    func buildCumulativeQuantitySampleObservation(_ observation: inout Observation) throws {
        throw HealthKitOnFHIRError.notSupported
    }
}
