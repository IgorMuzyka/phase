# phase

A Swift Package that allows you to define your Xcode Build Phases from the `Package.swift` manifest.

### How to

Add dependency to dependencies in your project `Package.swift`

```swift
dependencies: [
	.package(url: "https://github.com/IgorMuzyka/phase", from: "1.0.0"),  
],
```

Define your build phases at the very bottom of your `Package.swift`

```swift
#if canImport(PhaseConfig)
import PhaseConfig

PhaseConfig(
	projectPath: "YourProject.xcodeproj", // the path to your xcodeproj
	phases: [
		Phase(
            name: "Swift Lint", 
            script: "swiftlint", // actual bash script that will be added to xcodeproj build phase
            targets: ["SomeTarget", "AnotherTarget"] // targets on which to apply
        ),
        Phase(
            name: "Generate code",
            script: "sourcery",
            targets: ["OneMoreTarget"]
        )
	]
).write()
#endif
```

Whenever you need your Build Phases injected into **xcodeproj** run this from directory with your `Package.swift`.

```bash
swift run phase
```

