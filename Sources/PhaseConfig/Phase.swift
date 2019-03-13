
public struct Phase: Equatable, Hashable {

	public let name: String
	public let script: String
	public let targets: [String]

	public init(name: String, script: String, targets: [String]) {
		self.name = name
		self.script = script
		self.targets = targets
	}
}
