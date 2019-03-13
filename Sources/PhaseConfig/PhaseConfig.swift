
public struct PhaseConfig {

	public let projectPath: String
	public let phases: [Phase]

	public init(projectPath: String, phases: [Phase]) {
		self.projectPath = projectPath
		self.phases = phases
	}
}
