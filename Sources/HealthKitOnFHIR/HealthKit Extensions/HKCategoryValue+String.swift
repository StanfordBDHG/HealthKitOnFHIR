//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
import HealthKit

extension HKCategoryValueCervicalMucusQuality: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dry:
            return "dry"
        case .sticky:
            return "sticky"
        case .creamy:
            return "creamy"
        case .watery:
            return "watery"
        case .eggWhite:
            return "eggWhite"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueMenstrualFlow: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unspecified:
            return "dry"
        case .light:
            return "light"
        case .medium:
            return "medium"
        case .heavy:
            return "heavy"
        case .none:
            return "none"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueOvulationTestResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .negative:
            return "negative"
        case .luteinizingHormoneSurge:
            return "luteinizing hormone surge"
        case .indeterminate:
            return "indeterminate"
        case .estrogenSurge:
            return "estrogen surge"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueContraceptive: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .implant:
            return "implant"
        case .injection:
            return "injection"
        case .intrauterineDevice:
            return "intrauterine device"
        case .intravaginalRing:
            return "intravaginal ring"
        case .oral:
            return "oral"
        case .patch:
            return "patch"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueSleepAnalysis: CustomStringConvertible {
    public var description: String {
        switch self {
        case .inBed:
            return "in bed"
        case .asleepUnspecified:
            return "asleep unspecified"
        case .awake:
            return "awake"
        case .asleepCore:
            return "asleep core"
        case .asleepDeep:
            return "asleep deep"
        case .asleepREM:
            return "asleep REM"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueAppetiteChanges: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .noChange:
            return "no change"
        case .decreased:
            return "decreased"
        case .increased:
            return "increased"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueEnvironmentalAudioExposureEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .momentaryLimit:
            return "momentary limit"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueHeadphoneAudioExposureEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sevenDayLimit:
            return "seven day limit"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueLowCardioFitnessEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .lowFitness:
            return "low fitness"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKAppleWalkingSteadinessClassification: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ok:
            return "ok"
        case .low:
            return "low"
        case .veryLow:
            return "very low"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueAppleWalkingSteadinessEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .initialLow:
            return "initial low"
        case .initialVeryLow:
            return "initial very low"
        case .repeatLow:
            return "repeat low"
        case .repeatVeryLow:
            return "repeat very low"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValuePregnancyTestResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .negative:
            return "negative"
        case .positive:
            return "positive"
        case .indeterminate:
            return "indeterminate"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueProgesteroneTestResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .negative:
            return "negative"
        case .positive:
            return "positive"
        case .indeterminate:
            return "indeterminate"
        @unknown default:
            return "unknown"
        }
    }
}

extension HKCategoryValueAppleStandHour: CustomStringConvertible {
    public var description: String {
        switch self {
        case .stood:
            return "stood"
        case .idle:
            return "idle"
        @unknown default:
            return "unknown"
        }
    }
}
