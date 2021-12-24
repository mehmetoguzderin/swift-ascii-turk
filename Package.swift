// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AsciiTurk",
    products: [
        .library(name: "AsciiTurk", targets: ["AsciiTurk"]),
    ],
    targets: [
        .target(
            name: "AsciiTurk",
            dependencies: []),
    ]
)
