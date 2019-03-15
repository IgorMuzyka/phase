
import xcodeproj
import PathKit

extension Procedure {

	static var writeProject: Procedure<(XcodeProj, Path), Void> {
		return Procedure<(XcodeProj, Path), Void> { input, logger in
			logger.logInfo("Saving project")
			let (project, path) = input

			do {
				try project.writePBXProj(path: path, override: true, outputSettings: PBXOutputSettings())
			} catch {
				throw Error(stringLiteral: "Failed to save changes to project with error: \(error.localizedDescription)")
			}
		}
	}
}
