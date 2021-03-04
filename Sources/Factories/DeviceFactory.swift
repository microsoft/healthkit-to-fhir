//
//  DeviceFactory.swift
//  HealthKitToFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import HealthKit
import FHIR

/// Class that handles the conversion of Apple HealthKit HKSourceRevision objects to FHIR.Device types
open class DeviceFactory : FactoryBase, ResourceFactoryProtocol {
    
    public func resource<T>(from object: HKObject) throws -> T {
        guard T.self is Device.Type else {
            throw ConversionError.incorrectTypeForFactory
        }
        
        return try device(from: object) as! T
    }
    
    open func device(from object: HKObject) throws -> Device {
        let device = Device()
        
        // Add the sourceRevision.source.bundleIdentifier as the Device identifier.
        device.identifier = [try identifier(system: FactoryBase.healthKitIdentifierSystemKey, value: object.sourceRevision.source.bundleIdentifier)]
        
        // Add the local identifier to the device
        if let localIdentifer = object.device?.localIdentifier {
            let codeableConcept = CodeableConcept()
            codeableConcept.coding = [try coding(system: Constants.hkObjectSystemValue, code: NSExpression(forKeyPath: \HKObject.device?.localIdentifier).keyPath)]
            device.identifier?.append(identifier(type: codeableConcept, value: localIdentifer))
        }
        
        // Add the manufacturer.
        if let manufacturer = object.device?.manufacturer {
            device.manufacturer = FHIRString(manufacturer)
        }
        
        // Add the model.
        if let model = object.device?.model {
            device.modelNumber = FHIRString(model)
        }
        
        // Add the UDI if it exists.
        addUdiDeviceIdentifier(device: device, object: object)
        
        // Add the version information to the Device.
        try addVersions(device: device, object: object)
        
        // Add the name information to the Device.
        addNames(device: device, object: object)
        
        return device
    }
    
    /// Adds the UDI from the HKObject (if a UDI exists) to the Device
    ///
    /// - Parameters:
    ///   - device: The Device object that the UDI should be added to.
    ///   - object: The HKObject.
    open func addUdiDeviceIdentifier(device: Device, object: HKObject) {
        var udiCarrier = device.udiCarrier ?? [DeviceUdiCarrier]()
        
        if let udiDeviceIdentifier = object.device?.udiDeviceIdentifier {
            let udiDeviceCarrier = DeviceUdiCarrier()
            udiDeviceCarrier.entryType = .selfReported
            udiDeviceCarrier.deviceIdentifier = FHIRString(udiDeviceIdentifier)
            udiCarrier.append(udiDeviceCarrier)
            
            device.udiCarrier = udiCarrier
        }
    }
    
    /// Adds version information from the HKObject to the Device.
    ///
    /// - Parameters:
    ///   - device: The Device object that the version information should be added to.
    ///   - object: The HKObject.
    open func addVersions(device: Device, object: HKObject) throws {
        var deviceVersions = device.version ?? [DeviceVersion]()
        
        // Add the operatingSystemVersion from the sourceRevision
        let osVersion = object.sourceRevision.operatingSystemVersion
        deviceVersions.append(try deviceVersion(version: "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)", system: Constants.hkObjectSystemValue, code: NSExpression(forKeyPath: \HKObject.sourceRevision.operatingSystemVersion).keyPath))
        
        // Add the version from the sourceRevision
        if let version = object.sourceRevision.version {
            deviceVersions.append(try deviceVersion(version: version, system: Constants.hkObjectSystemValue, code: NSExpression(forKeyPath: \HKObject.sourceRevision.version).keyPath))
        }
        
        // Add the firmware version from the device.
        if let firmwareVersion = object.device?.firmwareVersion {
            deviceVersions.append(try deviceVersion(version: firmwareVersion, system: Constants.hkObjectSystemValue, code: NSExpression(forKeyPath: \HKObject.device?.firmwareVersion).keyPath))
        }
        
        // Add the hardware version from the device.
        if let hardwareVersion = object.device?.hardwareVersion {
            deviceVersions.append(try deviceVersion(version: hardwareVersion, system: Constants.hkObjectSystemValue, code: NSExpression(forKeyPath: \HKObject.device?.hardwareVersion).keyPath))
        }
        
        // Add the software version from the device.
        if let softwareVersion = object.device?.softwareVersion {
            deviceVersions.append(try deviceVersion(version: softwareVersion, system: Constants.hkObjectSystemValue, code: NSExpression(forKeyPath: \HKObject.device?.softwareVersion).keyPath))
        }
        
        device.version = deviceVersions
    }
    
    /// Adds name information from the HKObject to the Device.
    ///
    /// - Parameters:
    ///   - device: The Device object that the name information should be added to.
    ///   - object: The HKObject.
    open func addNames(device: Device, object: HKObject) {
        var deviceNames = device.deviceName ?? [DeviceDeviceName]()
        
        // Add the name from the source.
        deviceNames.append(DeviceDeviceName(name: FHIRString(object.sourceRevision.source.name), type: .userFriendlyName))
        
        // Add the name from the device.
        if let name = object.device?.name {
            deviceNames.append(DeviceDeviceName(name: FHIRString(name), type: .modelName))
        }
        
        device.deviceName = deviceNames
    }
    
    
    /// Creates a new FHIR.DeviceVersion with a type populated with given system and code and the value populated with the given version.
    ///
    /// - Parameters:
    ///   - version: The version string.
    ///   - system: The system (used to create a CodeableConcept for the type property).
    ///   - code: The code (used to create a CodeableConcept for the type property).
    /// - Returns: A new FHIR.DeviceVersion.
    /// - Throws:
    ///   - FHIRValdationError: Will throw if the DeviceVersion cannot be created.
    open func deviceVersion(version: String, system: String, code: String) throws -> DeviceVersion {
        let deviceVersion = DeviceVersion()
        deviceVersion.type = CodeableConcept()
        deviceVersion.type?.coding = [try coding(system: Constants.hkObjectSystemValue, code: code)]
        deviceVersion.value = FHIRString(version)
        
        return deviceVersion
    }
}
