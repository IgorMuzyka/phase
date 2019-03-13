
struct PhaseConfig: Codable {

	let projectPath: String
	let phases: [Phase]

	init(projectPath: String, phases: [Phase]) {
		self.projectPath = projectPath
		self.phases = phases
	}
}
