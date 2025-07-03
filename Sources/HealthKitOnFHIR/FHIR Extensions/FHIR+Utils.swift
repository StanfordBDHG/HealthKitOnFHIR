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


extension Decimal {
    /// Creates a `FHIRPrimitive<FHIRDecimal>` with the value of the `Decimal`.
    public func asFHIRPrimitive() -> FHIRPrimitive<FHIRDecimal> {
        FHIRPrimitive(FHIRDecimal(self))
    }
}


extension FHIRPrimitive where PrimitiveType == FHIRURI {
    /// Creates a new `FHIRPrimitive<FHIRURI>`, by appending the specified component.
    public func appending(component: some StringProtocol) -> Self {
        guard let value else {
            return self
        }
        return Self(FHIRURI(value.url.appending(component: component)))
    }
    
    /// Creates a new `FHIRPrimitive<FHIRURI>`, by appending the specified components.
    public func appending(components: [some StringProtocol]) -> Self {
        guard let value else {
            return self
        }
        var url = value.url
        for component in components {
            url = url.appending(component: component)
        }
        return Self(FHIRURI(url))
    }
}
