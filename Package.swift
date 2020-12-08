// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Ruka",
    products: [
        .library(
            name: "Ruka",
            targets: ["Ruka"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Ruka",
            dependencies: []
        ),
        .testTarget(
            name: "RukaTests",
            dependencies: ["Ruka"]
        ),
    ]
)
