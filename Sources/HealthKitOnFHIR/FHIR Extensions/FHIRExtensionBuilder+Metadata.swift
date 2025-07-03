//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import ModelsR4


extension FHIRExtensionUrls {
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    /// Url of a FHIR Extension containing, if applicable, encoded `HKSourceRevision` of the `HKObject` from which a FHIR `Observation` was created.
    public nonisolated(unsafe) static let sourceDevice = "https://bdh.stanford.edu/fhir/defs/sourceDevice".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
    
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    /// Url of a FHIR Extension containing, if applicable, encoded `HKSourceRevision` of the `HKObject` from which a FHIR `Observation` was created.
    public nonisolated(unsafe) static let sourceRevision = "https://bdh.stanford.edu/fhir/defs/sourceRevision".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
}


extension FHIRExtensionBuilder {
    /// A FHIR Extension Builder that writes the absolute time range (i.e., start and end date) of a HealthKit sample into a FHIR `Observation` created from the sample.
    public static let sourceDevice = Self { (sample: HKSample, observation) in
        guard let device = sample.device else {
            observation.removeAllExtensions(withUrl: FHIRExtensionUrls.sourceDevice)
            return
        }
        let deviceInfo = Extension(url: FHIRExtensionUrls.sourceDevice)
        let appendDeviceInfoEntry = { (keyPath: KeyPath<HKDevice, String?>) in
            guard let name = keyPath._kvcKeyPathString else {
                print("Unable to obtain name for keyPath '\(keyPath)'. Skipping.")
                return
            }
            guard let value = device[keyPath: keyPath] else {
                return
            }
            // swiftlint:disable:next force_unwrapping
            let url = FHIRExtensionUrls.sourceDevice.value!.url.appending(component: name).asFHIRURIPrimitive()
            deviceInfo.appendExtension(
                Extension(url: url, value: .string(value.asFHIRStringPrimitive())),
                replaceAllExistingWithSameUrl: true
            )
        }
        appendDeviceInfoEntry(\.name)
        appendDeviceInfoEntry(\.manufacturer)
        appendDeviceInfoEntry(\.model)
        appendDeviceInfoEntry(\.hardwareVersion)
        appendDeviceInfoEntry(\.firmwareVersion)
        appendDeviceInfoEntry(\.softwareVersion)
        appendDeviceInfoEntry(\.localIdentifier)
        appendDeviceInfoEntry(\.udiDeviceIdentifier)
        observation.appendExtension(deviceInfo, replaceAllExistingWithSameUrl: true)
    }
    
    /// A FHIR Extension Builder that writes the absolute time range (i.e., start and end date) of a HealthKit sample into a FHIR `Observation` created from the sample.
    public static let sourceRevision = Self { (sample: HKSample, observation) in // swiftlint:disable:this closure_body_length
        let revision = sample.sourceRevision
        let deviceInfo = Extension(url: FHIRExtensionUrls.sourceRevision)
        let fieldUrl = { (components: String...) in
            // swiftlint:disable:next force_unwrapping
            var url = FHIRExtensionUrls.sourceRevision.value!.url
            for component in components {
                url = url.appending(component: component)
            }
            return url.asFHIRURIPrimitive()
        }
        let appendDeviceInfoEntry = { (keyPath: KeyPath<HKSourceRevision, String?>) in
            guard let name = keyPath._kvcKeyPathString else {
                print("Unable to obtain name for keyPath '\(keyPath)'. Skipping.")
                return
            }
            guard let value = revision[keyPath: keyPath] else {
                return
            }
            let url = fieldUrl(name)
            deviceInfo.appendExtension(
                Extension(url: url, value: .string(value.asFHIRStringPrimitive())),
                replaceAllExistingWithSameUrl: true
            )
        }
        
        deviceInfo.appendExtension(
            Extension(
                extension: [
                    Extension(url: fieldUrl("source", "name"), value: .string(revision.source.name.asFHIRStringPrimitive())),
                    Extension(url: fieldUrl("source", "bundleIdentifier"), value: .string(revision.source.bundleIdentifier.asFHIRStringPrimitive()))
                ],
                url: fieldUrl("source")
            ),
            replaceAllExistingWithSameUrl: true
        )
        appendDeviceInfoEntry(\.version)
        appendDeviceInfoEntry(\.productType)
        appendDeviceInfoEntry(\.OSVersion)
        observation.appendExtension(deviceInfo, replaceAllExistingWithSameUrl: true)
    }
}


extension HKSourceRevision {
    /// We define this as an optional String objc-compatible property, so that we can encode it into an Extension using the API we have above.
    @objc fileprivate var OSVersion: String? {
        let version = operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
}
