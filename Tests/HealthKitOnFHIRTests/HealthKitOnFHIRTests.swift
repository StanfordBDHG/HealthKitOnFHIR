//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest


final class HealthKitOnFHIRTests: XCTestCase {
    func testHealthKitOnFHIR() throws {
        let healthKitOnFHIR = HealthKitOnFHIR()
        XCTAssertEqual(healthKitOnFHIR.healthKitOnFHIR, "HealthKitOnFHIR")
    }
}
