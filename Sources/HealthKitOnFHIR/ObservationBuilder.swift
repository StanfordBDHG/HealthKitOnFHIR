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

    func addIdentifier(_ identifiers: Identifier...) -> ObservationBuilder {
        for identifier in identifiers {
            if var existingIdentifiers = self.observation.identifier {
                existingIdentifiers.append(identifier)
            } else {
                self.observation.identifier = [identifier]
            }
        }
        return self
    }

    func addCategory(_ concepts: CodeableConcept...) -> ObservationBuilder {
        for concept in concepts {
            if var categories = self.observation.category {
                categories.append(concept)
            } else {
                self.observation.category = [concept]
            }
        }
        return self
    }

    func addCoding(_ codings: Coding...) -> ObservationBuilder {
        for coding in codings {
            if var codings = self.observation.code.coding {
                codings.append(coding)
            } else {
                self.observation.code.coding = [coding]
            }
        }
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
