//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct HKCorrelationMapping: Codable {
    public static let `default` = HKSampleMapping.default.correlationMapping
    public let codes: [MappedCode]
    public let categories: [MappedCode]

    public init(
        codes: [MappedCode],
        categories: [MappedCode]
    ) {
        self.codes = codes
        self.categories = categories
    }
}
