
import Foundation
import Logger

struct Procedure<Input, Output> {

	typealias Script = (Input, Logger) throws -> Output

	let script: Script

	@discardableResult
	func run(_ input: Input) throws -> Output {
		return try script(input, logger)
	}

	var logger: Logger {
		let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
		let isSilent = CommandLine.arguments.contains("--silent")
		return Logger(isVerbose: isVerbose, isSilent: isSilent)
	}
}
