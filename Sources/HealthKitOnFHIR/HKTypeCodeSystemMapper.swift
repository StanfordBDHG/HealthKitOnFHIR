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

extension HKSampleType {
    struct HKTypeCodeMapping: Codable {
        let hktype: String
        let codes: [MappedCode]

        static let allMappings: [HKTypeCodeMapping] = Bundle.module.decode(file: "mapping.json")
    }

    struct MappedCode: Codable {
        let code, display: String
        let system: String
    }

    func convertToCodes() -> [Coding] {
        guard let mapping = HKTypeCodeMapping.allMappings.first(where: { $0.hktype == self.identifier }) else {
            return []
        }
        let mappedCodes = mapping.codes

        var allCodes = [Coding]()
        for mappedCode in mappedCodes {
            guard let mappedSystem = URL(string: mappedCode.system) else {
                continue
            }

            allCodes.append(
                Coding(
                    code: mappedCode.code.asFHIRStringPrimitive(),
                    display: mappedCode.display.asFHIRStringPrimitive(),
                    system: FHIRPrimitive(FHIRURI(mappedSystem))
                )
            )
        }
        return allCodes
    }
}

extension Foundation.Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the module.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the module.")
        }

        let decoder = JSONDecoder()
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the module.")
        }

        return loadedData
    }
}
