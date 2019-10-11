// swift-tools-version:5.0
//  Package.swift
//  HealthKitToFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import PackageDescription

let package = Package(
    name: "HealthKitToFhir",
	platforms: [
        .iOS(.v11)
	],
    products: [
        .library(
            name: "HealthKitToFhir",
            targets: ["HealthKitToFhir"]),
    ],
    dependencies: [
        .package(url: "https://github.com/smart-on-fhir/Swift-FHIR", from: "4.2.0")
    ],
    targets: [
        .target(
            name: "HealthKitToFhir",
            dependencies: ["FHIR"],
            path: "Sources"),
    ]
)
