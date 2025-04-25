//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
@testable import HealthKitOnFHIR
import Testing


@MainActor // to work around https://github.com/apple/FHIRModels/issues/36
struct HKElectrocardiogramTests {
    @Test
    func electrocardiogramCategoryTests() throws {
        #expect(try HKElectrocardiogram.SymptomsStatus.notSet.fhirCategoryValue == "notSet")
        #expect(try HKElectrocardiogram.SymptomsStatus.none.fhirCategoryValue == "none")
        #expect(try HKElectrocardiogram.SymptomsStatus.present.fhirCategoryValue == "present")
        
        #expect(try HKElectrocardiogram.Classification.notSet.fhirCategoryValue == "notSet")
        #expect(try HKElectrocardiogram.Classification.sinusRhythm.fhirCategoryValue == "sinusRhythm")
        #expect(try HKElectrocardiogram.Classification.atrialFibrillation.fhirCategoryValue == "atrialFibrillation")
        #expect(try HKElectrocardiogram.Classification.inconclusiveLowHeartRate.fhirCategoryValue == "inconclusiveLowHeartRate")
        #expect(try HKElectrocardiogram.Classification.inconclusiveHighHeartRate.fhirCategoryValue == "inconclusiveHighHeartRate")
        #expect(try HKElectrocardiogram.Classification.inconclusivePoorReading.fhirCategoryValue == "inconclusivePoorReading")
        #expect(try HKElectrocardiogram.Classification.inconclusiveOther.fhirCategoryValue == "inconclusiveOther")
        #expect(try HKElectrocardiogram.Classification.unrecognized.fhirCategoryValue == "unrecognized")
    }
}
