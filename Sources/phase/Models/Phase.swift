
struct Phase: Equatable, Hashable, Codable {

	let name: String
	let script: String
	let targets: [String]

	init(name: String, script: String, targets: [String]) {
		self.name = name
		self.script = script
		self.targets = targets
	}
}
