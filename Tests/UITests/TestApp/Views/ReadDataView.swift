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
    @State private var manager = HealthKitManager()
    
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
                        JSONView(json: $json)
                    }
            }
        }
            .navigationBarTitle("Read Data")
    }
    
    
    private func readSteps() async throws {
        try await manager.requestStepAuthorization()
        
        let observations = try await manager.readStepCount()
            .compactMap { sample in
                try? sample.resource.get()
            }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        
        guard let data = try? encoder.encode(observations) else {
            return
        }
        
        self.json = String(decoding: data, as: UTF8.self)
    }
}


struct ReadDataView_Previews: PreviewProvider {
    static var previews: some View {
        ReadDataView()
    }
}
