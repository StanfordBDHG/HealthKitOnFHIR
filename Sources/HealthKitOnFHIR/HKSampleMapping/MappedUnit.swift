//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct MappedUnit: Codable {
    private enum CodingKeys: String, CodingKey {
        case hkunit
        case unitAlias
    }

    public let hkunit: String
    public let unitAlias: String?


    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let hkunit = try values.decode(String.self, forKey: .hkunit)
        let unitAlias = try values.decodeIfPresent(String.self, forKey: .unitAlias)

        self.init(hkunit: hkunit, unitAlias: unitAlias)
    }

    public init(
        hkunit: String,
        unitAlias: String?
    ) {
        // Unfortunately this method throws an Objective-C exception when an error occurs, we can not catch this here.
        _ = HKUnit(from: hkunit)

        self.hkunit = hkunit
        self.unitAlias = unitAlias
    }
}
