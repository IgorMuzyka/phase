
import PhaseConfig
import PackageConfig

extension Procedure {

	static var readConfiguration: Procedure<Void, PhaseConfig> {
		return Procedure<Void, PhaseConfig> { _, logger in
			logger.logInfo("Reading phase configuration")

			do {
				let config = try PhaseConfig.load()
				return config
			} catch {
				throw Error.failedToLoadConfiguration
			}
		}
	}
}

extension Error {

	static var failedToLoadConfiguration: Error = "Failed to load configuration from Package.swift"
}
