//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKCategorySample {
    func buildCategoryObservation(_ observation: inout Observation) throws {
        var valueString = ""
        switch self.categoryType {
        case HKCategoryType(.cervicalMucusQuality):
            switch self.value {
            case 1:
                valueString = "dry"
            case 2:
                valueString = "sticky"
            case 3:
                valueString = "creamy"
            case 4:
                valueString = "watery"
            case 5:
                valueString = "eggWhite"
            default:
                throw HealthKitOnFHIRError.notSupported
            }
        case HKCategoryType(.menstrualFlow):
            switch self.value {
            case 1:
                valueString = "unspecified"
            case 2:
                valueString = "none"
            case 3:
                valueString = "light"
            case 4:
                valueString = "medium"
            case 5:
                valueString = "heavy"
            default:
                throw HealthKitOnFHIRError.notSupported
            }
        case HKCategoryType(.ovulationTestResult):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.contraceptive):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.sleepAnalysis):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.appetiteChanges):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.environmentalAudioExposureEvent):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.headphoneAudioExposureEvent):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.lowCardioFitnessEvent):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.appleWalkingSteadinessEvent):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.pregnancyTestResult):
            throw HealthKitOnFHIRError.notSupported
        case HKCategoryType(.progesteroneTestResult):
            throw HealthKitOnFHIRError.notSupported
        default:
            throw HealthKitOnFHIRError.notSupported
        }

        observation.value = .string(valueString.asFHIRStringPrimitive())
    }
}
