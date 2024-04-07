// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "Northwind",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .library(name: "Northwind", targets: [ "Northwind" ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Lighter-swift/Lighter.git",
             from: "1.2.4"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  ],
  
  targets: [
    .target(name         : "Northwind",
            dependencies : [ "Lighter" ],
            path         : "dist",
            resources    : [ .copy("northwind.db") ],
            plugins      : [ .plugin(name: "Enlighter", package: "Lighter") ])
  ]
)
