# phase

A Swift Package that allows you to define your Xcode Build Phases from the `Package.swift` manifest.

## Usage

Define your build phases at the very bottom of your `Package.swift` like this.

```swift
#if canImport(PhaseConfig)
import PhaseConfig

PhaseConfig(phases: [
    Phase(
        name: "Swift Lint", 
        script: "swiftlint", // actual bash script that will be added to xcodeproj build phase
        targets: ["SomeTarget", "AnotherTarget"] // targets on which to apply
    ),
    Phase(
        name: "Generate code",
        script: "sourcery",
        targets: ["OneMoreTarget"]
    ),
    Phase(
        name: "xcode", // a phase to easily generate and inject phases in freshly made xcode project
        script: "swift run package-config;swift package generate-xcodeproj;swift run phase install --verbose",
        targets: [] // wont be installed on any targets, can be triggered via bash as "swift run phase run xcode"
    ),
]).write()
#endif
```

Whenever you need your Build Phases injected into **xcodeproj** run this from directory with your `Package.swift`.

```bash
swift run phase install
```

Whenever you wish to execute your phase from command line within the project directory with `Package.swift`.

```bash
swift run phase run yourPhaseName
```

Also consider that you probably don't need to have Xcode to be in your repository so you can add this line `/*.xcodeproj` to your `.gitignore`, and whenever you need your Xcode project just run `swift package generate-xcodeproj` and then you can inject Build Phases into your Xcode project using **phase**.

## Installation

Add dependency to dependencies in your project `Package.swift`

```swift
dependencies: [
    .package(url: "https://github.com/IgorMuzyka/phase", from: "0.0.5"),  
],
```

Add target `PackageConfigs` to your targets and list the `PhaseConfig` there:
```swift
.target(name: "PackageConfigs", dependencies: [
    "PhaseConfig",
]),
```

To make sure you can run `phase` run this in your project directory with `Package.swift`.
```bash
swift run package-config # builds PackageConfigs dependencies
```
