// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "phase",
    products: [
        .executable(name: "phase", targets: ["Phase"]),
		.library(name: "PhaseConfig", type: .dynamic, targets: ["PhaseConfig"]),
    ],
    dependencies: [
		.package(url: "https://github.com/IgorMuzyka/PackageConfig.git", .branch("master")),
//		.package(url: "https://github.com/orta/PackageConfig.git", from: "0.0.1"),
		.package(url: "https://github.com/f-meloni/Logger", from: "0.1.0"),
		.package(url: "https://github.com/tuist/xcodeproj.git", from: "6.6.0"),
		.package(url: "https://github.com/kylef/PathKit", from: "0.9.2"),

//		.package(url: "https://github.com/f-meloni/Rocket", from: "0.0.1"), // dev
//		.package(url: "https://github.com/IgorMuzyka/ignore", .branch("master")), // dev
//		.package(url: "https://github.com/Quick/Quick", from: "1.3.2"), // dev
//		.package(url: "https://github.com/Quick/Nimble", from: "7.3.1"), // dev
//		.package(url: "https://github.com/kareman/SwiftShell", from: "4.0.0"), // dev
//		.package(url: "https://github.com/JohnSundell/Files", from: "2.2.1"), // dev
    ],
    targets: [
		.target(name: "PhaseConfig", dependencies: [
			"PackageConfig",
		]),
		.target(name: "Phase", dependencies: [
			"PhaseConfig",
			"Logger",
			"xcodeproj",
			"PathKit",
		]),
//		.testTarget(name: "PhaseTests", dependencies: [
//			"Quick",
//			"Nimble",
//			"SwiftShell",
//			"xcodeproj",
//			"Files",
//		]),

//		.target(name: "PackageConfigs", dependencies: [
//			"PhaseConfig",
//		]),
    ]
)

#if canImport(PhaseConfig)
import PhaseConfig

PhaseConfig(phases: [
	Phase(name: "example", script: "echo 'lol'", targets: ["Phase"])
]).write()
#endif
