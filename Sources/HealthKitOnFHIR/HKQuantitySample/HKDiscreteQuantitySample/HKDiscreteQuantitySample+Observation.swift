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
        throw HealthKitOnFHIRError.notSupported
    }
}
