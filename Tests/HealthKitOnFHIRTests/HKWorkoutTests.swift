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

    func testSingleWorkout() throws {
        // This initializer is deprecated as of iOS 17 in favor of using `HKWorkoutBuilder`, but there
        // is currently no mechanism to use `HKWorkoutBuilder` inside unit tests without an authenticated
        // `HKHealthStore`.
        let workoutSample = HKWorkout(
            activityType: .americanFootball,
            start: try startDate,
            end: try endDate
        )

        let observation = try XCTUnwrap(workoutSample.resource.get(if: Observation.self))

        XCTAssertEqual(observation.value, .codeableConcept(
            CodeableConcept(
                coding: [
                    Coding(
                        code: "americanFootball".asFHIRStringPrimitive(),
                        system: "http://developer.apple.com/documentation/healthkit".asFHIRURIPrimitive()
                    )
                ]
            )
        ))
    }
}
