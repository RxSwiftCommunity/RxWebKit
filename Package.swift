// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "RxWebKit",
                      platforms: [
                        .macOS(.v10_13), .iOS(.v9)
                      ],
                      products: [
                        // Products define the executables and libraries produced by a package, and make them visible to other packages.
                        .library(name: "RxWebKit",
                                 targets: ["RxWebKit"])
                      ],

                      dependencies: [
                        // Dependencies declare other packages that this package depends on.
                        // Dependencies declare other packages that this package depends on.
                        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
                        // Development
                        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")), // dev
                        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")) // dev
                      ],

                      targets: [
                        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
                        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
                        .target(name: "RxWebKit", dependencies: ["RxSwift", "RxCocoa"],
                                path: "Sources"),
                        .testTarget(name: "RxWebKitTests", dependencies: ["RxWebKit", "Quick", "Nimble", "RxTest"]) // dev
                      ],
                      swiftLanguageVersions: [.v5])
