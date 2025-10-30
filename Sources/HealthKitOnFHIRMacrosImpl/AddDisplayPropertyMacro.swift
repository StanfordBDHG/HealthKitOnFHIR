//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Algorithms
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros


/// The `@SynthesizeDisplayPropertyMacro` macro.
public struct SynthesizeDisplayPropertyMacro {}

extension SynthesizeDisplayPropertyMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let inputs: [String] = try { () -> [String] in
            guard let argsList = node.arguments?.as(LabeledExprListSyntax.self) else {
                throw MacroExpansionErrorMessage("missing arguments?")
            }
            return try argsList.map { syntax in
                guard let syntax = syntax.expression.as(StringLiteralExprSyntax.self) else {
                    throw MacroExpansionErrorMessage("Arhument must be a String literal!")
                }
                return try syntax.segments.reduce(into: "") { partialResult, segment in
                    switch segment {
                    case .stringSegment(let segment):
                        partialResult.append(contentsOf: segment.content.text)
                    case .expressionSegment:
                        throw MacroExpansionErrorMessage("Argument String isn't allowed to contain interpolations!")
                    }
                }
            }
        }()
        let displayProperty = try VariableDeclSyntax("var display: String?") {
            SwitchExprSyntax(subject: "self" as ExprSyntax) {
                for input in inputs {
                    .switchCase(SwitchCaseSyntax("case .\(raw: input):") {
                        #""\#(raw: displayText(for: input))""#
                    })
                }
                SwitchCaseListSyntax.Element.switchCase(SwitchCaseSyntax("@unknown default:") {
                    "nil" as ExprSyntax
                })
            }
        }
        return [DeclSyntax(fromProtocol: displayProperty)]
    }
    
    private static func displayText(for enumCaseName: String) -> String {
        let separatorIndices: [String.Index] = enumCaseName.indices.adjacentPairs().compactMap { lhsIdx, rhsIdx in
            enumCaseName[lhsIdx].isLowercase && enumCaseName[rhsIdx].isUppercase ? rhsIdx : nil
        }
        guard !separatorIndices.isEmpty else {
            return enumCaseName
        }
        let components = chain(CollectionOfOne(enumCaseName.startIndex), chain(separatorIndices, CollectionOfOne(enumCaseName.endIndex)))
            .adjacentPairs().map { enumCaseName[$0..<$1] }
        return components
            .map { component -> String in
                if component.allSatisfy(\.isUppercase) {
                    // eg: we want "asleepREM" to become "asleep REM", i.e. the "REM" part should remain uppercase
                    String(component)
                } else if component.allSatisfy(\.isLowercase) {
                    component.lowercased()
                } else {
                    String(component.lowercased())
                }
            }
            .joined(separator: " ")
    }
}


extension StringProtocol {
    func withFirstCharacterUppercased() -> String {
        var string = String(self)
        string.replaceSubrange(
            string.startIndex..<string.index(after: string.startIndex),
            with: string[string.startIndex].uppercased()
        )
        return string
    }
}
