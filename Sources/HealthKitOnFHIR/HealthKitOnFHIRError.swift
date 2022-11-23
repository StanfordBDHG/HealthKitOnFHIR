//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Error thrown by the HealthKitOnFHIR module if transforming a specific `HKSample` type to a FHIR `Observation` was not possible.
enum HealthKitOnFHIRError: Error {
    /// Indicates that a specific `HKSample` type is currently not supported by HealthKitOnFHIR.
    case notSupported
}
