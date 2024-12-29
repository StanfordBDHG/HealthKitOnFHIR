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


class TimeZoneTests: XCTestCase { // swiftlint:disable:this type_body_length
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
        let startComponents = DateComponents(year: 2024, month: 12, day: 1, hour: 9, minute: 00, second: 0)
        let endComponents = DateComponents(year: 2024, month: 12, day: 1, hour: 10, minute: 45, second: 0)
        
        return (
            try getTimeZoneDate(startComponents, timeZoneName: timeZone),
            try getTimeZoneDate(endComponents, timeZoneName: timeZone)
        )
    }
    
    func createDSTDatesFor(timeZone: String) throws -> (start: Date, end: Date) {
        let startComponents = DateComponents(year: 2024, month: 4, day: 1, hour: 9, minute: 00, second: 0)
        let endComponents = DateComponents(year: 2024, month: 4, day: 1, hour: 10, minute: 45, second: 0)
        
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
    
    
    /// Tests specifying the pacific standard time zone (-08:00) in metadata with a different start and end date (results in a FHIR `Period`)
    func testPSTTimeZonePeriod() throws {
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
            "2024-12-01T09:00:00-08:00",
            "Start timestamp should match expected format with timezone"
        )
        XCTAssertEqual(
            endTimestamp,
            "2024-12-01T10:45:00-08:00",
            "End timestamp should match expected format with timezone"
        )
    }

    /// Tests specifying the pacific standard time zone (-8:00) in metadata with the same start and end date (results in a FHIR `DateTime`)
    func testPSTTimeZoneDateTime() throws {
        let timeZone = "America/Los_Angeles"
        let (startDate, _) = try createDatesFor(timeZone: timeZone)
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: startDate,
            metadata: [HKMetadataKeyTimeZone: timeZone]
        )
        
        guard case let .dateTime(dateTime) = observation.effective else {
            XCTFail("Expected dateTime effective type")
            return
        }
        
        let timestamp = try XCTUnwrap(dateTime.value?.description)
        
        XCTAssertEqual(
            timestamp,
            "2024-12-01T09:00:00-08:00",
            "Timestamp should match expected format with timezone"
        )
    }
    
    /// Tests specifying the pacific daylight time zone (-7:00) in metadata with a different start and end date (results in a FHIR `Period`)
    func testPDTTimeZonePeriod() throws {
        let timeZone = "America/Los_Angeles"
        let (startDate, endDate) = try createDSTDatesFor(timeZone: timeZone)
        
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
            "2024-04-01T09:00:00-07:00",
            "Start timestamp should match expected format with timezone"
        )
        XCTAssertEqual(
            endTimestamp,
            "2024-04-01T10:45:00-07:00",
            "End timestamp should match expected format with timezone"
        )
    }
    
    /// Tests specifying the pacific daylight time zone (-7:00) in metadata with the same start and end date  (results in a FHIR `DateTime`)
    func testPDTTimeZoneDateTime() throws {
        let timeZone = "America/Los_Angeles"
        let (startDate, _) = try createDSTDatesFor(timeZone: timeZone)
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: startDate,
            metadata: [HKMetadataKeyTimeZone: timeZone]
        )
        
        guard case let .dateTime(dateTime) = observation.effective else {
            XCTFail("Expected dateTime effective type")
            return
        }
        
        let timestamp = try XCTUnwrap(dateTime.value?.description)
        
        XCTAssertEqual(
            timestamp,
            "2024-04-01T09:00:00-07:00",
            "Timestamp should match expected format with timezone during DST"
        )
    }
    
    /// Tests specifying eastern standard time (-5:00) in metadata with an HKSample that defines a period with a different start and end date (results in a FHIR `Period`)
    func testESTTimeZonePeriod() throws {
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
            "2024-12-01T09:00:00-05:00",
            "Start timestamp should match expected format with timezone"
        )
        XCTAssertEqual(
            endTimestamp,
            "2024-12-01T10:45:00-05:00",
            "End timestamp should match expected format with timezone"
        )
    }
    
    /// Tests specifying eastern standard time (-5:00) in metadata with the same start and end date (results in a FHIR `DateTime`)
    func testESTTimeZoneDateTime() throws {
        let timeZone = "America/New_York"
        let (startDate, _) = try createDatesFor(timeZone: timeZone)
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: startDate,
            metadata: [HKMetadataKeyTimeZone: timeZone]
        )
        
        guard case let .dateTime(dateTime) = observation.effective else {
            XCTFail("Expected dateTime effective type")
            return
        }
        
        let timestamp = try XCTUnwrap(dateTime.value?.description)
        
        XCTAssertEqual(
            timestamp,
            "2024-12-01T09:00:00-05:00",
            "Timestamp should match expected format with timezone"
        )
    }
    
    /// Tests specifying indian standard time (+5:30) in metadata with a different start and end date (results in a FHIR `Period`)
    func testISTTimeZonePeriod() throws {
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
            "2024-12-01T09:00:00+05:30",
            "Start timestamp should match expected format with timezone"
        )
        XCTAssertEqual(
            endTimestamp,
            "2024-12-01T10:45:00+05:30",
            "End timestamp should match expected format with timezone"
        )
    }
    
    /// Tests specifying indian standard time (+5:30) in metadata with the same start and end date  (results in a FHIR `DateTime`)
    func testISTTimeZoneDateTime() throws {
        let timeZone = "Asia/Calcutta"
        let (startDate, _) = try createDatesFor(timeZone: timeZone)
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: startDate,
            metadata: [HKMetadataKeyTimeZone: timeZone]
        )
        
        guard case let .dateTime(dateTime) = observation.effective else {
            XCTFail("Expected dateTime effective type")
            return
        }
        
        let timestamp = try XCTUnwrap(dateTime.value?.description)
        
        XCTAssertEqual(
            timestamp,
            "2024-12-01T09:00:00+05:30",
            "Timestamp should match expected format with timezone"
        )
    }
    
    /// Tests that the current time zone is added if a time zone is not specified in metadata with a different start and end date (results in a FHIR `Period`)
    func testDefaultTimeZonePeriod() throws {
        let startDate: Date = try {
            let dateComponents = DateComponents(year: 2024, month: 12, day: 1, hour: 9, minute: 00, second: 0)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }()
        
        let endDate: Date = try {
            let dateComponents = DateComponents(year: 2024, month: 12, day: 1, hour: 10, minute: 45, second: 0)
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
        let totalMinutes = currentTimeZone.secondsFromGMT() / 60
        let hours = abs(totalMinutes / 60)
        let minutes = abs(totalMinutes % 60)
        let sign = totalMinutes >= 0 ? "+" : "-"
        let expectedOffsetString = String(format: "%@%02d:%02d", sign, hours, minutes)
        
        XCTAssertTrue(
            startTimestamp.contains(expectedOffsetString),
            "Start time should contain current timezone offset \(expectedOffsetString)"
        )
        XCTAssertTrue(
            endTimestamp.contains(expectedOffsetString),
            "End time should contain current timezone offset \(expectedOffsetString)"
        )
    }
    
    /// Tests that the current time zone is added if a time zone is not specified in metadata with the same start and end date  (results in a FHIR `DateTime`)
    func testDefaultTimeZoneDateTime() throws {
        let startDate: Date = try {
            let dateComponents = DateComponents(year: 2024, month: 12, day: 1, hour: 9, minute: 00, second: 0)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }()
        
        let endDate = startDate
        
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: startDate,
            end: endDate
        )
        
        guard case let .dateTime(dateTime) = observation.effective else {
            XCTFail("Expected dateTime effective type")
            return
        }
        
        let timestamp = try XCTUnwrap(dateTime.value?.description)
        
        let currentTimeZone = TimeZone.current
        let totalMinutes = currentTimeZone.secondsFromGMT() / 60
        let hours = abs(totalMinutes / 60)
        let minutes = abs(totalMinutes % 60)
        let sign = totalMinutes >= 0 ? "+" : "-"
        let expectedOffsetString = String(format: "%@%02d:%02d", sign, hours, minutes)
        
        XCTAssertTrue(
            timestamp.contains(expectedOffsetString),
            "Time should contain current timezone offset \(expectedOffsetString)"
        )
    }
}
