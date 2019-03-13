// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "phase",
    products: [
        .executable(name: "phase", targets: ["phase"]),
    ],
    dependencies: [
		.package(url: "https://github.com/orta/PackageConfig.git", from: "0.0.1"),
		.package(url: "https://github.com/tuist/xcodeproj.git", from: "6.6.0"),
		.package(url: "https://github.com/kylef/PathKit", from: "0.9.2"),
    ],
    targets: [
		.target(name: "phase", dependencies: [
			"xcodeproj",
			"PackageConfig",
			"PathKit",
		]),
    ]
)
