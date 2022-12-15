#
# This source file is part of the HealthKitOnFHIR open source project
#
# SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

import json
from operator import itemgetter

all_quantity_types = [
    "HKQuantityTypeIdentifierActiveEnergyBurned",
    "HKQuantityTypeIdentifierAppleExerciseTime",
    "HKQuantityTypeIdentifierBasalBodyTemperature",
    "HKQuantityTypeIdentifierBasalEnergyBurned",
    "HKQuantityTypeIdentifierBloodAlcoholContent",
    "HKQuantityTypeIdentifierBloodGlucose",
    "HKQuantityTypeIdentifierBloodPressureDiastolic",
    "HKQuantityTypeIdentifierBloodPressureSystolic",
    "HKQuantityTypeIdentifierBodyFatPercentage",
    "HKQuantityTypeIdentifierBodyMass",
    "HKQuantityTypeIdentifierBodyMassIndex",
    "HKQuantityTypeIdentifierBodyTemperature",
    "HKQuantityTypeIdentifierDietaryBiotin",
    "HKQuantityTypeIdentifierDietaryCaffeine",
    "HKQuantityTypeIdentifierDietaryCalcium",
    "HKQuantityTypeIdentifierDietaryCarbohydrates",
    "HKQuantityTypeIdentifierDietaryChloride",
    "HKQuantityTypeIdentifierDietaryCholesterol",
    "HKQuantityTypeIdentifierDietaryChromium",
    "HKQuantityTypeIdentifierDietaryCopper",
    "HKQuantityTypeIdentifierDietaryEnergyConsumed",
    "HKQuantityTypeIdentifierDietaryFatMonounsaturated",
    "HKQuantityTypeIdentifierDietaryFatPolyunsaturated",
    "HKQuantityTypeIdentifierDietaryFatSaturated",
    "HKQuantityTypeIdentifierDietaryFatTotal"
    "HKQuantityTypeIdentifierDietaryFiber",
    "HKQuantityTypeIdentifierDietaryFolate",
    "HKQuantityTypeIdentifierDietaryIodine",
    "HKQuantityTypeIdentifierDietaryIron",
    "HKQuantityTypeIdentifierDietaryMagnesium",
    "HKQuantityTypeIdentifierDietaryManganese",
    "HKQuantityTypeIdentifierDietaryMolybdenum",
    "HKQuantityTypeIdentifierDietaryNiacin",
    "HKQuantityTypeIdentifierDietaryPantothenicAcid",
    "HKQuantityTypeIdentifierDietaryPhosphorus",
    "HKQuantityTypeIdentifierDietaryPotassium",
    "HKQuantityTypeIdentifierDietaryProtein",
    "HKQuantityTypeIdentifierDietaryRiboflavin",
    "HKQuantityTypeIdentifierDietarySelenium",
    "HKQuantityTypeIdentifierDietarySodium",
    "HKQuantityTypeIdentifierDietarySugar",
    "HKQuantityTypeIdentifierDietaryThiamin",
    "HKQuantityTypeIdentifierDietaryVitaminA",
    "HKQuantityTypeIdentifierDietaryVitaminB12",
    "HKQuantityTypeIdentifierDietaryVitaminB6",
    "HKQuantityTypeIdentifierDietaryVitaminC",
    "HKQuantityTypeIdentifierDietaryVitaminD",
    "HKQuantityTypeIdentifierDietaryVitaminE",
    "HKQuantityTypeIdentifierDietaryVitaminK",
    "HKQuantityTypeIdentifierDietaryWater",
    "HKQuantityTypeIdentifierDietaryZinc",
    "HKQuantityTypeIdentifierDistanceCycling",
    "HKQuantityTypeIdentifierDistanceDownhillSnowSports",
    "HKQuantityTypeIdentifierDistanceSwimming",
    "HKQuantityTypeIdentifierDistanceWalkingRunning",
    "HKQuantityTypeIdentifierDistanceWheelchair",
    "HKQuantityTypeIdentifierElectrodermalActivity",
    "HKQuantityTypeIdentifierFlightsClimbed",
    "HKQuantityTypeIdentifierForcedExpiratoryVolume1",
    "HKQuantityTypeIdentifierForcedVitalCapacity",
    "HKQuantityTypeIdentifierHeartRate",
    "HKQuantityTypeIdentifierHeartRateVariabilitySDNN",
    "HKQuantityTypeIdentifierHeight",
    "HKQuantityTypeIdentifierInhalerUsage",
    "HKQuantityTypeIdentifierInsulinDelivery",
    "HKQuantityTypeIdentifierLeanBodyMass",
    "HKQuantityTypeIdentifierNikeFuel",
    "HKQuantityTypeIdentifierNumberOfTimesFallen",
    "HKQuantityTypeIdentifierOxygenSaturation",
    "HKQuantityTypeIdentifierPeakExpiratoryFlowRate",
    "HKQuantityTypeIdentifierPeripheralPerfusionIndex",
    "HKQuantityTypeIdentifierPushCount",
    "HKQuantityTypeIdentifierRespiratoryRate",
    "HKQuantityTypeIdentifierRestingHeartRate",
    "HKQuantityTypeIdentifierStepCount",
    "HKQuantityTypeIdentifierSwimmingStrokeCount",
    "HKQuantityTypeIdentifierUVExposure",
    "HKQuantityTypeIdentifierVO2Max",
    "HKQuantityTypeIdentifierWaistCircumference",
    "HKQuantityTypeIdentifierWalkingHeartRateAverage"
]

