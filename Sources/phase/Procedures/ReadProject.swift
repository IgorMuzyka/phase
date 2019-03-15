
import xcodeproj
import PathKit

extension Procedure {

	static var readProject: Procedure<PhaseConfig, (XcodeProj, Path)> {
		return Procedure<PhaseConfig, (XcodeProj, Path)> { config, logger in
			logger.logInfo("Reading Xcode project")
			let path = Path(config.projectPath)

			do {
				let project = try XcodeProj(path: path)
				return (project, path)
			} catch {
				throw Error(stringLiteral: "Failed to initialize project with error: \(error.localizedDescription)")
			}
		}
	}
}
