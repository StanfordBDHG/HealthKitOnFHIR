//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKClinicalRecord {
    /// Converts an `HKClinicalRecord` into a corresponding FHIR resource
    func convert() throws -> ResourceProxy {
        guard let fhirResource = self.fhirResource else {
            throw HealthKitOnFHIRError.invalidFHIRResource
        }

        guard fhirResource.fhirVersion == HKFHIRVersion.primaryR4() else {
            throw HealthKitOnFHIRError.unsupportedFHIRVersion
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(ResourceProxy.self, from: fhirResource.data)
        }
    }
}
