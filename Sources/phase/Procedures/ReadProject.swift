
import PhaseConfig
import xcodeproj
import PathKit

extension Procedure {

	static var readProject: Procedure<PhaseConfig, (XcodeProj, Path)> {
		return Procedure<PhaseConfig, (XcodeProj, Path)> { config, logger in
			logger.logInfo("Reading Xcode project")

			guard let path = try? Path.current.children().filter({ path in
				guard let last = path.components.last else {
					return false
				}

				return last.contains("xcodeproj")
			}).first else {
				throw Error(stringLiteral: "Failed to unwrap rpoject path")
			}

			guard let projectPath = path else {
				throw Error(stringLiteral: "Failed to unwrap rpoject path")
			}

			do {
				let project = try XcodeProj(path: projectPath)
				return (project, projectPath)
			} catch {
				throw Error(stringLiteral: "Failed to initialize project with error: \(error.localizedDescription)")
			}
		}
	}
}
