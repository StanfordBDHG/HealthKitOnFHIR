//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable file_types_order

import SwiftUI
import Spezi
import SpeziHealthKit


@main
struct UITestsApp: App {
    @UIApplicationDelegateAdaptor private var delegate: TestAppDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .spezi(delegate)
        }
    }
}


final class TestAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: TestAppStandard()) {
            HealthKit()
        }
    }
}


actor TestAppStandard: Standard, HealthKitConstraint {
    func handleNewSamples<Sample>(
        _ addedSamples: some Collection<Sample> & Sendable,
        ofType sampleType: SampleType<Sample>
    ) {}
    
    func handleDeletedObjects<Sample>(
        _ deletedObjects: some Collection<HKDeletedObject> & Sendable,
        ofType sampleType: SampleType<Sample>
    ) {}
}
