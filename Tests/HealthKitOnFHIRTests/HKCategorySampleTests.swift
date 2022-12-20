//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest

// swiftlint:disable file_length type_body_length
class HKCategorySampleTests: XCTestCase {
    var startDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 0) // Date Stanford University opened (https://www.stanford.edu/about/history/)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }
    }

    var endDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 42)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }
    }

    func createObservationFrom(
        type categoryType: HKCategoryType,
        value: Int,
        metadata: [String: Any] = [:]
    ) throws -> Observation {
        let categorySample = HKCategorySample(
            type: categoryType,
            value: value,
            start: try startDate,
            end: try endDate,
            metadata: metadata
        )
        return try categorySample.observation
    }

    func createCategoryCoding(
        categoryType: String,
        display: String
    ) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: categoryType),
            display: FHIRPrimitive(stringLiteral: display),
            system: FHIRPrimitive(FHIRURI(stringLiteral: SupportedCodeSystem.apple.rawValue))
        )
    }

    func testCervicalMucusQuality() throws {
        let values: [HKCategoryValueCervicalMucusQuality] = [.dry, .sticky, .creamy, .watery, .eggWhite]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.cervicalMucusQuality),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.cervicalMucusQuality).description,
                    display: "Cervical Mucus Quality"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testMenstrualFlow() throws {
        let values: [HKCategoryValueMenstrualFlow] = [.unspecified, .light, .medium, .heavy, .none]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.menstrualFlow),
                value: value.rawValue,
                metadata: [HKMetadataKeyMenstrualCycleStart: true]
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.menstrualFlow).description, display: "Menstrual Flow"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testOvulationTestResult() throws {
        let values: [HKCategoryValueOvulationTestResult] = [.negative, .indeterminate, .luteinizingHormoneSurge, .estrogenSurge]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.ovulationTestResult),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.ovulationTestResult).description,
                    display: "Ovulation Test Result"
                )
            )
            XCTAssertEqual(
                observation.value, .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testContraceptive() throws {
        let values: [HKCategoryValueContraceptive] = [.unspecified, .implant, .injection, .intrauterineDevice, .intravaginalRing, .oral, .patch]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.contraceptive),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.contraceptive).description,
                    display: "Contraceptive"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testSleepAnalysis() throws {
        let values: [HKCategoryValueSleepAnalysis] = [.inBed, .asleepUnspecified, .awake, .asleepCore, .asleepDeep, .asleepREM]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.sleepAnalysis),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.sleepAnalysis).description,
                    display: "Sleep Analysis"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testAppetiteChanges() throws {
        let values: [HKCategoryValueAppetiteChanges] = [.unspecified, .noChange, .decreased, .increased]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.appetiteChanges),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.appetiteChanges).description,
                    display: "Appetite Changes"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testEnvironmentalAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.environmentalAudioExposureEvent),
            value: HKCategoryValueEnvironmentalAudioExposureEvent.momentaryLimit.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.environmentalAudioExposureEvent).description,
                display: "Environmental Audio Exposure Event"
            )
        )
        XCTAssertEqual(observation.value, .string("momentary limit".asFHIRStringPrimitive()))
    }

    func testHeadphoneAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.headphoneAudioExposureEvent),
            value: HKCategoryValueHeadphoneAudioExposureEvent.sevenDayLimit.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.headphoneAudioExposureEvent).description,
                display: "Headphone Audio Exposure Event"
            )
        )
        XCTAssertEqual(observation.value, .string("seven day limit".asFHIRStringPrimitive()))
    }

    func testLowCardioFitnessEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.lowCardioFitnessEvent),
            value: HKCategoryValueLowCardioFitnessEvent.lowFitness.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.lowCardioFitnessEvent).description,
                display: "Low Cardio Fitness Event"
            )
        )
        XCTAssertEqual(observation.value, .string("low fitness".asFHIRStringPrimitive()))
    }

    func testAppleWalkingSteadinessEvent() throws {
        let values: [HKCategoryValueAppleWalkingSteadinessEvent] = [.initialLow, .initialVeryLow, .repeatLow, .repeatVeryLow]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.appleWalkingSteadinessEvent),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.appleWalkingSteadinessEvent).description,
                    display: "Apple Walking Steadiness Event"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testAppleWalkingSteadinessClassification() throws {
        let okClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.ok.rawValue
        )?.categoryValueDescription
        XCTAssertEqual(okClassification, "ok")

        let lowClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.low.rawValue
        )?.categoryValueDescription
        XCTAssertEqual(lowClassification, "low")

        let veryLowClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.veryLow.rawValue
        )?.categoryValueDescription
        XCTAssertEqual(veryLowClassification, "very low")
    }

    func testPregnancyTestResult() throws {
        let values: [HKCategoryValuePregnancyTestResult] = [.negative, .positive, .indeterminate]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.pregnancyTestResult),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.pregnancyTestResult).description,
                    display: "Pregnancy Test Result"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testProgesteroneTestResult() throws {
        let values: [HKCategoryValueProgesteroneTestResult] = [.indeterminate, .positive, .negative]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.progesteroneTestResult),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.progesteroneTestResult).description,
                    display: "Progesterone Test Result"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testAppleStandHour() throws {
        let values: [HKCategoryValueAppleStandHour] = [.stood, .idle]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.appleStandHour),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.appleStandHour).description,
                    display: "Apple Stand Hour"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testIntermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.intermenstrualBleeding),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.intermenstrualBleeding).description,
                display: "Intermenstrual Bleeding"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierIntermenstrualBleeding".asFHIRStringPrimitive())
        )
    }

    func testInfrequentMenstrualCycles() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.infrequentMenstrualCycles),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.infrequentMenstrualCycles).description,
                display: "Infrequent Menstrual Cycles"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierInfrequentMenstrualCycles".asFHIRStringPrimitive())
        )
    }

    func testIrregularMenstrualCycles() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.irregularMenstrualCycles),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.irregularMenstrualCycles).description,
                display: "Irregular Menstrual Cycles"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierIrregularMenstrualCycles".asFHIRStringPrimitive())
        )
    }

    func testPersistentIntermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.persistentIntermenstrualBleeding),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.persistentIntermenstrualBleeding).description,
                display: "Persistent Intermenstrual Bleeding"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierPersistentIntermenstrualBleeding".asFHIRStringPrimitive())
        )
    }

    func testProlongedMenstrualPeriods() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.prolongedMenstrualPeriods),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.prolongedMenstrualPeriods).description,
                display: "Prolonged Menstrual Periods"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierProlongedMenstrualPeriods".asFHIRStringPrimitive())
        )
    }

    func testLactation() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.lactation),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.lactation).description,
                display: "Lactation"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierLactation".asFHIRStringPrimitive())
        )
    }

    func testHandwashingEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.handwashingEvent),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.handwashingEvent).description,
                display: "Handwashing Event"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierHandwashingEvent".asFHIRStringPrimitive())
        )
    }

    func testToothbrushingEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.toothbrushingEvent),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.toothbrushingEvent).description,
                display: "Toothbrushing Event"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierToothbrushingEvent".asFHIRStringPrimitive())
        )
    }

    func testMindfulSession() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.mindfulSession),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.mindfulSession).description,
                display: "Mindful Session"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierMindfulSession".asFHIRStringPrimitive())
        )
    }

    // SYMPTOM TESTS

    func testSymptoms(type: HKCategoryType, display: String) throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: type,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: type.description,
                    display: display
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testAbdominalCramps() throws {
        try testSymptoms(type: HKCategoryType(.abdominalCramps), display: "Abdominal Cramps")
    }

    func testAcne() throws {
        try testSymptoms(type: HKCategoryType(.acne), display: "Acne")
    }

    func testBladderIncontinence() throws {
        try testSymptoms(type: HKCategoryType(.bladderIncontinence), display: "Bladder Incontinence")
    }

    func testBloating() throws {
        try testSymptoms(type: HKCategoryType(.bloating), display: "Bloating")
    }

    func testBreastPain() throws {
        try testSymptoms(type: HKCategoryType(.breastPain), display: "Breast Pain")
    }

    func testChestTightnessOrPain() throws {
        try testSymptoms(type: HKCategoryType(.chestTightnessOrPain), display: "Chest Tightness Or Pain")
    }

    func testChills() throws {
        try testSymptoms(type: HKCategoryType(.chills), display: "Chills")
    }

    func testConstipation() throws {
        try testSymptoms(type: HKCategoryType(.constipation), display: "Constipation")
    }

    func testCoughing() throws {
        try testSymptoms(type: HKCategoryType(.coughing), display: "Coughing")
    }

    func testDizziness() throws {
        try testSymptoms(type: HKCategoryType(.dizziness), display: "Dizziness")
    }

    func testDrySkin() throws {
        try testSymptoms(type: HKCategoryType(.drySkin), display: "Dry Skin")
    }

    func testFainting() throws {
        try testSymptoms(type: HKCategoryType(.fainting), display: "Fainting")
    }

    func testFever() throws {
        try testSymptoms(type: HKCategoryType(.fever), display: "Fever")
    }

    func testGeneralizedBodyAche() throws {
        try testSymptoms(type: HKCategoryType(.generalizedBodyAche), display: "Generalized Body Ache")
    }

    func testHairLoss() throws {
        try testSymptoms(type: HKCategoryType(.hairLoss), display: "Hair Loss")
    }

    func testHeadache() throws {
        try testSymptoms(type: HKCategoryType(.headache), display: "Headache")
    }

    func testHeartburn() throws {
        try testSymptoms(type: HKCategoryType(.heartburn), display: "Heartburn")
    }

    func testHotFlashes() throws {
        try testSymptoms(type: HKCategoryType(.hotFlashes), display: "Hot Flashes")
    }

    func testLossOfSmell() throws {
        try testSymptoms(type: HKCategoryType(.lossOfSmell), display: "Loss Of Smell")
    }

    func testLossOfTaste() throws {
        try testSymptoms(type: HKCategoryType(.lossOfTaste), display: "Loss Of Taste")
    }

    func testLowerBackPain() throws {
        try testSymptoms(type: HKCategoryType(.lowerBackPain), display: "Lower Back Pain")
    }

    func testMemoryLapse() throws {
        try testSymptoms(type: HKCategoryType(.memoryLapse), display: "Memory Lapse")
    }

    func testMoodChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.moodChanges),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.moodChanges).description,
                    display: "Mood Changes"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testSleepChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.sleepChanges),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.sleepChanges).description,
                    display: "Sleep Changes"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testNausea() throws {
        try testSymptoms(type: HKCategoryType(.nausea), display: "Nausea")
    }

    func testNightSweats() throws {
        try testSymptoms(type: HKCategoryType(.nightSweats), display: "Night Sweats")
    }

    func testPelvicPain() throws {
        try testSymptoms(type: HKCategoryType(.pelvicPain), display: "Pelvic Pain")
    }

    func testRapidPoundingOrFlutteringHeartbeat() throws {
        try testSymptoms(type: HKCategoryType(.rapidPoundingOrFlutteringHeartbeat), display: "Rapid Pounding Or Fluttering Heartbeat")
    }

    func testRunnyNose() throws {
        try testSymptoms(type: HKCategoryType(.runnyNose), display: "Runny Nose")
    }

    func testShortnessOfBreath() throws {
        try testSymptoms(type: HKCategoryType(.shortnessOfBreath), display: "Shortness Of Breath")
    }

    func testSinusCongestion() throws {
        try testSymptoms(type: HKCategoryType(.sinusCongestion), display: "Sinus Congestion")
    }

    func testSkippedHeartbeat() throws {
        try testSymptoms(type: HKCategoryType(.skippedHeartbeat), display: "Skipped Heartbeat")
    }

    func testSoreThroat() throws {
        try testSymptoms(type: HKCategoryType(.soreThroat), display: "Sore Throat")
    }

    func testVaginalDryness() throws {
        try testSymptoms(type: HKCategoryType(.vaginalDryness), display: "Vaginal Dryness")
    }

    func testVomiting() throws {
        try testSymptoms(type: HKCategoryType(.vomiting), display: "Vomiting")
    }

    func testWheezing() throws {
        try testSymptoms(type: HKCategoryType(.wheezing), display: "Wheezing")
    }
}
