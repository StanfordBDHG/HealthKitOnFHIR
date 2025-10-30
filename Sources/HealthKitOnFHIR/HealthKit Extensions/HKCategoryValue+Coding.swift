//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import HealthKitOnFHIRMacros
import ModelsR4


/// Models a value type used by a `HKCategoryType`.
protocol FHIRCodingConvertible {
    static var system: FHIRPrimitive<FHIRURI> { get }
    
    var code: String { get }
    var display: String? { get }
    
    init?(rawValue: Int)
}

extension FHIRCodingConvertible {
    var asCoding: Coding {
        Coding(
            code: code.asFHIRStringPrimitive(),
            display: display?.asFHIRStringPrimitive(),
            system: Self.system
        )
    }
}


extension FHIRCodingConvertible where Self: RawRepresentable, RawValue == Int {
    var code: String {
        String(rawValue)
    }
}


protocol FHIRCodingConvertibleHKEnum: FHIRCodingConvertible {}

extension FHIRCodingConvertibleHKEnum {
    static var system: FHIRPrimitive<FHIRURI> {
        let typename = String(describing: Self.self).lowercased()
        return "https://developer.apple.com/documentation/healthkit/\(typename)".asFHIRURIPrimitive()! // swiftlint:disable:this force_unwrapping
    }
}


// MARK: Extensions

@EnumCases("unspecified", "light", "medium", "heavy", "none")
@available(iOS 18.0, macOS 15.0, watchOS 11.0, *)
extension HKCategoryValueVaginalBleeding: FHIRCodingConvertibleHKEnum {}

@EnumCases("dry", "sticky", "creamy", "watery", "eggWhite")
extension HKCategoryValueCervicalMucusQuality: FHIRCodingConvertibleHKEnum {}

@EnumCases("unspecified", "light", "medium", "heavy", "none")
extension HKCategoryValueMenstrualFlow: FHIRCodingConvertibleHKEnum {}

@EnumCases("negative", "luteinizingHormoneSurge", "indeterminate", "estrogenSurge")
extension HKCategoryValueOvulationTestResult: FHIRCodingConvertibleHKEnum {}

@EnumCases("unspecified", "implant", "injection", "intrauterineDevice", "intravaginalRing", "oral", "patch")
extension HKCategoryValueContraceptive: FHIRCodingConvertibleHKEnum {}

@EnumCases("inBed", "asleepUnspecified", "awake", "asleepCore", "asleepDeep", "asleepREM")
extension HKCategoryValueSleepAnalysis: FHIRCodingConvertibleHKEnum {}

@EnumCases("unspecified", "noChange", "decreased", "increased")
extension HKCategoryValueAppetiteChanges: FHIRCodingConvertibleHKEnum {}

@EnumCases("momentaryLimit")
extension HKCategoryValueEnvironmentalAudioExposureEvent: FHIRCodingConvertibleHKEnum {}

@EnumCases("sevenDayLimit")
extension HKCategoryValueHeadphoneAudioExposureEvent: FHIRCodingConvertibleHKEnum {}

@EnumCases("lowFitness")
extension HKCategoryValueLowCardioFitnessEvent: FHIRCodingConvertibleHKEnum {}

@EnumCases("ok", "low", "veryLow")
extension HKAppleWalkingSteadinessClassification: FHIRCodingConvertibleHKEnum {}

@EnumCases("initialLow", "initialVeryLow", "repeatLow", "repeatVeryLow")
extension HKCategoryValueAppleWalkingSteadinessEvent: FHIRCodingConvertibleHKEnum {}

@EnumCases("negative", "positive", "indeterminate")
extension HKCategoryValuePregnancyTestResult: FHIRCodingConvertibleHKEnum {}

@EnumCases("negative", "positive", "indeterminate")
extension HKCategoryValueProgesteroneTestResult: FHIRCodingConvertibleHKEnum {}

@EnumCases("stood", "idle")
extension HKCategoryValueAppleStandHour: FHIRCodingConvertibleHKEnum {}

@EnumCases("unspecified", "notPresent", "mild", "moderate", "severe")
extension HKCategoryValueSeverity: FHIRCodingConvertibleHKEnum {}

@EnumCases("present", "notPresent")
extension HKCategoryValuePresence: FHIRCodingConvertibleHKEnum {}
