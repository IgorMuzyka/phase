
import xcodeproj

extension Procedure {

	private typealias Installations = [String: [Phase]]

	static var installPhasesOnProject: Procedure<([Phase], XcodeProj), Bool> {
		return Procedure<([Phase], XcodeProj), Bool> { input, logger in
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

			let (phases, project) = input
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
	}
}
