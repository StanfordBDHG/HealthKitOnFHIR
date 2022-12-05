//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct MappedUnit: Codable {
    public let hkunit: String
    public let unitAlias: String?


    public init(
        hkunit: String,
        unitAlias: String?
    ) {
        self.hkunit = hkunit
        self.unitAlias = unitAlias
    }
}
