// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "phase",
    products: [
        .executable(name: "phase", targets: ["Phase"]),
    ],
    dependencies: [
		.package(url: "https://github.com/f-meloni/Rocket", from: "0.0.1"),
		.package(url: "https://github.com/orta/PackageConfig.git", from: "0.0.1"),
		.package(url: "https://github.com/f-meloni/Logger", from: "0.1.0"),
		.package(url: "https://github.com/tuist/xcodeproj.git", from: "6.6.0"),
		.package(url: "https://github.com/kylef/PathKit", from: "0.9.2"),

		.package(url: "https://github.com/Quick/Quick", from: "1.3.2"), // dev
		.package(url: "https://github.com/Quick/Nimble", from: "7.3.1"), // dev
		.package(url: "https://github.com/kareman/SwiftShell", from: "4.0.0"), // dev
		.package(url: "https://github.com/JohnSundell/Files", from: "2.2.1"), // dev
    ],
    targets: [
		.target(name: "Phase", dependencies: [
			"Logger",
			"PackageConfig",
			"xcodeproj",
			"PathKit",
		]),
		.testTarget(name: "PhaseTests", dependencies:[
			"Quick",
			"Nimble",
			"SwiftShell",
			"xcodeproj",
			"Files",
		]),
    ]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfig([
	"rocket": ["steps":
		[
			"hide_dev_dependencies",
			"git_add",
			["commit": ["message": "Releasing version $VERSION"]],
			"tag",
			"push",
			"unhide_dev_dependencies",
			"git_add",
			["commit": ["message": "Reveresed package dev dependencies"]],
			"push",
		]
	]
])
#endif
