<!--
                  
This source file is part of the HealthKitOnFHIR open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

# HealthKitOnFHIR

[![Build and Test](https://github.com/StanfordBDHG/HealthKitOnFHIR/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/StanfordBDHG/HealthKitOnFHIR/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/StanfordBDHG/HealthKitOnFHIR/branch/main/graph/badge.svg?token=17BMMYE3AC)](https://codecov.io/gh/StanfordBDHG/HealthKitOnFHIR)

## Features
- Extensions to convert data from Apple HealthKit to HL7® FHIR® R4.
- Customizable mappings between HealthKit data types and standardized codes (e.g., LOINC)

## Supported HealthKit Data Types
- HKCorrelationType
    - BloodPressure
- HKQuantityType
    - BloodGlucose
    - BodyMass
    - BloodPressureDiastolic
    - BloodPressureSystolic
    - BodyTemperature
    - HeartRate
    - Height
    - OxygenSaturation
    - RespiratoryRate
    - StepCount

## Installation
HealthKitOnFHIR can be installed into your Xcode project using [Swift Package Manager](https://github.com/apple/swift-package-manager).

1. In Xcode 14 and newer (requires Swift 5.7), go to “File” » “Add Packages...”
2. Enter the URL to this GitHub repository, then select the `HealthKitOnFHIR` package to install.

## Usage

The HealthKitOnFHIR library provides extensions that convert supported HealthKit samples to FHIR [Observations](https://hl7.org/fhir/R4/observation.html) resources.

```swift
let sample: HKSample = // ...
let observation = try sample.observation
```

Codes and units can be customized by passing in a custom HKSampleMapping instance to the `observation(withMapping:)` method.

```swift
let sample: HKSample = // ...
let hksampleMapping: HKSampleMapping = // ...
let observation = try sample.observation(withMapping: hksampleMapping)
```

## Example

In the following example, we will query the HealthKit store for step count data, convert the resulting samples to FHIR observations, and encode them into JSON.

```swift
import HealthKitOnFHIR

// Initialize an HKHealthStore instance and request permissions with it
// ...

let date = ISO8601DateFormatter().date(from: "1885-11-11T00:00:00-08:00") ?? .now
let sample = HKQuantitySample(
    type: HKQuantityType(.heartRate),
    quantity: HKQuantity(unit: HKUnit.count().unitDivided(by: .minute()), doubleValue: 42.0),
    start: date,
    end: date
)

// Convert the results to FHIR observations
let observation: Observation
do {
    try observation = sample.observation
} catch {
    // Handle any mapping errors here.
    // ...
}

// Encode FHIR observations as JSON
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes, .sortedKeys]

guard let data = try? encoder.encode(observation) else {
    // Handle any encoding errors here.
    // ...
}

// Print the resulting JSON
let json = String(decoding: data, as: UTF8.self)
print(json)
```

The following example generates the following FHIR observation:

```json
{
  "code" : {
    "coding" : [
      {
        "code" : "8867-4",
        "display" : "Heart rate",
        "system" : "http://loinc.org"
      }
    ]
  },
  "effectiveDateTime" : "1885-11-11T00:00:00-08:00",
  "identifier" : [
    {
      "id" : "8BA093D9-B99B-4A3C-8C9E-98C86F49F5D8"
    }
  ],
  "issued" : "2023-01-01T00:00:00-08:00",
  "resourceType" : "Observation",
  "status" : "final",
  "valueQuantity" : {
    "code": "/min",
    "unit": "beats/minute",
    "system": "http://unitsofmeasure.org",
    "value" : 42
  }
}
```

## License
This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordBDHG/HealthKitOnFHIR/tree/main/LICENSES) for more information.


## Contributors
This project is developed as part of the Stanford Biodesign for Digital Health projects at Stanford.
See [CONTRIBUTORS.md](https://github.com/StanfordBDHG/HealthKitOnFHIR/tree/main/CONTRIBUTORS.md) for a full list of all HealthKitOnFHIR contributors.


## Notices
HealthKit is a registered trademark of Apple, Inc.
FHIR is a registered trademark of Health Level Seven International.

![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-light.png#gh-light-mode-only)
![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-dark.png#gh-dark-mode-only)
