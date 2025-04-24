//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit


/// Models a value type used by a `HKCategoryType`.
protocol FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String { get throws }
    
    init?(rawValue: Int)
}


@available(iOS 18.0, macOS 15.0, watchOS 11.0 *)
extension HKCategoryValueVaginalBleeding: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
        get throws {
            switch self {
            case .unspecified:
                return "unspecified"
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


extension HKCategoryValueCervicalMucusQuality: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueMenstrualFlow: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueOvulationTestResult: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueContraceptive: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueSleepAnalysis: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueAppetiteChanges: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueEnvironmentalAudioExposureEvent: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueHeadphoneAudioExposureEvent: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueLowCardioFitnessEvent: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKAppleWalkingSteadinessClassification: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueAppleWalkingSteadinessEvent: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValuePregnancyTestResult: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueProgesteroneTestResult: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueAppleStandHour: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValueSeverity: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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


extension HKCategoryValuePresence: FHIRCompatibleHKCategoryValueType {
    var fhirCategoryValue: String {
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
