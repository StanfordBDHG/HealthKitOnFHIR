//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ContentView: View {
    @State private var healthKitManager = HealthKitManager()
    
    var body: some View {
        Form {
            Section {
                ForEach(TestView.allCases) { testView in
                    NavigationLink(testView.rawValue) {
                        testView.view
                    }
                }
            }
            Section("Other") {
                NavigationLink("Read Data (appleStandTime)") {
                    ReadDataView(.appleStandTime)
                }
                NavigationLink("Read Data (appleStandHour)") {
                    ReadDataView(.appleStandHour)
                }
            }
        }
        .navigationBarTitle("HealthKitOnFHIR Tests")
        .environment(healthKitManager)
    }
}
