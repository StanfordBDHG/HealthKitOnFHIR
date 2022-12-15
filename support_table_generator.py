import json
from snakemd import Document, Table

mapping_file = open('Sources/HealthKitOnFHIR/Resources/HKSampleMapping.json')

data = json.load(mapping_file)

doc = Document("SUPPORT_TABLE")

doc.add_header("HKObject Support Table")

quantity_types = data["HKQuantitySamples"]

rows = []

for type in quantity_types:
    row = [type, quantity_types[type]["codings"][0]["code"], quantity_types[type]["unit"]["unit"]]
    rows.append(row)

doc.add_table(
    ["HKQuantityType", "Code", "Unit"],
    rows
)

doc.output_page()