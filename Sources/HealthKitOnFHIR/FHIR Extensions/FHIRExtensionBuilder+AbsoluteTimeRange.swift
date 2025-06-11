//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable file_types_order

import Foundation
import HealthKit
import ModelsR4


extension FHIRExtensionUrls {
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    /// Url of a FHIR Extension containing, if applicable, the absolute start date timestamp of a FHIR `Observation`.
    public nonisolated(unsafe) static let absoluteTimeRangeStart = "https://bdh.stanford.edu/fhir/defs/absoluteTimeRangeStart".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
    
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    /// Url of a FHIR Extension containing, if applicable, the absolute end date timestamp of a FHIR `Observation`.
    public nonisolated(unsafe) static let absoluteTimeRangeEnd = "https://bdh.stanford.edu/fhir/defs/absoluteTimeRangeEnd".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
}


extension FHIRExtensionBuilder {
    /// A FHIR Extension that writes the absolute time range (i.e., start and end date) of a HealthKit sample into a FHIR `Observation` created from the sample.
    public static let includeAbsoluteTimeRange = Self { (sample: HKSample, observation) in
        let timeRangeExtensions = [
            Extension(
                url: FHIRExtensionUrls.absoluteTimeRangeStart,
                value: .decimal(sample.startDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
            ),
            Extension(
                url: FHIRExtensionUrls.absoluteTimeRangeEnd,
                value: .decimal(sample.endDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
            )
        ]
        observation.appendExtensions(timeRangeExtensions, replaceAllExistingWithSameUrl: true)
    }
}


extension Observation {
    /// Writes the Observation's absolute effective start and end date into a FHIR Extension.
    ///
    /// The absolute timestamps (decimals representing the time interval since 1970) are stored using the ``FHIRExtensionUrls/absoluteTimeRangeStart`` and ``FHIRExtensionUrls/absoluteTimeRangeEnd`` urls.
    ///
    /// - throws: If an error was encountered when converting the effective time range into the extension values. If the Observation's effecrive time uses an unsupported format (eg: `Timing`), ``HealthKitOnFHIRError/notSupported`` is thrown.
    public func encodeAbsoluteTimeRangeIntoExtension() throws {
        removeAllExtensions(withUrl: FHIRExtensionUrls.absoluteTimeRangeStart)
        removeAllExtensions(withUrl: FHIRExtensionUrls.absoluteTimeRangeEnd)
        let startDate, endDate: DateTime?
        switch effective {
        case nil:
            return
        case .dateTime(let dateTime):
            startDate = dateTime.value
            endDate = dateTime.value
        case .period(let period):
            startDate = period.start?.value
            endDate = period.end?.value
        case .instant(let instant):
            startDate = try instant.value.flatMap { try DateTime(instant: $0) }
            endDate = startDate
        case .timing:
            throw HealthKitOnFHIRError.notSupported
        }
        if let startDate = try startDate?.asNSDate() {
            appendExtension(
                Extension(
                    url: FHIRExtensionUrls.absoluteTimeRangeStart,
                    value: .decimal(startDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
                ),
                replaceAllExistingWithSameUrl: true
            )
        }
        if let endDate = try endDate?.asNSDate() {
            appendExtension(
                Extension(
                    url: FHIRExtensionUrls.absoluteTimeRangeEnd,
                    value: .decimal(endDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
                ),
                replaceAllExistingWithSameUrl: true
            )
        }
    }
}
