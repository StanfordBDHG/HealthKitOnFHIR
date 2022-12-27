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
    public var allergyIntolerance: AllergyIntolerance {
        get throws {
            guard let resource = try buildResource() as? AllergyIntolerance else {
                throw HealthKitOnFHIRError.invalidFHIRResource
            }
            return resource
        }
    }
    
    func buildResource() throws -> Resource {
        guard let resource = self.fhirResource else {
            throw HealthKitOnFHIRError.invalidFHIRResource
        }

        switch resource.resourceType {
        case .allergyIntolerance:
            return try decode(AllergyIntolerance.self)
        default:
            throw HealthKitOnFHIRError.notSupported
        }

    }

    private func decode<T: Resource>(
        _ type: T.Type = T.self
    ) throws -> T {
        guard let fhirResource = self.fhirResource else {
            throw HealthKitOnFHIRError.invalidFHIRResource
        }

        guard fhirResource.fhirVersion == HKFHIRVersion.primaryR4() else {
            throw HealthKitOnFHIRError.unsupportedFHIRVersion
        }

        let decoder = JSONDecoder()
        do {
            let resource = try decoder.decode(T.self, from: fhirResource.data)
            return resource
        } catch {
            throw HealthKitOnFHIRError.notSupported
        }
    }
}
