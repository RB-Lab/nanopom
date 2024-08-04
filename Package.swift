// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "nanopom",
  platforms: [
    .macOS(.v11)
  ],
  dependencies: [],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "NanoPomodoro",
      dependencies: [],
      path: "Sources",
      exclude: ["Info.plist"],
      swiftSettings: [
        .unsafeFlags([
          "-Xlinker", "-sectcreate", "-Xlinker", "__TEXT", "-Xlinker", "__info_plist", "-Xlinker",
          "Info.plist",
        ])
      ]
    )
  ]
)
