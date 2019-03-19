# phase

A Swift Package that allows you to define your Xcode Build Phases from the `Package.swift` manifest.

## Usage

Define your build phases at the very bottom of your `Package.swift` like this.

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

Also consider that you probably don't need to have Xcode to be in your repository so you can add this line `/*.xcodeproj` to your `.gitignore`, and whenever you need your Xcode project just run `swift package generate-xcodeproj` and then you can inject Build Phases into your Xcode project using **phase**.

## Installation

Add dependency to dependencies in your project `Package.swift`

```swift
dependencies: [
    .package(url: "https://github.com/IgorMuzyka/phase", from: "1.0.0"),  
],
```

Add target `PackageConfigs` to your targets and list the `PhaseConfig` along with `PackageConfig` there:
```swift
.target(name: "PackageConfigs", dependencies: [
    "PackageConfig",
    "PhaseConfig",
]),
```

To make sure you can run `phase` run this in your project directory with `Package.swift`.
```bash
swift package resolve
swift run package-config # builds PackageConfigs dependencies
```
