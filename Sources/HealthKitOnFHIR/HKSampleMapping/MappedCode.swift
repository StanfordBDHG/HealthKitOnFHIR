//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct MappedCode: Codable {
    public let code: String
    public let display: String
    public let system: String


    public init(
        code: String,
        display: String,
        system: String
    ) {
        self.code = code
        self.display = display
        self.system = system
    }
}
