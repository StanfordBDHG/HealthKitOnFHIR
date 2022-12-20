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
    // Disabled the following rules as this function is readable
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func buildCategoryObservation(
        _ observation: inout Observation,
        mappings: HKSampleMapping = HKSampleMapping.default
    ) throws {
        guard let mapping = mappings.categorySampleMapping[self.categoryType] else {
            throw HealthKitOnFHIRError.notSupported
        }

        let valueString: String?
        switch self.categoryType {
        case HKCategoryType(.appetiteChanges):
            valueString = try HKCategoryValueAppetiteChanges(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.appleStandHour):
            valueString = try HKCategoryValueAppleStandHour(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.appleWalkingSteadinessEvent):
            valueString = try HKCategoryValueAppleWalkingSteadinessEvent(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.cervicalMucusQuality):
            valueString = try HKCategoryValueCervicalMucusQuality(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.contraceptive):
            valueString = try HKCategoryValueContraceptive(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.environmentalAudioExposureEvent):
            valueString = try HKCategoryValueEnvironmentalAudioExposureEvent(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.headphoneAudioExposureEvent):
            valueString = try HKCategoryValueHeadphoneAudioExposureEvent(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.lowCardioFitnessEvent):
            valueString = try HKCategoryValueLowCardioFitnessEvent(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.menstrualFlow):
            valueString = try HKCategoryValueMenstrualFlow(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.ovulationTestResult):
            valueString = try HKCategoryValueOvulationTestResult(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.pregnancyTestResult):
            valueString = try HKCategoryValuePregnancyTestResult(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.progesteroneTestResult):
            valueString = try HKCategoryValueProgesteroneTestResult(rawValue: self.value)?.categoryValueDescription
        case HKCategoryType(.sleepAnalysis):
            valueString = try HKCategoryValueSleepAnalysis(rawValue: self.value)?.categoryValueDescription
        case
            HKCategoryType(.abdominalCramps),
            HKCategoryType(.acne),
            HKCategoryType(.bladderIncontinence),
            HKCategoryType(.bloating),
            HKCategoryType(.breastPain),
            HKCategoryType(.chestTightnessOrPain),
            HKCategoryType(.chills),
            HKCategoryType(.constipation),
            HKCategoryType(.coughing),
            HKCategoryType(.dizziness),
            HKCategoryType(.drySkin),
            HKCategoryType(.fainting),
            HKCategoryType(.fatigue),
            HKCategoryType(.fever),
            HKCategoryType(.generalizedBodyAche),
            HKCategoryType(.hairLoss),
            HKCategoryType(.headache),
            HKCategoryType(.heartburn),
            HKCategoryType(.hotFlashes),
            HKCategoryType(.lossOfSmell),
            HKCategoryType(.lossOfTaste),
            HKCategoryType(.lowerBackPain),
            HKCategoryType(.memoryLapse),
            HKCategoryType(.nausea),
            HKCategoryType(.nightSweats),
            HKCategoryType(.pelvicPain),
            HKCategoryType(.rapidPoundingOrFlutteringHeartbeat),
            HKCategoryType(.runnyNose),
            HKCategoryType(.shortnessOfBreath),
            HKCategoryType(.sinusCongestion),
            HKCategoryType(.skippedHeartbeat),
            HKCategoryType(.soreThroat),
            HKCategoryType(.vaginalDryness),
            HKCategoryType(.vomiting),
            HKCategoryType(.wheezing):
            // Samples of these types carry values of
            // HKCategoryValueSeverity
            valueString = try HKCategoryValueSeverity(rawValue: self.value)?.categoryValueDescription
        case
            HKCategoryType(.moodChanges),
            HKCategoryType(.sleepChanges):
            // Samples of these types carry values of
            // HKCategoryValuePresence
            valueString = try HKCategoryValuePresence(rawValue: self.value)?.categoryValueDescription
        case
            HKCategoryType(.irregularHeartRhythmEvent),
            HKCategoryType(.lowHeartRateEvent),
            HKCategoryType(.highHeartRateEvent),
            HKCategoryType(.mindfulSession),
            HKCategoryType(.toothbrushingEvent),
            HKCategoryType(.handwashingEvent),
            HKCategoryType(.sexualActivity),
            HKCategoryType(.intermenstrualBleeding),
            HKCategoryType(.infrequentMenstrualCycles),
            HKCategoryType(.irregularMenstrualCycles),
            HKCategoryType(.persistentIntermenstrualBleeding),
            HKCategoryType(.prolongedMenstrualPeriods),
            HKCategoryType(.lactation):
            // Samples of these types do not carry any value,
            // nor associated metadata, so we use the category
            // identifier as the value.
            valueString = self.categoryType.description
        default:
            throw HealthKitOnFHIRError.notSupported
        }
        
        guard let valueString else {
            throw HealthKitOnFHIRError.notSupported
        }

        for code in mapping.codings {
            observation.appendCoding(code.coding)
        }

        observation.setValue(valueString)
    }
}
