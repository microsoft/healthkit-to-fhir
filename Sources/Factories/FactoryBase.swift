//
//  FactoryBase.swift
//  HealthKitToFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import FHIR

open class FactoryBase {
    
    public static let healthKitIdentifierSystemKey = Constants.healthAppBundleId
    
    internal var conversionMap: [String : [String : FHIRJSON]] = [:]
    internal let dateFormatter = ISO8601DateFormatter()
    
    public init() {}
    
    /// Creates a FHIR.DateTime from a Date and optional time zone string
    ///
    /// - Parameters:
    ///   - date: The Date to convert
    ///   - timeZoneString: An optional time zone string (An example identifier is "America/Los_Angeles".) If the time zone string is invalid or nil, the default will be GMT.
    /// - Returns: A new instance if FHIR.DateTime
    open func dateTime(date: Date, timeZoneString: String?) -> DateTime? {
        var timeZone: TimeZone?
        if timeZoneString != nil {
            timeZone = TimeZone(identifier: timeZoneString!)
        }
        
        dateFormatter.timeZone = timeZone ?? TimeZone.init(secondsFromGMT: 0)
        
        return DateTime(string: dateFormatter.string(from: date))
    }
    
    /// Creates a FHIR.Identifier with the given system and value
    ///
    /// - Parameters:
    ///   - system: The identifer system
    ///   - value: The identifier value
    /// - Returns: A new FHIR.Identifier
    /// - Throws:
    ///   - FHIRValdationError: Will throw if the Identifier cannot be created.
    open func identifier(system: String, value: String) throws -> Identifier {
        let json: FHIRJSON = [Constants.systemKey : system,
                              Constants.valueKey : value]
        
        return try Identifier(json: json)
    }
    
    /// Creates a FHIR.Identifier with the given codeable concept and value
    ///
    /// - Parameters:
    ///   - type: The identifer type (CodeableConcept)
    ///   - value: The identifier value
    /// - Returns: A new FHIR.Identifier
    open func identifier(type: CodeableConcept, value: String) -> Identifier {
        let identifier = Identifier()
        identifier.type = type
        identifier.value = FHIRString(value)
        
        return identifier
    }
    
    
    /// Creates a FHIR.Coding with the given system and code.
    ///
    /// - Parameters:
    ///   - system: the coding system.
    ///   - code: the code.
    /// - Returns: a new FHIR.Coding
    /// - Throws:
    ///   - FHIRValdationError: Will throw if the Coding cannot be created.
    open func coding(system: String, code: String) throws -> Coding {
        let json: FHIRJSON = [Constants.systemKey : system,
                              Constants.codeKey : code]
        
        return try Coding(json: json)
    }
    
    internal func loadConfiguration(configName: String?, bundle: Foundation.Bundle) throws {
        if var configName = configName
        {
            // Remove the .json extension if included.
            if configName.lowercased().hasSuffix(Constants.configFileExtension) {
                configName.removeLast(Constants.configFileExtension.count)
            }
            
            // Ensure the name string isn't empty.
            guard configName.count > 0 else {
                throw ConfigurationError.configurationNotFound
            }
            
            // Get the filepath for the config.
            if let path = bundle.path(forResource: configName, ofType: Constants.configFileExtension) {
                do {
                    // Initialize a data object with the contents of the file.
                    let data = try Data(contentsOf: URL.init(fileURLWithPath: path))
                    try loadConfiguration(data: data)
                    
                } catch {
                    // The configuration was not formatted correctly.
                    throw ConfigurationError.invalidConfiguration
                }
                
            } else {
                // The confiuration could not be found in the given bundle for the given name.
                throw ConfigurationError.configurationNotFound
            }
        }
    }
    
    internal func loadConfiguration(data: Data) throws {
        // Validate that the config is in a valid json format and merge with the default config.
        if let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : [String : FHIRJSON]] {
            for (key, value) in dictionary {
                if var existingValue = conversionMap[key] {
                    // There is default conversion data - merge.
                    existingValue.merge(value, uniquingKeysWith: { (_, new) in new })
                } else {
                    // No default conversion data - add to conversion map.
                    conversionMap[key] = value
                }
            }
        }
    }
}
