
import PackageConfig

public struct PhaseConfig: Codable, PackageConfig {

	public static var fileName: String { return "phase-config.json" }

	public let phases: [Phase]

	public init(phases: [Phase]) {
		self.phases = phases
	}
}
