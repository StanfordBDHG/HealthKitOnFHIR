//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


extension DateTime {
    /// Constructs a new `DateTime` from an `Instant`
    public init(instant: Instant) throws {
        self.init(
            date: FHIRDate(instantDate: instant.date),
            time: instant.time,
            timezone: instant.timeZone
        )
    }
}


extension FHIRDate {
    /// Constructs a new `FHIRDate` from an `InstantDate`
    init(instantDate: InstantDate) {
        self.init(
            year: instantDate.year,
            month: instantDate.month,
            day: instantDate.day
        )
    }
}
