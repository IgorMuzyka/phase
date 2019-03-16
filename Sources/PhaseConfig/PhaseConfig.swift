
import PackageConfig

public struct PhaseConfig: Codable, PackageConfig {

	public let projectPath: String
	public let phases: [Phase]

	public init(projectPath: String, phases: [Phase]) {
		self.projectPath = projectPath
		self.phases = phases
	}

	public static var dynamicLibraries: [String] { return ["PhaseConfig"] }
}
