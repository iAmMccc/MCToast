// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MCToast",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MCToast",
            targets: ["MCToast"]
        ),
    ],
    targets: [
        .target(
            name: "MCToast",
            path: "MCToast",
            sources: ["Classes"],
            resources: [.process("Assets")]
        ),
    ]
)
