//
//  ConversionError.swift
//  HealthKitToFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation

public enum ConversionError : Error
{
    case conversionNotDefinedForType(identifier: String)
    case requiredConversionValueMissing(key: String)
    case unsupportedType(identifier: String)
    case dateConversionError
    case incorrectTypeForFactory
}
