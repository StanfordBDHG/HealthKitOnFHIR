//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit


protocol HKCategoryValueDescription: CustomStringConvertible {
    var categoryValueDescription: String { get throws }
}

extension HKCategoryValueDescription {
    /// A string description of the HKCategoryValue case
    public var description: String {
        do {
            return try categoryValueDescription
        } catch {
            return "undefined"
        }
    }
}

extension HKCategoryValueCervicalMucusQuality: @retroactive CustomStringConvertible {}
extension HKCategoryValueCervicalMucusQuality: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
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
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueMenstrualFlow: @retroactive CustomStringConvertible {}
extension HKCategoryValueMenstrualFlow: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
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
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueOvulationTestResult: @retroactive CustomStringConvertible {}
extension HKCategoryValueOvulationTestResult: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
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
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueContraceptive: @retroactive CustomStringConvertible {}
extension HKCategoryValueContraceptive: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
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
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueSleepAnalysis: @retroactive CustomStringConvertible {}
extension HKCategoryValueSleepAnalysis: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
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
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueAppetiteChanges: @retroactive CustomStringConvertible {}
extension HKCategoryValueAppetiteChanges: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
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
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueEnvironmentalAudioExposureEvent: @retroactive CustomStringConvertible {}
extension HKCategoryValueEnvironmentalAudioExposureEvent: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .momentaryLimit:
                return "momentary limit"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueHeadphoneAudioExposureEvent: @retroactive CustomStringConvertible {}
extension HKCategoryValueHeadphoneAudioExposureEvent: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .sevenDayLimit:
                return "seven day limit"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueLowCardioFitnessEvent: @retroactive CustomStringConvertible {}
extension HKCategoryValueLowCardioFitnessEvent: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .lowFitness:
                return "low fitness"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKAppleWalkingSteadinessClassification: @retroactive CustomStringConvertible {}
extension HKAppleWalkingSteadinessClassification: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .ok:
                return "ok"
            case .low:
                return "low"
            case .veryLow:
                return "very low"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueAppleWalkingSteadinessEvent: @retroactive CustomStringConvertible {}
extension HKCategoryValueAppleWalkingSteadinessEvent: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
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
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValuePregnancyTestResult: @retroactive CustomStringConvertible {}
extension HKCategoryValuePregnancyTestResult: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .negative:
                return "negative"
            case .positive:
                return "positive"
            case .indeterminate:
                return "indeterminate"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueProgesteroneTestResult: @retroactive CustomStringConvertible {}
extension HKCategoryValueProgesteroneTestResult: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .negative:
                return "negative"
            case .positive:
                return "positive"
            case .indeterminate:
                return "indeterminate"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueAppleStandHour: @retroactive CustomStringConvertible {}
extension HKCategoryValueAppleStandHour: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .stood:
                return "stood"
            case .idle:
                return "idle"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValueSeverity: @retroactive CustomStringConvertible {}
extension HKCategoryValueSeverity: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .unspecified:
                return "unspecified"
            case .notPresent:
                return "not present"
            case .mild:
                return "mild"
            case .moderate:
                return "moderate"
            case .severe:
                return "severe"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}

extension HKCategoryValuePresence: @retroactive CustomStringConvertible {}
extension HKCategoryValuePresence: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .present:
                return "present"
            case .notPresent:
                return "not present"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}
