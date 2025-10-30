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

@available(iOS 18.0, macOS 15.0, watchOS 11.0, *)
@SynthesizeDisplayProperty("unspecified", "light", "medium", "heavy", "none")
extension HKCategoryValueVaginalBleeding: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("dry", "sticky", "creamy", "watery", "eggWhite")
extension HKCategoryValueCervicalMucusQuality: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("unspecified", "light", "medium", "heavy", "none")
extension HKCategoryValueMenstrualFlow: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("negative", "luteinizingHormoneSurge", "indeterminate", "estrogenSurge")
extension HKCategoryValueOvulationTestResult: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("unspecified", "implant", "injection", "intrauterineDevice", "intravaginalRing", "oral", "patch")
extension HKCategoryValueContraceptive: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("inBed", "asleepUnspecified", "awake", "asleepCore", "asleepDeep", "asleepREM")
extension HKCategoryValueSleepAnalysis: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("unspecified", "noChange", "decreased", "increased")
extension HKCategoryValueAppetiteChanges: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("momentaryLimit")
extension HKCategoryValueEnvironmentalAudioExposureEvent: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("sevenDayLimit")
extension HKCategoryValueHeadphoneAudioExposureEvent: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("lowFitness")
extension HKCategoryValueLowCardioFitnessEvent: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("ok", "low", "veryLow")
extension HKAppleWalkingSteadinessClassification: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("initialLow", "initialVeryLow", "repeatLow", "repeatVeryLow")
extension HKCategoryValueAppleWalkingSteadinessEvent: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("negative", "positive", "indeterminate")
extension HKCategoryValuePregnancyTestResult: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("negative", "positive", "indeterminate")
extension HKCategoryValueProgesteroneTestResult: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("stood", "idle")
extension HKCategoryValueAppleStandHour: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("unspecified", "notPresent", "mild", "moderate", "severe")
extension HKCategoryValueSeverity: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("present", "notPresent")
extension HKCategoryValuePresence: FHIRCodingConvertibleHKEnum {}
