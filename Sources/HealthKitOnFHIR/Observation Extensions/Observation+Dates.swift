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
    }
    
    /// Sets the `Observation`'s issued date.
    public func setIssued(on date: Date) throws {
        issued = FHIRPrimitive(try Instant(date: date))
    }
}
