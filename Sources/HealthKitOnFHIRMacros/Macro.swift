//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


@attached(member, names: arbitrary)
public macro EnumCases(
    _ cases: StaticString...
) = #externalMacro(module: "HealthKitOnFHIRMacrosImpl", type: "EnumMacro")
