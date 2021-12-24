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
