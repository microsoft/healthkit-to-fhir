//
//  ObservationFactory.swift
//  HealthKitToFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import HealthKit
import FHIR


/// Class that handles the conversion of Apple HealthKit objects to FHIR.Observation types
open class ObservationFactory : FactoryBase, ResourceFactoryProtocol {
    
    /// Initializes a new ObservationFactory object.
    ///
    /// - Parameters:
    ///   - configName: Optional - The name of a supplimental configuration containing conversion information
    ///   - bundle: Optional - The bundle where the resource is contained.
    /// - Throws:
    ///   - ConfigurationError: Will throw if the config name is not nil and the config cannot be found is is not a valid format.
    public required init(configName: String? = nil, bundle: Foundation.Bundle = Bundle.main) throws {
        super.init()
        try loadDefaultConfiguration()
        try loadConfiguration(configName: configName, bundle: bundle)
    }
    
    public func resource<T>(from object: HKObject) throws -> T {
        guard T.self is Observation.Type else {
            throw ConversionError.incorrectTypeForFactory
        }
        
        return try observation(from: object) as! T
    }
    
    /// Creates a new FHIR.Observation object and populates it using values provided by the given HealthKit sample.
    ///
    /// - Parameters: sample: A HealthKit HKObject.
    /// - Returns: A new FHIR.Observation
    /// - Throws:
    ///   - ConversionError: Will throw if a required value is not mapped properly in the config or the sample type is not supported.
    ///   - FHIRValidationError: Will throw if the conversion process yeilds an invalid FHIR object.
    open func observation(from object: HKObject) throws -> Observation {
        guard let sample = object as? HKSample else {
            // The given type is not currently supported.
            throw ConversionError.unsupportedType(identifier: String(describing: HKObject.self))
        }
        
        let observation = Observation()
        
        if let quantitySample = sample as? HKQuantitySample {
            // The sample is a quantity sample - create a valueQuantity (conversion data provided in the Config).
            observation.valueQuantity = try self.valueQuantity(quantitySample: quantitySample)
        }
        else if let correlation = sample as? HKCorrelation {
            // The sample is a correlation - create components with the appropriate values (conversion data provided in the Config).
            observation.component = try self.component(correlation: correlation)
        }
        else
        {
            // The sample type is not currently supported.
            throw ConversionError.unsupportedType(identifier: sample.sampleType.identifier)
        }
        
        // Add the HealthKit Identifier
        observation.identifier = [try self.identifier(system: FactoryBase.healthKitIdentifierSystemKey, value: sample.uuid.uuidString)]
    
        // Add the Observation codes (provided by the lookup in the Config).
        observation.code = try self.codeableConcept(objectType: sample.sampleType)
        
        // Set the effective date
        let effective = try self.effective(sample: sample)
        observation.effectiveDateTime = effective as? DateTime ?? observation.effectiveDateTime
        observation.effectivePeriod = effective as? Period ?? observation.effectivePeriod
        
        return observation
    }
    
    /// Creates a FHIR.CodeableConcept for a given HKObjectType
    ///
    /// - Parameter objectType: The HealthKit object type
    /// - Returns: A new FHIR.CodeableConcept
    /// - Throws:
    ///   - ConversionError: Will throw if the Config does not contain conversion information for the given type or a required value is not provided.
    ///   - FHIRValidationError: Will throw if the conversion process yeilds an invalid FHIR object.
    open func codeableConcept(objectType: HKObjectType) throws -> CodeableConcept {
        guard let conversionValues = conversionMap[objectType.identifier] else {
            throw ConversionError.conversionNotDefinedForType(identifier: objectType.identifier)
        }
        
        guard let json = conversionValues[Constants.codeKey] else {
            throw ConversionError.requiredConversionValueMissing(key: Constants.codeKey)
        }
        
        return try CodeableConcept(json: json)
    }
    
    /// Creates a FHIR.Quantity for the given HKQuantitySample
    ///
    /// - Parameter quantitySample: A HealthKit HKQuantitySample
    /// - Returns: A new FHIR.Quantity
    /// - Throws:
    ///   - ConversionError: Will throw if the Config does not contain conversion information for the given type or a required value is not provided.
    ///   - FHIRValidationError: Will throw if the conversion process yeilds an invalid FHIR object.
    open func valueQuantity(quantitySample: HKQuantitySample) throws -> Quantity {
        guard let conversionValues = conversionMap[quantitySample.quantityType.identifier] else {
            throw ConversionError.conversionNotDefinedForType(identifier: quantitySample.quantityType.identifier)
        }
        
        guard var json = conversionValues[Constants.valueQuantityKey] else {
            throw ConversionError.requiredConversionValueMissing(key: Constants.valueQuantityKey)
        }
        
        guard let unitString = json[Constants.unitKey] as? String else {
            throw ConversionError.requiredConversionValueMissing(key: Constants.unitKey)
        }
        
        json[Constants.valueKey] = quantitySample.quantity.doubleValue(for: HKUnit.init(from: unitString))
        return try Quantity(json: json)
    }
    
    /// Creates a new collection of FHIR.ObservationComponents
    ///
    /// - Parameter correlation: A Healthkit HKCorrelation
    /// - Returns: a new FHIR.ObservationComponent collection
    /// - Throws:
    ///   - ConversionError: Will throw if the Config does not contain conversion information for the given type or a required value is not provided.
    ///   - FHIRValidationError: Will throw if the conversion process yeilds an invalid FHIR object.
    open func component(correlation: HKCorrelation ) throws -> [ObservationComponent] {
        var components: [ObservationComponent] = []
        
        for sample in correlation.objects {
            if let quantitySample = sample as? HKQuantitySample {
                let codeableConcept = try self.codeableConcept(objectType: quantitySample.sampleType)
                let component = ObservationComponent(code: codeableConcept)
                component.valueQuantity = try valueQuantity(quantitySample: quantitySample)
                components.append(component)
            }
            else
            {
                throw ConversionError.conversionNotDefinedForType(identifier: sample.sampleType.identifier)
            }
        }
        
        return components
    }
    
    /// Creates a FHIR.DateTime if the start and end dates of the sample are the same or a FHIR.Period if they are different.
    ///
    /// - Parameter sample: A HealthKit HKSample
    /// - Returns: A new FHIR.DateTime or a FHIR.Period
    /// - Throws:
    ///   - ConversionError: Will throw if the Date cannot be converted to either a FHIR.DateTime or a FHIR.Period
    open func effective(sample: HKSample) throws -> Any {
        let timeZoneString = sample.metadata?[HKMetadataKeyTimeZone] as? String
        
        if (sample.startDate == sample.endDate),
            let dateTime = dateTime(date: sample.startDate, timeZoneString: timeZoneString) {
                return dateTime
        }
        
        if let start = dateTime(date: sample.startDate, timeZoneString: timeZoneString),
            let end = dateTime(date: sample.endDate, timeZoneString: timeZoneString) {
            let period = Period()
            period.start = start
            period.end = end
            
            return period
        }
        
        throw ConversionError.dateConversionError
    }
    
    private func loadDefaultConfiguration() throws {
        do {
            // Initialize a data object with the contents of the file.
            let data = Configurations.defaultConfig.data(using: .utf8)
            
            guard data != nil else {
                throw ConfigurationError.invalidDefaultConfiguration
            }
            
            try loadConfiguration(data: data!)
            
        } catch {
            // The configuration was not formatted correctly.
            throw ConfigurationError.invalidDefaultConfiguration
        }
    }
}
