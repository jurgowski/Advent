// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Advent2024",
    platforms: [.iOS(.v18)],
    targets: [
        .target(name: "Advent2024"),
        .testTarget(
            name: "Days",
            dependencies: ["Advent2024"]
        ),
    ]
)
