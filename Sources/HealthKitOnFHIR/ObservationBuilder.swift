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

class ObservationBuilder {
    private let observation: Observation

    init() {
        self.observation = Observation(
            code: CodeableConcept(),
            status: FHIRPrimitive<ObservationStatus>(.final)
        )
    }

    func addIdentifiers(_ identifiers: [Identifier]) -> ObservationBuilder {
        self.observation.identifier = (self.observation.identifier ?? []) + identifiers
        return self
    }

    func addCategories(_ concepts: [CodeableConcept]) -> ObservationBuilder {
        self.observation.category = (self.observation.category ?? []) + concepts
        return self
    }

    func addCodings(_ codings: [Coding]) -> ObservationBuilder {
        self.observation.code.coding = (self.observation.code.coding ?? []) + codings
        return self
    }

    func setEffective(startDate: Date, endDate: Date) -> ObservationBuilder {
        if startDate == endDate {
            self.observation.effective = .dateTime(FHIRPrimitive(try? DateTime(date: startDate)))
        } else {
            self.observation.effective = .period(
                Period(
                    end: FHIRPrimitive(try? DateTime(date: startDate)),
                    start: FHIRPrimitive(try? DateTime(date: endDate))
                )
            )
        }
        return self
    }

    func setIssued(on date: Date) -> ObservationBuilder {
        self.observation.issued = FHIRPrimitive(try? Instant(date: date))
        return self
    }

    func setValue(_ quantity: Quantity) -> ObservationBuilder {
        self.observation.value = .quantity(quantity)
        return self
    }

    func build() -> Observation { self.observation }
}
