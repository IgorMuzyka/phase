
import PackageConfig

public struct PhaseConfig: Codable, PackageConfig {

	public static var fileName: String { return "phase-config.json" }

	public let projectPath: String
	public let phases: [Phase]

	public init(projectPath: String, phases: [Phase]) {
		self.projectPath = projectPath
		self.phases = phases
	}
}
