//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_exported import HealthKit
@_exported import ModelsR4


/// Extension to handle all FHIR resources apart from Observation (only used by HKClinicalRecord)
extension HKSample {
    /// A FHIR AllergyIntolerance resource from an `HKClinicalRecord` containing allergy data
    public var allergyIntolerance: AllergyIntolerance {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: AllergyIntolerance.self)
        }
    }

    /// A FHIR MedicationDispense resource from an `HKClinicalRecord` containing medication data
    public var medicationDispense: MedicationDispense {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: MedicationDispense.self)
        }
    }

    /// A FHIR MedicationRequest resource from an `HKClinicalRecord` containing medication data
    public var medicationRequest: MedicationRequest {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: MedicationRequest.self)
        }
    }

    /// A FHIR MedicationStatement resource from an `HKClinicalRecord` containing medication data
    public var medicationStatement: MedicationStatement {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: MedicationStatement.self)
        }
    }

    /// A FHIR Condition resource from an `HKClinicalRecord` containing a medical condition
    public var condition: Condition {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: Condition.self)
        }
    }

    /// A FHIR Coverage resource from an `HKClinicalRecord` containing insurance coverage
    public var coverage: Coverage {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: Coverage.self)
        }
    }

    /// A FHIR Immunization resource from an `HKClinicalRecord` containing an immunization record
    public var immunization: Immunization {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: Immunization.self)
        }
    }

    /// A FHIR Procedure resource from an `HKClinicalRecord` containing a procedure record
    public var procedure: Procedure {
        get throws {
            guard let clinicalRecord = self as? HKClinicalRecord else {
                throw HealthKitOnFHIRError.notSupported
            }
            return try clinicalRecord.convert(to: Procedure.self)
        }
    }

}
