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
import XCTest


class HKWorkoutTests: XCTestCase {
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

    let supportedWorkoutActivityTypes: [HKWorkoutActivityType] = [
        .americanFootball,
        .archery,
        .australianFootball,
        .badminton,
        .barre,
        .baseball,
        .basketball,
        .bowling,
        .boxing,
        .cardioDance,
        .climbing,
        .cooldown,
        .coreTraining,
        .cricket,
        .crossCountrySkiing,
        .crossTraining,
        .curling,
        .cycling,
        .dance,
        .danceInspiredTraining,
        .discSports,
        .downhillSkiing,
        .elliptical,
        .equestrianSports,
        .fencing,
        .fishing,
        .fitnessGaming,
        .flexibility,
        .functionalStrengthTraining,
        .golf,
        .gymnastics,
        .handCycling,
        .handball,
        .highIntensityIntervalTraining,
        .hiking,
        .hockey,
        .hunting,
        .jumpRope,
        .kickboxing,
        .lacrosse,
        .martialArts,
        .mindAndBody,
        .mixedCardio,
        .mixedMetabolicCardioTraining,
        .other,
        .paddleSports,
        .pickleball,
        .pilates,
        .play,
        .preparationAndRecovery,
        .racquetball,
        .rowing,
        .rugby,
        .running,
        .sailing,
        .skatingSports,
        .snowboarding,
        .snowSports,
        .soccer,
        .socialDance,
        .softball,
        .squash,
        .stairs,
        .stairClimbing,
        .stepTraining,
        .surfingSports,
        .swimBikeRun,
        .swimming,
        .tableTennis,
        .taiChi,
        .tennis,
        .trackAndField,
        .traditionalStrengthTraining,
        .transition,
        .volleyball,
        .walking,
        .waterFitness,
        .waterPolo,
        .waterSports,
        .wheelchairRunPace,
        .wheelchairWalkPace,
        .wrestling,
        .yoga
    ]

    func createCodeableConcept(
        code: String,
        system: String
    ) -> CodeableConcept {
        CodeableConcept(
            coding: [
                Coding(
                    code: code.asFHIRStringPrimitive(),
                    system: system.asFHIRURIPrimitive()
                )
            ]
        )
    }

    func testHKWorkoutToObservation() throws {
        // The HKWorkout initializers are deprecated as of iOS 17 in favor of using `HKWorkoutBuilder`, but there
        // is currently no mechanism to use `HKWorkoutBuilder` inside unit tests without an authenticated
        // `HKHealthStore`, so we use this approach.
        for activityType in supportedWorkoutActivityTypes {
            let workoutSample = HKWorkout(
                activityType: activityType,
                start: try startDate,
                end: try endDate
            )

            let observation = try XCTUnwrap(workoutSample.resource.get(if: Observation.self))
            let expectedValue = createCodeableConcept(
                code: try activityType.workoutTypeDescription,
                system: "http://developer.apple.com/documentation/healthkit"
            )
            XCTAssertEqual(observation.value, .codeableConcept(expectedValue))
        }
    }
}
