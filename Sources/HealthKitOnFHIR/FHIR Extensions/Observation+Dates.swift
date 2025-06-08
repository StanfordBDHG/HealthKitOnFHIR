//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import ModelsR4


extension Observation {
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    nonisolated(unsafe) static let absoluteTimeRangeStartExtensionUrl = "https://spezi.stanford.edu/fhir/defs/absoluteTimeRangeStart".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
    
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    nonisolated(unsafe) static let absoluteTimeRangeEndExtensionUrl = "https://spezi.stanford.edu/fhir/defs/absoluteTimeRangeEnd".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
    
    
    /// Sets the `Observation`'s effective date.
    public func setEffective(startDate: Date, endDate: Date, timeZone: TimeZone) throws {
        if startDate == endDate {
            effective = .dateTime(FHIRPrimitive(try DateTime(date: startDate, timeZone: timeZone)))
        } else {
            effective = .period(Period(
                end: FHIRPrimitive(try DateTime(date: endDate, timeZone: timeZone)),
                start: FHIRPrimitive(try DateTime(date: startDate, timeZone: timeZone))
            ))
        }
        let timeRangeExtensions = [
            Extension(
                url: Self.absoluteTimeRangeStartExtensionUrl,
                value: .decimal(startDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
            ),
            Extension(
                url: Self.absoluteTimeRangeEndExtensionUrl,
                value: .decimal(endDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
            )
        ]
        appendExtensions(timeRangeExtensions, replaceExistingWithSameUrl: true)
    }
    
    /// Sets the `Observation`'s issued date.
    public func setIssued(on date: Date) throws {
        issued = FHIRPrimitive(try Instant(date: date))
    }
}
