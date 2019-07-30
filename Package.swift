// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KituraRIL",
    dependencies: [
    .package(url: "https://github.com/IBM-Swift/Kitura.git",
                 .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/IBM-Swift/HeliumLogger.git",
             .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git",
             .upToNextMajor(from: "3.0.0")),
    .package(url: "https://github.com/IBM-Swift/Health.git",
            .upToNextMajor(from: "1.0.0"),
        
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        
        .target(
            name: "KituraRIL",
        dependencies: ["Kitura", "HeliumLogger", "CouchDB", "Health"],
            path: "Sources"),
        .testTarget(
            name: "KituraRILTests",
            dependencies: ["KituraRIL"]),
    ]
)
