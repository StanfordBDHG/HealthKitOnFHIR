//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
@testable import HealthKitOnFHIR
import ModelsR4
import XCTest


class TimeZoneTests: XCTestCase {
    func createDateInTimeZone(_ components: DateComponents, timeZone: TimeZone) throws -> Date {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        return try XCTUnwrap(calendar.date(from: components))
    }
    
    func getTimeZoneDate(_ components: DateComponents, timeZoneName: String) throws -> Date {
        let timeZone = try XCTUnwrap(TimeZone(identifier: timeZoneName))
        return try createDateInTimeZone(components, timeZone: timeZone)
    }
    
    func createDatesFor(timeZone: String) throws -> (start: Date, end: Date) {
        let startComponents = DateComponents(year: 2024, month: 3, day: 15, hour: 9, minute: 30, second: 0)
        let endComponents = DateComponents(year: 2024, month: 3, day: 15, hour: 10, minute: 45, second: 0)
        
        return (
            try getTimeZoneDate(startComponents, timeZoneName: timeZone),
            try getTimeZoneDate(endComponents, timeZoneName: timeZone)
        )
    }
    
    func createObservationFrom(
        type quantityType: HKQuantityType,
        quantity: HKQuantity,
        start: Date,
        end: Date,
        metadata: [String: Any] = [:]
    ) throws -> Observation {
        let quantitySample = HKQuantitySample(
            type: quantityType,
            quantity: quantity,
            start: start,
            end: end,
            metadata: metadata
        )
        return try XCTUnwrap(quantitySample.resource.get(if: Observation.self))
    }
    
    /// Tests specifying the pacific time zone (-08:00) in metadata
    func testPSTTimeZone() throws {
        let timeZone = "America/Los_Angeles"
        let (startDate, endDate) = try createDatesFor(timeZone: timeZone)
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: endDate,
            metadata: [HKMetadataKeyTimeZone: timeZone]
        )
        
        guard case let .period(period) = observation.effective else {
            XCTFail("Expected period effective type")
            return
        }
        
        let startTimestamp = try XCTUnwrap(period.start?.value?.description)
        let endTimestamp = try XCTUnwrap(period.end?.value?.description)
        
        XCTAssertEqual(
            startTimestamp,
            "2024-03-15T09:30:00-08:00",
            "Start timestamp should match expected format with timezone"
        )
        XCTAssertEqual(
            endTimestamp,
            "2024-03-15T10:45:00-08:00",
            "End timestamp should match expected format with timezone"
        )
    }
    
    /// Tests specifying eastern standard time (-5:00) in metadata
    func testESTTimeZone() throws {
        let timeZone = "America/New_York"
        let (startDate, endDate) = try createDatesFor(timeZone: timeZone)
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: endDate,
            metadata: [HKMetadataKeyTimeZone: timeZone]
        )
        
        guard case let .period(period) = observation.effective else {
            XCTFail("Expected period effective type")
            return
        }
        
        let startTimestamp = try XCTUnwrap(period.start?.value?.description)
        let endTimestamp = try XCTUnwrap(period.end?.value?.description)

        XCTAssertEqual(
            startTimestamp,
            "2024-03-15T09:30:00-05:00",
            "Start timestamp should match expected format with timezone"
        )
        XCTAssertEqual(
            endTimestamp,
            "2024-03-15T10:45:00-05:00",
            "End timestamp should match expected format with timezone"
        )
    }
    
    /// Tests specifying indian standard time (+5:30) in metadata
    func testISTTimeZone() throws {
        let timeZone = "Asia/Calcutta"
        let (startDate, endDate) = try createDatesFor(timeZone: timeZone)
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: endDate,
            metadata: [HKMetadataKeyTimeZone: timeZone]
        )
        
        guard case let .period(period) = observation.effective else {
            XCTFail("Expected period effective type")
            return
        }
        
        let startTimestamp = try XCTUnwrap(period.start?.value?.description)
        let endTimestamp = try XCTUnwrap(period.end?.value?.description)
        
        XCTAssertEqual(
            startTimestamp,
            "2024-03-15T09:30:00+05:30",
            "Start timestamp should match expected format with timezone"
        )
        XCTAssertEqual(
            endTimestamp,
            "2024-03-15T10:45:00+05:30",
            "End timestamp should match expected format with timezone"
        )
    }
    
    /// Tests that the current time zone is added if a time zone is not specified in metadata
    func testDefaultTimeZone() throws {
        let startDate: Date = try {
            let dateComponents = DateComponents(year: 2024, month: 3, day: 15, hour: 9, minute: 30, second: 0)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }()
        
        let endDate: Date = try {
            let dateComponents = DateComponents(year: 2024, month: 3, day: 15, hour: 10, minute: 45, second: 0)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }()
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: endDate
        )
        
        guard case let .period(period) = observation.effective else {
            XCTFail("Expected period effective type")
            return
        }
        
        let startTimestamp = try XCTUnwrap(period.start?.value?.description)
        let endTimestamp = try XCTUnwrap(period.end?.value?.description)
        
        let currentTimeZone = TimeZone.current
        let expectedOffset = currentTimeZone.secondsFromGMT() / 3600
        let sign = expectedOffset >= 0 ? "+" : "-"
        let expectedOffsetString = String(format: "%@%02d:00", sign, abs(expectedOffset))
        
        XCTAssertTrue(
            startTimestamp.contains(expectedOffsetString),
            "Start time should contain current timezone offset \(expectedOffsetString)"
        )
        XCTAssertTrue(
            endTimestamp.contains(expectedOffsetString),
            "End time should contain current timezone offset \(expectedOffsetString)"
        )
    }
}
