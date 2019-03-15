
import PackageConfig

extension Procedure {

	static var readConfiguration: Procedure<Void, PhaseConfig> {
		return Procedure<Void, PhaseConfig> { _, logger in
			logger.logInfo("Reading phase configuration")
			guard let dictionary = getPackageConfig()["phase"] as? [String: AnyObject] else {
				logger.logError("phase was called without configuration")
				throw Error.configurationMissing
			}

			guard let projectPath = dictionary["projectPath"] as? String else {
				logger.logError("Please specify projectPath to your xcode project")
				throw Error.noProjectPath
			}

			guard let phases = dictionary["phases"] as? [String: [String: AnyObject]] else {
				logger.logError("Please specify phases")
				throw Error.noPhases
			}

			var buildPhases = [Phase]()

			for (name, phase) in phases {
				guard let script = phase["script"] as? String else {
					logger.logError("No script for phase \(name)")
					continue
				}

				guard let targets = phase["targets"] as? [String], !targets.isEmpty else {
					logger.logError("No targets for phase \(name)")
					continue
				}

				logger.logInfo("Finished reading definition for phase \(name)")
				buildPhases.append(Phase(name: name, script: script, targets: targets))
			}

			return PhaseConfig(projectPath: projectPath, phases: buildPhases)
		}
	}
}

extension Error {

	static var configurationMissing: Error = "Phase configuration missing"
	static var noProjectPath: Error =  "Project path was not specified"
	static var noPhases: Error = "Phases was not specified"
}
