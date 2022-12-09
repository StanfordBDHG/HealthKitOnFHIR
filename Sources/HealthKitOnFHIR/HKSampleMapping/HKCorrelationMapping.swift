//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public struct HKCorrelationMapping: Codable {
    /// <#Description#>
    public static let `default` = HKSampleMapping.default.correlationMapping
    
    
    /// <#Description#>
    public let codes: [MappedCode]
    /// <#Description#>
    public let categories: [MappedCode]
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - codes: <#codes description#>
    ///   - categories: <#categories description#>
    public init(
        codes: [MappedCode],
        categories: [MappedCode]
    ) {
        self.codes = codes
        self.categories = categories
    }
}
