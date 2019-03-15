
struct Error: ExpressibleByStringLiteral, Swift.Error {

	let reason: String

	init(stringLiteral reason: String) {
		self.reason = reason
	}

	var localizedDescription: String {
		return reason
	}
}

