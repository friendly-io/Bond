// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Bond",
    platforms: [
        .macOS(.v10_12), .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(name: "Bond", targets: ["Bond"])
    ],
    dependencies: [
        .package(url: "https://github.com/DeclarativeHub/ReactiveKit.git", .upToNextMajor(from: "3.14.2")),
        .package(url: "https://github.com/tonyarnold/Differ.git", .upToNextMajor(from: "1.4.3"))
    ],
    targets: [
        .target(name: "BNDProtocolProxyBase"),
        .target(name: "Bond", dependencies: ["BNDProtocolProxyBase", "ReactiveKit", "Differ"]),
        .testTarget(name: "BondTests", dependencies: ["Bond", "ReactiveKit"])
    ]
)
