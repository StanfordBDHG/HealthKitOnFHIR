//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct HKSampleMapping: Decodable {
    enum CodingKeys: String, CodingKey {
        case quantitySampleMapping = "HKQuantitySample"
        case correlationMapping = "HKCorrelation"
    }

    public static let `default`: HKSampleMapping = {
        Bundle.module.decode(HKSampleMapping.self, from: "HKSampleMapping.json")
    }()

    public let quantitySampleMapping: [String: HKQuantitySampleMapping]
    public let correlationMapping: [String: HKCorrelationMapping]

    public init(
        hkQuantitySampleMapping: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default,
        hkCorrelationMapping: [String: HKCorrelationMapping] = HKCorrelationMapping.default
    ) {
        self.correlationMapping = hkCorrelationMapping
        self.quantitySampleMapping = hkQuantitySampleMapping
    }
}
