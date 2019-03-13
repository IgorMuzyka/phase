
import Foundation
import PackageConfig
import PathKit
import xcodeproj

let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
let isSilent = CommandLine.arguments.contains("--silent")
let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)

public struct Phase: Equatable, Hashable {
	
	public let name: String
	public let script: String
	public let targets: [String]

	public init(name: String, script: String, targets: [String]) {
		self.name = name
		self.script = script
		self.targets = targets
	}
}

public struct PhaseConfig {

	public let projectPath: String
	public let phases: [Phase]

	public init(projectPath: String, phases: [Phase]) {
		self.projectPath = projectPath
		self.phases = phases
	}
}

typealias Installations = [String: [Phase]]

extension Sequence where Iterator.Element: Hashable {

	func unique() -> [Iterator.Element] {
		var seen: [Iterator.Element: Bool] = [:]
		return self.filter { seen.updateValue(true, forKey: $0) == nil }
	}
}


func readConfiguration() -> PhaseConfig {
	guard let configuration = getPackageConfig()["phase"] as? PhaseConfig else {
		logger.logError("phase was called without configuration")
		exit(EXIT_FAILURE)
	}

	return configuration
}

func readProject(from configuration: PhaseConfig) -> (XcodeProj, Path) {
	let path = Path(configuration.projectPath)

	do {
		let project = try XcodeProj(path: path)
		return (project, path)
	} catch {
		logger.logError("Failed to initialize the project with error: \(error)")
		exit(EXIT_FAILURE)
	}
}

func install(phase: PBXShellScriptBuildPhase, on target: PBXTarget) -> Bool {
	let alreadyContains = target.buildPhases.compactMap { $0 as? PBXShellScriptBuildPhase }.contains {
		$0.name == phase.name
	}

	guard !alreadyContains  else {
		logger.logInfo("Target \(target.name) already has phase with name \(phase.name!), skipping.")
		return false
	}

	logger.logInfo("Injecting phase \(phase.name!) into target \(target.name)")
	target.buildPhases.append(phase)
	return true
}

func install(phases: [Phase], on project: XcodeProj) -> Bool {
	let targetNames = phases.map { $0.targets }.reduce([], +).unique()
	let targets = targetNames.reduce(into: [PBXNativeTarget]()) { (targets, targetName) in
		guard let target = project.pbxproj.nativeTargets.first(where: { $0.name == targetName }) else {
			logger.logError("No target named \(targetName)")
			return
		}

		targets.append(target)
	}
	let installations = phases.reduce(
		into: Installations(uniqueKeysWithValues: targetNames.map { ($0, []) })
	) { installation, phase in
		for targetName in phase.targets {
			installation[targetName]!.append(phase)
		}
	}.filter { targetName, phase in
		return targets.firstIndex(where: { $0.name == targetName }) != nil
	}
	let installableBuildPhases = installations.map { $0.value }.reduce([], +).unique().map { phase in
		PBXShellScriptBuildPhase(name: phase.name, shellScript: phase.script)
	}

	let targetsAndPhasesToInstall: [(PBXNativeTarget, [PBXShellScriptBuildPhase])] = installations.compactMap { targetName, buildPhases in
		let target = targets.first(where: { $0.name == targetName })!
		let phases = buildPhases.compactMap { phase in
			installableBuildPhases.first { $0.name == phase.name }
		}

		guard !phases.isEmpty else { return nil }
		return (target, phases)
	}

	var installedPhasesNames = [String]()

	logger.logInfo("Installing build phases on targets")
	targetsAndPhasesToInstall.forEach { target, phases in
		for phase in phases {
			if install(phase: phase, on: target) {
				installedPhasesNames.append(phase.name!)
			}
		}
	}

	logger.logInfo("Installing build phases on project")
	installedPhasesNames.unique().compactMap { name in
		installableBuildPhases.first(where: { $0.name == name })
	}.forEach {
		project.pbxproj.add(object: $0)
	}

	return !installableBuildPhases.isEmpty
}

func writeProject(_ project: XcodeProj, path: Path) {
	do {
		try project.writePBXProj(path: path, override: true, outputSettings: PBXOutputSettings())
	} catch {
		logger.logError("Failed to save changes to project with error: \(error)")
		exit(EXIT_FAILURE)
	}
}

let configuration = readConfiguration()
let (project, path) = readProject(from: configuration)

guard install(phases: configuration.phases, on: project) else {
	logger.logInfo("No updates to xcode project to be persisted, exiting.")
	exit(EXIT_SUCCESS)
}

writeProject(project, path: path)
exit(EXIT_SUCCESS)
