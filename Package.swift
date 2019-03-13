// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Phase",
    products: [
        .executable(name: "Phase", targets: ["Phase"]),
		.library(name: "PhaseConfig", type: .dynamic, targets: ["PhaseConfig"]),
    ],
    dependencies: [
		.package(url: "https://github.com/orta/PackageConfig.git", from: "0.0.1"),
		.package(url: "https://github.com/tuist/xcodeproj.git", from: "6.6.0"),
		.package(url: "https://github.com/kylef/PathKit", from: "0.9.2"),
    ],
    targets: [
		.target(name: "PhaseConfig", dependencies: [])
		.target(name: "Phase", dependencies: [
			"xcodeproj",
			"PackageConfig",
			"PathKit",
			"PhaseConfig"
		]),
    ]
)
