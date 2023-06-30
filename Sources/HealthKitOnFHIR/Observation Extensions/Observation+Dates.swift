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
    func setEffective(startDate: Date, endDate: Date) {
        if startDate == endDate {
            effective = .dateTime(FHIRPrimitive(try? DateTime(date: startDate)))
        } else {
            effective = .period(
                Period(
                    start: FHIRPrimitive(try? DateTime(date: startDate)),
                    end: FHIRPrimitive(try? DateTime(date: endDate))
                )
            )
        }
    }
    
    func setIssued(on date: Date) {
        issued = FHIRPrimitive(try? Instant(date: date))
    }
}
