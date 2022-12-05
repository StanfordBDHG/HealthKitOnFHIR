//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public struct HKSampleMapping: Decodable {
    private enum CodingKeys: String, CodingKey {
        case quantitySampleMapping = "HKQuantitySample"
        case correlationMapping = "HKCorrelation"
    }

    public static let `default`: HKSampleMapping = {
        Bundle.module.decode(HKSampleMapping.self, from: "HKSampleMapping.json")
    }()

    public let quantitySampleMapping: [String: HKQuantitySampleMapping]
    public let correlationMapping: [String: HKCorrelationMapping]

    public init(from decoder: Decoder) throws {
        let mappings = try decoder.container(keyedBy: CodingKeys.self)
        let quantitySampleMapping = try mappings.decode(
            Dictionary<String, HKQuantitySampleMapping>.self,
            forKey: .quantitySampleMapping
        )
        let correlationMapping = try mappings.decode(
            Dictionary<String, HKCorrelationMapping>.self,
            forKey: .correlationMapping
        )
        self.init(
            quantitySampleMapping: quantitySampleMapping,
            correlationMapping: correlationMapping
        )
    }

    public init(
        quantitySampleMapping: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default,
        correlationMapping: [String: HKCorrelationMapping] = HKCorrelationMapping.default
    ) {
        for mapping in quantitySampleMapping {
            guard HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: mapping.key)) != nil else {
                fatalError("HKQuantityType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
            }
        }
        self.quantitySampleMapping = quantitySampleMapping

        for mapping in correlationMapping {
            guard HKCorrelationType.correlationType(forIdentifier: HKCorrelationTypeIdentifier(rawValue: mapping.key)) != nil else {
                fatalError("HKCorrelationType for the String value \(mapping.key) does not exist. Please inspect your configuration.")
            }
        }
        self.correlationMapping = correlationMapping
    }
}
