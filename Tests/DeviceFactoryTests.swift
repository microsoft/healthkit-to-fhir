//
//  DeviceFactoryTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class DeviceFactorySpec : QuickSpec {
    override func spec() {
        let deviceFactory = DeviceFactory()
        describe("DeviceFactory") {
            context("device from object is called") {
                context("with an object") {
                    let object = testObject(with: nil, fileName: "HKObject")
                    let deviceResource = try? deviceFactory.device(from: object)
                    it("creates a resource with the expected identifer") {
                        expect(deviceResource?.identifier?.first?.value) == "com.apple.Health"
                    }
                    it("creates a resource with the expected operating system version") {
                        expect(self.versionValue(deviceResource: deviceResource, system: "com.apple.health.hkobject", code: "sourceRevision.operatingSystemVersion")) == "12.2.2"
                    }
                    it("creates a resource with the expected source revision version") {
                        expect(self.versionValue(deviceResource: deviceResource, system: "com.apple.health.hkobject", code: "sourceRevision.version")) == "12.2"
                    }
                    it("creates a resource with the expected user friendly name") {
                        if let deviceName = deviceResource?.deviceName?.first(where: { $0.type == .userFriendlyName}) {
                            expect(deviceName.name?.description) == "Health"
                        } else {
                            fail("device user-friendly-name not found.")
                        }
                    }
                }
                context("with an object containing a device") {
                    context("device has a name") {
                        let expectedName = "Test_Name"
                        let device = HKDevice(name: expectedName, manufacturer: nil, model: nil, hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the expected device name") {
                            if let deviceName = deviceResource?.deviceName?.first(where: { $0.type == .modelName}) {
                                expect(deviceName.name?.description) == expectedName
                            } else {
                                fail("device model-name not found.")
                            }
                        }
                    }
                    context("device has a manufacturer") {
                        let expectedManufacturer = "Test_Manufacturer"
                        let device = HKDevice(name: nil, manufacturer: expectedManufacturer, model: nil, hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the expected manufacturer") {
                            expect(deviceResource?.manufacturer?.description) == expectedManufacturer
                        }
                    }
                    context("device has a model") {
                        let expectedModel = "Test_Model"
                        let device = HKDevice(name: nil, manufacturer: nil, model: expectedModel, hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the expected model number") {
                            expect(deviceResource?.modelNumber?.description) == expectedModel
                        }
                    }
                    context("device has a hardware version") {
                        let expectedVersion = "1.1.1"
                        let device = HKDevice(name: nil, manufacturer: nil, model: nil, hardwareVersion: expectedVersion, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the expected hardware version") {
                            expect(self.versionValue(deviceResource: deviceResource, system: "com.apple.health.hkobject", code: "device.hardwareVersion")) == expectedVersion
                        }
                    }
                    context("device has a firmware version") {
                        let expectedVersion = "1.1.1"
                        let device = HKDevice(name: nil, manufacturer: nil, model: nil, hardwareVersion: nil, firmwareVersion: expectedVersion, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the expected firmware version") {
                            expect(self.versionValue(deviceResource: deviceResource, system: "com.apple.health.hkobject", code: "device.firmwareVersion")) == expectedVersion
                        }
                    }
                    context("device has a software version") {
                        let expectedVersion = "1.1.1"
                        let device = HKDevice(name: nil, manufacturer: nil, model: nil, hardwareVersion: nil, firmwareVersion: nil, softwareVersion: expectedVersion, localIdentifier: nil, udiDeviceIdentifier: nil)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the expected software version") {
                            expect(self.versionValue(deviceResource: deviceResource, system: "com.apple.health.hkobject", code: "device.softwareVersion")) == expectedVersion
                        }
                    }
                    context("device has a local identifier") {
                        let expectedIdentifier = "Test_Local_Id"
                        let device = HKDevice(name: nil, manufacturer: nil, model: nil, hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: expectedIdentifier, udiDeviceIdentifier: nil)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the expected local identifer") {
                            expect(self.identifierValue(deviceResource: deviceResource, system: "com.apple.health.hkobject", code: "device.localIdentifier")) == expectedIdentifier
                        }
                    }
                    context("device has a udi device identifier") {
                        let expectedIdentifier = "Test_Udi_Id"
                        let device = HKDevice(name: nil, manufacturer: nil, model: nil, hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: expectedIdentifier)
                        let object = testObject(with: device)
                        let deviceResource = try? deviceFactory.device(from: object)
                        it("creates a resource with the udi device identifier") {
                            expect(deviceResource?.udiCarrier?.first?.deviceIdentifier?.description) == expectedIdentifier
                        }
                        it("creates a resource with the udi device identifier") {
                            expect(deviceResource?.udiCarrier?.first?.entryType) == .selfReported
                        }
                    }
                }
            }
            context("resource from object is called") {
                context("with an incorrect type") {
                    it("throws an error") {
                        expect {
                            let device: Observation? = try deviceFactory.resource(from: self.testObject(with: nil))
                            return device
                            }.to(throwError(ConversionError.incorrectTypeForFactory))
                    }
                }
            }
        }
    }
    
    private func versionValue(deviceResource: Device?, system: String, code: String) -> String? {
        let version = deviceResource?.version?.first(where: { (deviceVersion) -> Bool in
            return deviceVersion.type?.coding?.first(where: { $0.system?.absoluteString == system && $0.code?.description == code }) != nil
        })
        
        return version?.value?.description
    }
    
    private func identifierValue(deviceResource: Device?, system: String, code: String) -> String? {
        let identifier = deviceResource?.identifier?.first(where: { (identifier) -> Bool in
            return identifier.type?.coding?.first(where: { $0.system?.absoluteString == system && $0.code?.description == code }) != nil
        })
        
        return identifier?.value?.description
    }
    
    private func testObject(with device: HKDevice?, fileName: String? = nil) -> HKObject {
        
        if fileName != nil,
            let path = Bundle(for: DeviceFactorySpec.self).path(forResource: fileName, ofType: nil) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return try! NSKeyedUnarchiver.unarchivedObject(ofClass: HKObject.self, from: data)!
        }
        
        let date = Date.init(timeIntervalSince1970: 0)
        return HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .heartRate)!, quantity: HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 70), start: date, end: date, device: device, metadata: nil)
    }
}
