//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_exported import HealthKit
@_exported import ModelsR4


extension HKSample {
    /// A FHIR observation based on the concrete subclass of `HKSample`.
    ///
    /// If a specific `HKSample` type is currently not supported the property returns an ``HealthKitOnFHIRError/notSupported`` error.
    public var observation: Observation {
        get throws {
            var observation = Observation(
                code: CodeableConcept(),
                status: FHIRPrimitive<ObservationStatus>(.final)
            )
            
            observation.appendIdentifier(Identifier(id: self.uuid.uuidString.asFHIRStringPrimitive()))
            observation.setEffective(startDate: self.startDate, endDate: self.endDate)
            observation.setIssued(on: Date())
            
            observation.appendCodings(self.sampleType.codes)
            
            switch self {
            case let quantitySample as HKQuantitySample:
                try quantitySample.buildQuantitySampleObservation(&observation)
            default:
                throw HealthKitOnFHIRError.notSupported
            }
            
            return observation
        }
    }
}
