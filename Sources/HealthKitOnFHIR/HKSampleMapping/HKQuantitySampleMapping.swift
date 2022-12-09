//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public struct HKQuantitySampleMapping: Codable {
    /// <#Description#>
    public static let `default` = HKSampleMapping.default.quantitySampleMapping
    
    
    /// <#Description#>
    public let codes: [MappedCode]
    /// <#Description#>
    public let unit: MappedUnit

    
    /// <#Description#>
    /// - Parameters:
    ///   - codes: <#codes description#>
    ///   - unit: <#unit description#>
    public init(
        codes: [MappedCode],
        unit: MappedUnit
    ) {
        self.codes = codes
        self.unit = unit
    }
}
