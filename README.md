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
- Customizable mappings between HealthKit data types and standardized codes (e.g. LOINC)

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

The HealthKitOnFHIR library provides extensions that converts supported HealthKit samples to FHIR [Observations](https://hl7.org/fhir/R4/observation.html) resources. An [example application](https://github.com/StanfordBDHG/HealthKitOnFHIR/tree/main/Tests/UITests/TestApp) is provided.

In the following example, we will query the HealthKit store for step count data, convert the resulting samples to FHIR observations, and encode into JSON.

```swift
import HealthKitOnFHIR

// initialize an HKHealthStore instance and request permissions with it
// ...

// create a query for step data
let query = HKSampleQueryDescriptor(
    predicates: [.quantitySample(type: HKQuantityType(.stepCount))],
    sortDescriptors: [],
    limit: HKObjectQueryNoLimit
)

// run the query on the HKHealthStore
let results = try await query.result(for: healthStore)

// convert the results to FHIR observations
let observations = results.compactMap { sample in
    try? sample.observation
}

// Encode FHIR observations as JSON
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

guard let data = try? encoder.encode(observations) else {
    return
}

// Print the resulting JSON
let json = String(decoding: data, as: UTF8.self)
print(json)
```

The following FHIR observation would be created:

```json
[
  {
    "status" : "final",
    "valueQuantity" : {
      "value" : 2,
      "unit" : "steps"
    },
    "issued" : "2022-12-08T05:18:29.608404994-05:00",
    "code" : {
      "coding" : [
        {
          "display" : "Number of steps in unspecified time Pedometer",
          "system" : "http:\/\/loinc.org",
          "code" : "55423-8"
        }
      ]
    },
    "effectivePeriod" : {
      "end" : "2022-11-27T12:01:37.774554967-05:00",
      "start" : "2022-11-27T13:01:37.774554967-05:00"
    },
    "identifier" : [
      {
        "id" : "87642F17-5190-433C-8594-B887191166C6"
      }
    ],
    "resourceType" : "Observation"
  }
]
```
Codes and units can be customized by editing the [JSON mapping file](https://github.com/StanfordBDHG/HealthKitOnFHIR/blob/main/Sources/HealthKitOnFHIR/Resources/HKSampleMapping.json).

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
