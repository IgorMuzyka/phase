
import PhaseConfig
import xcodeproj
import PathKit

extension Procedure {

	static var main: Procedure<Void, Void> {
		return Procedure<Void, Void> { _, logger in
			do {
				let configuration = try Procedure<Void, PhaseConfig>.readConfiguration.run(())
				let (project, path) = try Procedure<PhaseConfig, (XcodeProj, Path)>.readProject.run(configuration)
				let needsToUpdateProject = try Procedure<(Phase, XcodeProj), Bool>.installPhasesOnProject.run((configuration.phases, project))

				guard needsToUpdateProject else {
					logger.logInfo("No updates to xcode project to be persisted, exiting.")
					return
				}

				try Procedure<(XcodeProj, Path), Void>.writeProject.run((project, path))
			} catch {
				logger.logError(error.localizedDescription)
			}
		}
	}
}
