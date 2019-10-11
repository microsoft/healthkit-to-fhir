//
//  ResourceFactoryProtocol.swift
//  HealthKitToFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import HealthKit
import FHIR

public protocol ResourceFactoryProtocol {
    
    /// The Apple Health App bundle id used as the identifier system key when creating resources
    static var healthKitIdentifierSystemKey: String { get }
    
    /// Creates a resoure of a given type from a HealthKit HKObject.
    ///
    /// - Parameter object: The HealthKit HKObject to be converted
    /// - Returns: A new FHIR.Resource
    /// - Throws:
    ///   - ConversionError: Will throw if a required value is not mapped properly in the config, the type is not supported, or the factory cannot handle the given resource.
    ///   - FHIRValidationError: Will throw if the conversion process yeilds an invalid FHIR object.
    func resource<T>(from object: HKObject) throws -> T
}
