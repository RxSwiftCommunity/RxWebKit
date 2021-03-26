// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "RxWebKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "RxWebKit", targets: ["RxWebKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "RxWebKit",
            dependencies: ["RxSwift", "RxCocoa", "RxRelay"],
            path: "RxWebKit"
        ),
        .testTarget(
            name: "RxWebKitTests",
            dependencies: ["RxWebKit", "RxTest", "Nimble", "Quick"],
            path: "RxWebKitTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
