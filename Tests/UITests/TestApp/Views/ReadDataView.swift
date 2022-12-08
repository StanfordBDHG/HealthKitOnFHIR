//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import HealthKit
import SwiftUI


struct ReadDataView: View {
    @StateObject private var manager = HealthKitManager()
    
    @State private var json = ""
    @State private var showingSheet = false
    
    
    var body: some View {
        Form {
            Section {
                Button("Read Step Count") {
                    Task {
                        try await readSteps()
                        showingSheet.toggle()
                    }
                }
                    .sheet(isPresented: $showingSheet) {
                        JSONView(data: self.$json)
                    }
            }
        }
            .navigationBarTitle("Read Data")
    }
    
    
    private func readSteps() async throws {
        try await manager.requestAuthorization()
        
        let observations = try await manager.readStepCount()
            .compactMap { sample in
                try? sample.observation
            }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(observations) else {
            return
        }
        
        self.json = String(decoding: data, as: UTF8.self)
        print(self.json)
    }
}


struct ReadDataView_Previews: PreviewProvider {
    static var previews: some View {
        ReadDataView()
    }
}
