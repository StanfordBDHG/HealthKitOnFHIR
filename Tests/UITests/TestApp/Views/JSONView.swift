//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct JSONView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var json: String
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(json)
            }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
