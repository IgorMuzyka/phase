
import PhaseConfig
import PackageConfig

extension Procedure {

	static var readConfiguration: Procedure<Void, PhaseConfig> {
		return Procedure<Void, PhaseConfig> { _, logger in
			logger.logInfo("Reading phase configuration")

			guard let config = PhaseConfig.load() else {
				throw Error.failedToLoadConfiguration
			}
			
			return config
		}
	}
}

extension Error {

	static var failedToLoadConfiguration: Error = "Failed to load configuration from Package.swift"
}
