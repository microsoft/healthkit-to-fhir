# HealthKitToFhir Swift Library

[![Build Status](https://microsofthealth.visualstudio.com/Health/_apis/build/status/Readmissions/HealthKitToFhir_Daily?branchName=master)](https://microsofthealth.visualstudio.com/Health/_build/latest?definitionId=435&branchName=master)

The HealthKitToFhir Swift Library provides a simple way to create FHIR Resources from HKObjects.

## Basic Usage

### Create the factory

Resources are created using "Factory" classes that can be initialized with an optional JSON configuration to provide additional conversion data used to decorate the Resource. In the example below, an observation factory is initialized with no configuration.

```swift
do {
    let  factory = try ObservationFactory()
} catch {
    // Handle errors
}
```

### Use the factory for creating resources

```swift
do {
    let observation = try factory.observation(from: healthKitObject)
} catch {
    // Handle errors
}
```

## Supported conversions

### Observations

Additional observation conversions can be added by providing a custom configuration to the ObservationFactory when it is initialized at runtime.

- HKQuantityTypeIdentifierHeartRate
- HKCorrelationTypeIdentifierBloodPressure
- HKQuantityTypeIdentifierBloodPressureDiastolic
- HKQuantityTypeIdentifierBloodPressureSystolic
- HKQuantityTypeIdentifierStepCount
- HKQuantityTypeIdentifierBloodGlucose

### Devices

The DeviceFactory will extract data provided in HKObject device and sourceRevision properties to create a Device Resource. No configuration is required for this conversion.

## Adding support for new conversions

HealthKitToFhir uses JSON configuration files to provide additional data required to perform conversions from HealthKit HKObjects to FHIR Resources. The [DefaultObservationFactoryConfig.json](Sources/Configuration/DefaultObservationFactoryConfig.json) contains conversion data for the [ObservationFactory](Sources/Factories.ObservationFactory.swift) class to support the types listed above.

The example below shows data used for converting an HKQuantitySample containing a Blood Glucose reading to a FHIR Resource. The HKObject type identifier is used to look up data required to populate the Observation, this includes the code and valueQuantity properties of the Blood Glucose Observation. This "static" data will be "copied" to the Observation during the conversion process, while values like the measurement, date, and identifier will be converted from properties of the HKObject.

```json
"HKQuantityTypeIdentifierBloodGlucose": {
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "41653-7",
                    "display": "Glucose Glucometer (BldC) [Mass/Vol]"
                }
            ]
        },
        "valueQuantity": {
            "unit" : "mg/dL",
            "system" : "http://unitsofmeasure.org",
            "code" : "mg/dL"
        }
    }
```

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

There are many other ways to contribute to the HealthKitToFhir Project.

* [Submit bugs](https://github.com/Microsoft/healthkit-to-fhir/issues) and help us verify fixes as they are checked in.
* Review the [source code changes](https://github.com/Microsoft/healthkit-to-fhir/pulls).
* [Contribute bug fixes](CONTRIBUTING.md).

See [Contributing to HealthKitToFhir](CONTRIBUTING.md) for more information.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
