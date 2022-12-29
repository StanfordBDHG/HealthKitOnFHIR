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
            return try convert(AllergyIntolerance.self)
        }
    }

    public var medicationDispense: MedicationDispense {
        get throws {
            return try convert(MedicationDispense.self)
        }
    }

    public var medicationRequest: MedicationRequest {
        get throws {
            return try convert(MedicationRequest.self)
        }
    }

    public var medicationStatement: MedicationStatement {
        get throws {
            return try convert(MedicationStatement.self)
        }
    }

    public var condition: Condition {
        get throws {
            return try convert(Condition.self)
        }
    }

    public var coverage: Coverage {
        get throws {
            return try convert(Coverage.self)
        }
    }

    public var immunization: Immunization {
        get throws {
            return try convert(Immunization.self)
        }
    }

    public var procedure: Procedure {
        get throws {
            return try convert(Procedure.self)
        }
    }

    func buildResource() throws -> Resource {
        guard let resource = self.fhirResource else {
            throw HealthKitOnFHIRError.invalidFHIRResource
        }

        switch resource.resourceType {
        case .allergyIntolerance:
            return try decode(AllergyIntolerance.self)
        case .medicationDispense:
            return try decode(MedicationDispense.self)
        case .medicationRequest:
            return try decode(MedicationRequest.self)
        case .medicationStatement:
            return try decode(MedicationStatement.self)
        case .condition:
            return try decode(Condition.self)
        case .coverage:
            return try decode(Coverage.self)
        case .immunization:
            return try decode(Immunization.self)
        case .observation:
            return try decode(Observation.self)
        case .procedure:
            return try decode(Procedure.self)
        default:
            throw HealthKitOnFHIRError.notSupported
        }

    }

    private func convert<T: Resource>(_ type: T.Type = T.self) throws -> T {
        guard let resource = try buildResource() as? T else {
            throw HealthKitOnFHIRError.invalidFHIRResource
        }
        return resource
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
