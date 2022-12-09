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
        case unit
        case system
        case code
    }

    public let hkunit: String
    public let unit: String
    public let system: URL?
    public let code: String?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let hkunit = try values.decode(String.self, forKey: .hkunit)
        let unit = try values.decode(String.self, forKey: .unit)
        let system = try values.decodeIfPresent(URL.self, forKey: .system)
        let code = try values.decodeIfPresent(String.self, forKey: .code)

        self.init(
            hkunit: hkunit,
            unit: unit,
            system: system,
            code: code
        )
    }

    public init(
        hkunit: String,
        unit: String,
        system: URL?,
        code: String?
    ) {
        // Unfortunately this method throws an Objective-C exception when an error occurs, we can not catch this here.
        _ = HKUnit(from: hkunit)

        self.hkunit = hkunit
        self.unit = unit
        self.system = system
        self.code = code
    }
}
