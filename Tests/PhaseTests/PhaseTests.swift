
import XCTest
import Quick
import Nimble

import SwiftShell

class PhaseTests: QuickSpec {

	override func spec() {
		describe("Phase Spec") {
			context("Should successfully inject build phases into project") {

				Temp().create().execute({ temp in
					let project = Project(name: "PhaseTestProject", targets: ["A", "B"], phases: [
						("lol", "kek", ["A", "B"])
					])
						.createSources()
						.createPackage()
						.generateXcodeProject()

					let output = project.injectBuildPhases()

					print(output.stdout)
					print(output.stderror)

					succeed()
				}).remove()

//				print(SwiftShell.main.currentdirectory)
//
//				print(SwiftShell.main.currentdirectory)

//				Temp().create().execute { temp in
//					it("should inject build phases into project") {
//						let buildPhase = TestProject.Phase("buildphase", "echo lol", ["A"])
//						let definition = TestProject(name: "a", targets: ["A"], phases: [buildPhase])

////						guard let phase = definition.target(named: "A")?.buildPhase(named: buildPhase.name) else {
////							fail("no phase")
////							return
////						}
//
////						fail("always")
////						guard let project = try? definition.createPackage() else {
////							fail("failed to create project")
////							return
////						}
////
////						guard let phase = project.target(named: "A")?.buildPhase(named: buildPhase.name) else {
////							fail("failed to find phase on target")
////							return
////						}
////
////						expect(phase.name).to(equal(buildPhase.name))
//					}
//				}.remove()
			}
		}
	}
}

import xcodeproj
import PathKit

extension Project {

	private var path: Path {
		return Path(SwiftShell.main.currentdirectory + "/" + name + ".pbxproj")
	}

	private var xcodeproj: XcodeProj? {
		return try? XcodeProj(path: path)
	}

	func target(named name: String) -> PBXNativeTarget? {
		return xcodeproj?.pbxproj.nativeTargets.first(where: { $0.name == name })
	}
}

extension PBXNativeTarget {

	func buildPhase(named name: String) -> PBXShellScriptBuildPhase? {
		return buildPhases
			.compactMap { $0 as? PBXShellScriptBuildPhase }
			.first(where: { $0.name == name})
	}
}
