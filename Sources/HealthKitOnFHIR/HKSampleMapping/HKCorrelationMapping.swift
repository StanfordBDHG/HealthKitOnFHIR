//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct HKCorrelationMapping: Codable {
    public static let `default`: [String: HKCorrelationMapping] = {
        var mappings = HKSampleMapping.default.correlationMapping
        for mapping in mappings {
            guard let correlationType = HKCorrelationType.correlationType(forIdentifier: HKCorrelationTypeIdentifier(rawValue: mapping.key)) else {
                fatalError("HKCorrelationType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
            }
        }
        return mappings
    }()

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
