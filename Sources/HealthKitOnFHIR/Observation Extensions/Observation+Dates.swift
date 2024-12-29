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
    func setEffective(startDate: Date, endDate: Date, timeZone: TimeZone) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if startDate == endDate {
            effective = .dateTime(
                FHIRPrimitive(
                    try? DateTime(dateFormatter.string(from: startDate))
                )
            )
        } else {
            effective = .period(
                Period(
                    end: FHIRPrimitive(try? DateTime(dateFormatter.string(from: endDate))),
                    start: FHIRPrimitive(try? DateTime(dateFormatter.string(from: startDate)))
                )
            )
        }
    }
    
    func setIssued(on date: Date) {
        issued = FHIRPrimitive(try? Instant(date: date))
    }
}
