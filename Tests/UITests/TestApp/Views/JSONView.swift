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
    @Binding var data: String
    
    
    var body: some View {
        VStack {
            ScrollView {
                Text(data)
            }
                .padding()
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}
