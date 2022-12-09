//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public struct MappedCode: Codable {
    /// <#Description#>
    public let code: String
    /// <#Description#>
    public let display: String
    /// <#Description#>
    public let system: String
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - display: <#display description#>
    ///   - system: <#system description#>
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
