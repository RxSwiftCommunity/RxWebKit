// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "RxWebKit",
    products: [
        .library(name: "RxWebKit", targets: ["RxWebKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "4.5.0")
    ],
    targets: [
        .target(name: "RxWebKit", dependencies: ["RxSwift", "RxCocoa"], path: "RxWebKit")
    ]
)