mapping_file = open('Sources/HealthKitOnFHIR/Resources/HKSampleMapping.json')

data = json.load(mapping_file)

#Open Markdown File to write
markdown_file = open('SUPPORT_TABLE.md', 'w')

#Add header
reuse_header = """
<!--
                  
This source file is part of the HealthKitOnFHIR open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->
"""
markdown_file.write(reuse_header + '\n\n' + '# HKObject Support Table ' + '\n\n')

# Add all the supported types
quantity_types = data['HKQuantitySamples']
rows = []

for type in quantity_types:    
    # Format code links
    coding = quantity_types[type]['codings'][0]
    code = coding['code']
    code_system = quantity_types[type]['codings'][0]['system']

    if code_system == 'http://loinc.org' or code_system == 'https://developer.apple.com/documentation/healthkit':
        code_url = '{}/{}'.format(code_system, code)
    else:
        code_url = code_system

    linked_code = '[{}]({})'.format(code, code_url)

    # Format unit links
    unit_coding = quantity_types[type]['unit']
    unit = unit_coding['unit']
    if 'system' in unit_coding: # Some units are not from a code system
        linked_unit = '[{}]({})'.format(unit, unit_coding['system'])
    else:
        linked_unit = unit
    
    row = [type, ':white_check_mark:', linked_code, linked_unit]
    rows.append(row)

# Add all the unsupported types
for type in all_quantity_types:
    if type not in quantity_types:
        rows.append([type, ":x:", "-", "-"])

# Sort the rows alphabetically
rows = sorted(rows, key=itemgetter(0))

# Link all the HealthKit types to Apple docs
for type in rows:
    type[0] = '[{}]({})'.format(type[0].removeprefix('HKQuantityTypeIdentifier'), 'https://developer.apple.com/documentation/healthkit/' + type[0])

# Write the statistics
stats = 'HealthKitOnFHIR supports {} of {} quantity types.'.format(len(quantity_types), len(all_quantity_types))
markdown_file.write(stats + '\n\n')

# Write the table header
markdown_file.write('|HKQuantityType|Supported|Code|Unit|' + '\n' + '|----|----|----|----|' + '\n')

# Write all rows
for row in rows:
    markdown_file.write('|' + '|'.join(row) + '|' + '\n')