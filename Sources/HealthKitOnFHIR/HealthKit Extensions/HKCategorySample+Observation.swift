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
            valueString = HKCategoryValueAppetiteChanges(rawValue: self.value)?.description
        case HKCategoryType(.appleStandHour):
            valueString = HKCategoryValueAppleStandHour(rawValue: self.value)?.description
        case HKCategoryType(.appleWalkingSteadinessEvent):
            valueString = HKCategoryValueAppleWalkingSteadinessEvent(rawValue: self.value)?.description
        case HKCategoryType(.cervicalMucusQuality):
            valueString = HKCategoryValueCervicalMucusQuality(rawValue: self.value)?.description
        case HKCategoryType(.contraceptive):
            valueString = HKCategoryValueContraceptive(rawValue: self.value)?.description
        case HKCategoryType(.environmentalAudioExposureEvent):
            valueString = HKCategoryValueEnvironmentalAudioExposureEvent(rawValue: self.value)?.description
        case HKCategoryType(.headphoneAudioExposureEvent):
            valueString = HKCategoryValueHeadphoneAudioExposureEvent(rawValue: self.value)?.description
        case HKCategoryType(.lowCardioFitnessEvent):
            valueString = HKCategoryValueLowCardioFitnessEvent(rawValue: self.value)?.description
        case HKCategoryType(.menstrualFlow):
            valueString = HKCategoryValueMenstrualFlow(rawValue: self.value)?.description
        case HKCategoryType(.ovulationTestResult):
            valueString = HKCategoryValueOvulationTestResult(rawValue: self.value)?.description
        case HKCategoryType(.pregnancyTestResult):
            valueString = HKCategoryValuePregnancyTestResult(rawValue: self.value)?.description
        case HKCategoryType(.progesteroneTestResult):
            valueString = HKCategoryValueProgesteroneTestResult(rawValue: self.value)?.description
        case HKCategoryType(.sleepAnalysis):
            valueString = HKCategoryValueSleepAnalysis(rawValue: self.value)?.description
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
            HKCategoryType(.moodChanges),
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
            valueString = HKCategoryValueSeverity(rawValue: self.value)?.description


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
