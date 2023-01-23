//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKSampleType {
    /// Converts an `HKSampleType` into the corresponding FHIR resource type, defined as a `ResourceType`
    public var resourceTyoe: ResourceType {
        get throws {
            switch self {
            case is HKQuantityType, is HKCorrelationType, is HKCategoryType:
                return ResourceType.observation
            case is HKClinicalType:
                return ResourceType.resource
            default:
                throw HealthKitOnFHIRError.notSupported
            }
        }
    }
}
