
import PhaseConfig
import xcodeproj
import PathKit
import Commander
import SwiftShell

extension Procedure {

	static var main: Procedure<Void, Void> {
		return Procedure<Void, Void> { _, logger in
			do {
				let configuration = try Procedure<Void, PhaseConfig>.readConfiguration.run(())
				let (project, path) = try Procedure<PhaseConfig, (XcodeProj, Path)>.readProject.run(configuration)

				Group {
					$0.command("install", description: "install phases on xcode project", {
						let needsToUpdateProject = try Procedure<(Phase, XcodeProj), Bool>.installPhasesOnProject.run((configuration.phases, project))

						guard needsToUpdateProject else {
							logger.logInfo("No updates to xcode project to be persisted, exiting.")
							return
						}

						try Procedure<(XcodeProj, Path), Void>.writeProject.run((project, path))
					})
					$0.command("run", description: "run phase defined in PhaseConfig", { (phaseName: String) in
						guard let phase = configuration.phases.first(where: { $0.name == phaseName }) else {
							throw Error(stringLiteral: "No phase named \(phaseName) defined in Package.swift.")
						}
						try runAndPrint(bash: phase.script)
					})
				}.run()
			} catch {
				logger.logError(error.localizedDescription)
			}
		}
	}
}
