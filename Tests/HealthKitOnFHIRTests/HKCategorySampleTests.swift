//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
@testable import HealthKitOnFHIR
import ModelsR4
import Testing


// swiftlint:disable file_length type_body_length
@MainActor // to work around https://github.com/apple/FHIRModels/issues/36
struct HKCategorySampleTests {
    var startDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 0) // Date Stanford University opened (https://www.stanford.edu/about/history/)
            return try #require(Calendar.current.date(from: dateComponents))
        }
    }

    var endDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 42)
            return try #require(Calendar.current.date(from: dateComponents))
        }
    }

    
    func createObservationFrom(
        type categoryType: HKCategoryTypeIdentifier,
        value: Int,
        metadata: [String: Any] = [:]
    ) throws -> Observation {
        let categorySample = HKCategorySample(
            type: HKCategoryType(categoryType),
            value: value,
            start: try startDate,
            end: try endDate,
            metadata: metadata
        )
        return try #require(categorySample.resource().get(if: Observation.self))
    }

    func createCategoryCoding(
        categoryType: HKCategoryTypeIdentifier,
        display: String
    ) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: categoryType.rawValue),
            display: FHIRPrimitive(stringLiteral: display),
            system: FHIRPrimitive(FHIRURI(stringLiteral: SupportedCodeSystem.apple.rawValue))
        )
    }

    
    @Test
    func cervicalMucusQuality() throws {
        let values: [HKCategoryValueCervicalMucusQuality] = [.dry, .sticky, .creamy, .watery, .eggWhite]
        for value in values {
            let observation = try createObservationFrom(
                type: .cervicalMucusQuality,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .cervicalMucusQuality,
                display: "Cervical Mucus Quality"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func menstrualFlow() throws {
        let values: [HKCategoryValueMenstrualFlow] = [.unspecified, .light, .medium, .heavy, .none]
        for value in values {
            let observation = try createObservationFrom(
                type: .menstrualFlow,
                value: value.rawValue,
                metadata: [HKMetadataKeyMenstrualCycleStart: true]
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .menstrualFlow,
                display: "Menstrual Flow"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func ovulationTestResult() throws {
        let values: [HKCategoryValueOvulationTestResult] = [.negative, .indeterminate, .luteinizingHormoneSurge, .estrogenSurge]
        for value in values {
            let observation = try createObservationFrom(
                type: .ovulationTestResult,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .ovulationTestResult,
                display: "Ovulation Test Result"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func contraceptive() throws {
        let values: [HKCategoryValueContraceptive] = [.unspecified, .implant, .injection, .intrauterineDevice, .intravaginalRing, .oral, .patch]
        for value in values {
            let observation = try createObservationFrom(
                type: .contraceptive,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .contraceptive,
                display: "Contraceptive"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func sleepAnalysis() throws {
        let values: [HKCategoryValueSleepAnalysis] = [.inBed, .asleepUnspecified, .awake, .asleepCore, .asleepDeep, .asleepREM]
        for value in values {
            let observation = try createObservationFrom(
                type: .sleepAnalysis,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .sleepAnalysis,
                display: "Sleep Analysis"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func appetiteChanges() throws {
        let values: [HKCategoryValueAppetiteChanges] = [.unspecified, .noChange, .decreased, .increased]
        for value in values {
            let observation = try createObservationFrom(
                type: .appetiteChanges,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .appetiteChanges,
                display: "Appetite Changes"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func environmentalAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: .environmentalAudioExposureEvent,
            value: HKCategoryValueEnvironmentalAudioExposureEvent.momentaryLimit.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .environmentalAudioExposureEvent,
            display: "Environmental Audio Exposure Event"
        ))
        #expect(observation.value == .string("momentary limit".asFHIRStringPrimitive()))
    }

    @Test
    func headphoneAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: .headphoneAudioExposureEvent,
            value: HKCategoryValueHeadphoneAudioExposureEvent.sevenDayLimit.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .headphoneAudioExposureEvent,
            display: "Headphone Audio Exposure Event"
        ))
        #expect(observation.value == .string("seven day limit".asFHIRStringPrimitive()))
    }

    @Test
    func lowCardioFitnessEvent() throws {
        let observation = try createObservationFrom(
            type: .lowCardioFitnessEvent,
            value: HKCategoryValueLowCardioFitnessEvent.lowFitness.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .lowCardioFitnessEvent,
            display: "Low Cardio Fitness Event"
        ))
        #expect(observation.value == .string("low fitness".asFHIRStringPrimitive()))
    }
    
    @Test
    func lowCardioFitnessEventWithMetadata() throws {
        let observation = try createObservationFrom(
            type: .lowCardioFitnessEvent,
            value: HKCategoryValueLowCardioFitnessEvent.lowFitness.rawValue,
            metadata: [
                HKMetadataKeyLowCardioFitnessEventThreshold: HKQuantity(unit: HKUnit(from: "ml/(kg*min)"), doubleValue: 41)
            ]
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .lowCardioFitnessEvent,
            display: "Low Cardio Fitness Event"
        ))
        #expect(observation.value == .string("low fitness".asFHIRStringPrimitive()))
        #expect(observation.component?.count == 1)
        let component = try #require(observation.component?.first)
        #expect(component.code.coding == [
            Coding(
                code: "HKQuantityTypeIdentifierVO2Max".asFHIRStringPrimitive(),
                display: "VO2 Max".asFHIRStringPrimitive(),
                system: SupportedCodeSystem.apple.rawValue.asFHIRURIPrimitive()
            )
        ])
        #expect(component.value == .quantity(Quantity(
            code: "mL/kg/min",
            system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
            unit: "mL/kg/min",
            value: 41.asFHIRDecimalPrimitive()
        )))
    }

    @Test
    func appleWalkingSteadinessEvent() throws {
        let values: [HKCategoryValueAppleWalkingSteadinessEvent] = [.initialLow, .initialVeryLow, .repeatLow, .repeatVeryLow]
        for value in values {
            let observation = try createObservationFrom(
                type: .appleWalkingSteadinessEvent,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .appleWalkingSteadinessEvent,
                display: "Apple Walking Steadiness Event"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func appleWalkingSteadinessClassification() throws {
        let okClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.ok.rawValue
        )?.fhirCategoryValue
        #expect(okClassification == "ok")

        let lowClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.low.rawValue
        )?.fhirCategoryValue
        #expect(lowClassification == "low")

        let veryLowClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.veryLow.rawValue
        )?.fhirCategoryValue
        #expect(veryLowClassification == "very low")
    }
    
    @Test(arguments: [
        (HKCategoryTypeIdentifier.lowHeartRateEvent, "Low Heart Rate Event"),
        (HKCategoryTypeIdentifier.highHeartRateEvent, "High Heart Rate Event")
    ])
    func lowHeartRateEvent(category: HKCategoryTypeIdentifier, displayTitle: String) throws {
        let observation = try createObservationFrom(
            type: category,
            value: HKCategoryValue.notApplicable.rawValue,
            metadata: [
                HKMetadataKeyHeartRateEventThreshold: HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 47)
            ]
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: category,
            display: displayTitle
        ))
        #expect(observation.value == .string(category.rawValue.asFHIRStringPrimitive()))
        #expect(observation.component?.count == 1)
        let component = try #require(observation.component?.first)
        #expect(component.code.coding == [
            Coding(
                code: "8867-4".asFHIRStringPrimitive(),
                display: "Heart rate".asFHIRStringPrimitive(),
                system: SupportedCodeSystem.loinc.rawValue.asFHIRURIPrimitive()
            ),
            Coding(
                code: "HKQuantityTypeIdentifierHeartRate".asFHIRStringPrimitive(),
                display: "Heart Rate".asFHIRStringPrimitive(),
                system: SupportedCodeSystem.apple.rawValue.asFHIRURIPrimitive()
            )
        ])
        #expect(component.value == .quantity(Quantity(
            code: "/min",
            system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
            unit: "beats/minute",
            value: 47.asFHIRDecimalPrimitive()
        )))
    }

    @Test
    func pregnancyTestResult() throws {
        let values: [HKCategoryValuePregnancyTestResult] = [.negative, .positive, .indeterminate]
        for value in values {
            let observation = try createObservationFrom(
                type: .pregnancyTestResult,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .pregnancyTestResult,
                display: "Pregnancy Test Result"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }
    
    @Test
    func pregnancy() throws {
        let observation = try createObservationFrom(
            type: .pregnancy,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .pregnancy,
            display: "Pregnancy"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierPregnancy".asFHIRStringPrimitive()))
    }

    @Test
    func progesteroneTestResult() throws {
        let values: [HKCategoryValueProgesteroneTestResult] = [.indeterminate, .positive, .negative]
        for value in values {
            let observation = try createObservationFrom(
                type: .progesteroneTestResult,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .progesteroneTestResult,
                display: "Progesterone Test Result"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }
    
    @Test
    func sexualActivityNoMetadata() throws {
        let observation = try createObservationFrom(
            type: .sexualActivity,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .sexualActivity,
            display: "Sexual Activity"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierSexualActivity".asFHIRStringPrimitive()))
        #expect(observation.component == nil)
    }
    
    @Test
    func sexualActivityWithMetadata1() throws {
        let observation = try createObservationFrom(
            type: .sexualActivity,
            value: HKCategoryValue.notApplicable.rawValue,
            metadata: [
                HKMetadataKeySexualActivityProtectionUsed: true
            ]
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .sexualActivity,
            display: "Sexual Activity"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierSexualActivity".asFHIRStringPrimitive()))
        #expect(observation.component?.count == 1)
        #expect(observation.component?.first?.value == .boolean(true))
    }
    
    @Test
    func sexualActivityWithMetadata2() throws {
        let observation = try createObservationFrom(
            type: .sexualActivity,
            value: HKCategoryValue.notApplicable.rawValue,
            metadata: [
                HKMetadataKeySexualActivityProtectionUsed: false
            ]
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .sexualActivity,
            display: "Sexual Activity"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierSexualActivity".asFHIRStringPrimitive()))
        #expect(observation.component?.count == 1)
        #expect(observation.component?.first?.value == .boolean(false))
    }

    @Test
    func appleStandHour() throws {
        let values: [HKCategoryValueAppleStandHour] = [.stood, .idle]
        for value in values {
            let observation = try createObservationFrom(
                type: .appleStandHour,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .appleStandHour,
                display: "Apple Stand Hour"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func intermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: .intermenstrualBleeding,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .intermenstrualBleeding,
            display: "Intermenstrual Bleeding"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierIntermenstrualBleeding".asFHIRStringPrimitive()))
    }

    @Test
    func infrequentMenstrualCycles() throws {
        let observation = try createObservationFrom(
            type: .infrequentMenstrualCycles,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .infrequentMenstrualCycles,
            display: "Infrequent Menstrual Cycles"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierInfrequentMenstrualCycles".asFHIRStringPrimitive()))
    }
    
    @Test
    func irregularHeartRhythmEvent() throws {
        let observation = try createObservationFrom(
            type: .irregularHeartRhythmEvent,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .irregularHeartRhythmEvent,
            display: "Irregular Heart Rhythm Event"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierIrregularHeartRhythmEvent".asFHIRStringPrimitive()))
    }

    @Test
    func irregularMenstrualCycles() throws {
        let observation = try createObservationFrom(
            type: .irregularMenstrualCycles,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .irregularMenstrualCycles,
            display: "Irregular Menstrual Cycles"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierIrregularMenstrualCycles".asFHIRStringPrimitive()))
    }

    @Test
    func persistentIntermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: .persistentIntermenstrualBleeding,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .persistentIntermenstrualBleeding,
            display: "Persistent Intermenstrual Bleeding"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierPersistentIntermenstrualBleeding".asFHIRStringPrimitive()))
    }

    @Test
    func prolongedMenstrualPeriods() throws {
        let observation = try createObservationFrom(
            type: .prolongedMenstrualPeriods,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .prolongedMenstrualPeriods,
            display: "Prolonged Menstrual Periods"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierProlongedMenstrualPeriods".asFHIRStringPrimitive()))
    }

    @Test
    func lactation() throws {
        let observation = try createObservationFrom(
            type: .lactation,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .lactation,
            display: "Lactation"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierLactation".asFHIRStringPrimitive()))
    }

    @Test
    func handwashingEvent() throws {
        let observation = try createObservationFrom(
            type: .handwashingEvent,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .handwashingEvent,
            display: "Handwashing Event"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierHandwashingEvent".asFHIRStringPrimitive()))
    }

    @Test
    func toothbrushingEvent() throws {
        let observation = try createObservationFrom(
            type: .toothbrushingEvent,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .toothbrushingEvent,
            display: "Toothbrushing Event"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierToothbrushingEvent".asFHIRStringPrimitive()))
    }

    @Test
    func mindfulSession() throws {
        let observation = try createObservationFrom(
            type: .mindfulSession,
            value: HKCategoryValue.notApplicable.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: .mindfulSession,
            display: "Mindful Session"
        ))
        #expect(observation.value == .string("HKCategoryTypeIdentifierMindfulSession".asFHIRStringPrimitive()))
    }

    
    // MARK: Symptom Tests

    func testSymptoms(type: HKCategoryTypeIdentifier, display: String) throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]
        for value in values {
            let observation = try createObservationFrom(
                type: type,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: type,
                display: display
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func abdominalCramps() throws {
        try testSymptoms(type: .abdominalCramps, display: "Abdominal Cramps")
    }

    @Test
    func acne() throws {
        try testSymptoms(type: .acne, display: "Acne")
    }

    @Test
    func bladderIncontinence() throws {
        try testSymptoms(type: .bladderIncontinence, display: "Bladder Incontinence")
    }

    @Test
    func bloating() throws {
        try testSymptoms(type: .bloating, display: "Bloating")
    }

    @Test
    func breastPain() throws {
        try testSymptoms(type: .breastPain, display: "Breast Pain")
    }

    @Test
    func chestTightnessOrPain() throws {
        try testSymptoms(type: .chestTightnessOrPain, display: "Chest Tightness Or Pain")
    }

    @Test
    func chills() throws {
        try testSymptoms(type: .chills, display: "Chills")
    }

    @Test
    func constipation() throws {
        try testSymptoms(type: .constipation, display: "Constipation")
    }

    @Test
    func coughing() throws {
        try testSymptoms(type: .coughing, display: "Coughing")
    }

    @Test
    func dizziness() throws {
        try testSymptoms(type: .dizziness, display: "Dizziness")
    }

    @Test
    func drySkin() throws {
        try testSymptoms(type: .drySkin, display: "Dry Skin")
    }

    @Test
    func fainting() throws {
        try testSymptoms(type: .fainting, display: "Fainting")
    }

    @Test
    func fever() throws {
        try testSymptoms(type: .fever, display: "Fever")
    }

    @Test
    func generalizedBodyAche() throws {
        try testSymptoms(type: .generalizedBodyAche, display: "Generalized Body Ache")
    }

    @Test
    func hairLoss() throws {
        try testSymptoms(type: .hairLoss, display: "Hair Loss")
    }

    @Test
    func headache() throws {
        try testSymptoms(type: .headache, display: "Headache")
    }

    @Test
    func heartburn() throws {
        try testSymptoms(type: .heartburn, display: "Heartburn")
    }

    @Test
    func hotFlashes() throws {
        try testSymptoms(type: .hotFlashes, display: "Hot Flashes")
    }

    @Test
    func lossOfSmell() throws {
        try testSymptoms(type: .lossOfSmell, display: "Loss Of Smell")
    }

    @Test
    func lossOfTaste() throws {
        try testSymptoms(type: .lossOfTaste, display: "Loss Of Taste")
    }

    @Test
    func lowerBackPain() throws {
        try testSymptoms(type: .lowerBackPain, display: "Lower Back Pain")
    }

    @Test
    func memoryLapse() throws {
        try testSymptoms(type: .memoryLapse, display: "Memory Lapse")
    }

    @Test
    func moodChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]
        for value in values {
            let observation = try createObservationFrom(
                type: .moodChanges,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .moodChanges,
                display: "Mood Changes"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    @Test
    func sleepChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]
        for value in values {
            let observation = try createObservationFrom(
                type: .sleepChanges,
                value: value.rawValue
            )
            #expect(observation.code.coding?.first == createCategoryCoding(
                categoryType: .sleepChanges,
                display: "Sleep Changes"
            ))
            #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }
    
    @Test(arguments: product([
        (HKCategoryTypeIdentifier.bleedingDuringPregnancy, "Bleeding During Pregnancy"),
        (HKCategoryTypeIdentifier.bleedingAfterPregnancy, "Bleeding After Pregnancy")
    ], [
        HKCategoryValueVaginalBleeding.none, .light, .medium, .heavy
    ]))
    @available(iOS 18.0, watchOS 11.0, macOS 15.0, visionOS 2.0, *)
    func pregnancyBleeding(categoryInput: (HKCategoryTypeIdentifier, String), value: HKCategoryValueVaginalBleeding) throws {
        let (category, displayTitle) = categoryInput
        let observation = try createObservationFrom(
            type: category,
            value: value.rawValue
        )
        #expect(observation.code.coding?.first == createCategoryCoding(
            categoryType: category,
            display: displayTitle
        ))
        #expect(try observation.value == .string(value.fhirCategoryValue.asFHIRStringPrimitive()))
    }

    @Test
    func nausea() throws {
        try testSymptoms(type: .nausea, display: "Nausea")
    }

    @Test
    func nightSweats() throws {
        try testSymptoms(type: .nightSweats, display: "Night Sweats")
    }

    @Test
    func pelvicPain() throws {
        try testSymptoms(type: .pelvicPain, display: "Pelvic Pain")
    }

    @Test
    func rapidPoundingOrFlutteringHeartbeat() throws {
        try testSymptoms(type: .rapidPoundingOrFlutteringHeartbeat, display: "Rapid Pounding Or Fluttering Heartbeat")
    }

    @Test
    func runnyNose() throws {
        try testSymptoms(type: .runnyNose, display: "Runny Nose")
    }

    @Test
    func shortnessOfBreath() throws {
        try testSymptoms(type: .shortnessOfBreath, display: "Shortness Of Breath")
    }

    @Test
    func sinusCongestion() throws {
        try testSymptoms(type: .sinusCongestion, display: "Sinus Congestion")
    }

    @Test
    func skippedHeartbeat() throws {
        try testSymptoms(type: .skippedHeartbeat, display: "Skipped Heartbeat")
    }

    @Test
    func soreThroat() throws {
        try testSymptoms(type: .soreThroat, display: "Sore Throat")
    }

    @Test
    func vaginalDryness() throws {
        try testSymptoms(type: .vaginalDryness, display: "Vaginal Dryness")
    }

    @Test
    func vomiting() throws {
        try testSymptoms(type: .vomiting, display: "Vomiting")
    }

    @Test
    func wheezing() throws {
        try testSymptoms(type: .wheezing, display: "Wheezing")
    }
}


func product<C1: Collection, C2: Collection>(
    _ first: C1,
    _ second: C2
) -> some Collection<(C1.Element, C2.Element)> & Sendable where C1: Sendable, C2: Sendable, C1.Element: Sendable, C2.Element: Sendable {
    first.lazy.flatMap { element1 in
        second.lazy.map { element2 in
            (element1, element2)
        }
    }
}
