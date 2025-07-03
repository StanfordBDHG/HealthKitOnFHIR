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
    @State var lines: [(linenumber: Int, text: String)] = []
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(lines, id: \.linenumber) { line in
                        Text(line.text)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 12, design: .monospaced))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                var lineNumber = 0
                print(json)
                json.enumerateLines { line, _ in
                    lines.append((lineNumber, line))
                    lineNumber += 1
                }
            }
        }
    }
}
