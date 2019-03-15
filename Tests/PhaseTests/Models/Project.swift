
import SwiftShell

class Project {

	public typealias Phase = (name: String, script: String, targets: [String])

	let name: String
	let targets: [String]
	let phases: [Phase]

	init(name: String, targets: [String], phases: [Phase]) {
		self.name = name
		self.targets = targets
		self.phases = phases
	}

	@discardableResult
	func createSources() -> Project {
		SwiftShell.run(bash: "mkdir Sources")

		for target in targets {
			SwiftShell.run(bash: "mkdir -p Sources/\(target)")
			SwiftShell.run(bash: "touch Sources/\(target)/\(target).swift")
		}

		SwiftShell.run(bash: "")
		return self
	}

	@discardableResult
	func createPackage() -> Project {
		let header =
"""
// swift-tools-version:4.2
import PackageDescription
let package = Package(
    name: "\(name)",
    products: [
"""
		let targetsList = targets.map { name in "\"\(name)\", " }.reduce("", +)
		let product = "        .library(name: \"\(name)\", targets: [\(targetsList)])"

		let targetsDefinition = targets.map { name in
			"        .target(name: \"\(name)\", dependencies: []),\n"
		}.reduce("", +)

		let dependencies =
"""
    dependencies: [.package(url: "https://github.com/IgorMuzyka/phase", .branch("master"))],
"""
		let footer =
"""
    ],
\(dependencies)
    targets: [
\(targetsDefinition)
	]
)
"""

		let configPhases = phases.map { phase in
			let targetsList = phase.targets.map { name in "\"\(name)\", " }.reduce("", +)
			return
"""
			"\(phase.name)": [
				"script": "\(phase.script)",
				"targets": [\(targetsList)]
			],
"""
		}.reduce("", +)
		let config =
"""
#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfig([
    "phase": [
        "projectPath": "\(name).xcodeproj",
        "phases": [
\(configPhases)
        ]
    ],
])
#endif
"""
		let package = [header, product, footer, config]
			.map { $0 + "\n" }
			.reduce("", +)
//			.replacingOccurrences(of: "\n", with: "\n\\")

		SwiftShell.run(bash: "touch Package.swift")
		SwiftShell.run(bash: "echo \'\(package)\' > Package.swift ")
		return self
	}

	@discardableResult
	func generateXcodeProject() -> Project {
		let result = SwiftShell.run(bash:
"""
swift package resolve
swift package generate-xcodeproj
"""
		).stdout
		return self
	}

	@discardableResult
	func injectBuildPhases() -> RunOutput {
		return SwiftShell.run(bash: "swift run phase --verbose")
	}

	#warning("check if needed")
	@discardableResult
	func removeXcodeProject() -> Project {
		SwiftShell.run(bash: "rm -rf \(name).pbxproj")
		return self
	}

	@discardableResult
	func removePackage() -> Project {
		SwiftShell.run(bash: "rm -rf Package.swift")
		return self
	}
}
