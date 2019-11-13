//
//  ObservationFactoryTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class ObservationFactorySpec : QuickSpec {
    override func spec() {
        describe("ObservationFactory") {
            describe("initialization") {
                context("when initialized with no config and no bundle") {
                    it("does not throw an error") {
                        expect { try ObservationFactory() }.toNot( throwError() )
                    }
                }
                context("when initialized with a valid config") {
                    it("does not throw an error") {
                        let bundle = Foundation.Bundle.init(for: ObservationFactorySpec.self)
                        expect { try ObservationFactory(configName: "TestConfig", bundle: bundle) }.toNot( throwError() )
                    }
                }
                context("when initialized with an invalid config") {
                    it("throws an error") {
                        let bundle = Foundation.Bundle.init(for: ObservationFactorySpec.self)
                        expect { try ObservationFactory(configName: "InvalidConfig", bundle: bundle) }.to( throwError() )
                    }
                }
                context("when initialized with an incorrect config name") {
                    it("throws an error") {
                        expect { try ObservationFactory(configName: "WrongConfigName") }.to( throwError() )
                    }
                }
            }
        }
    }
}

