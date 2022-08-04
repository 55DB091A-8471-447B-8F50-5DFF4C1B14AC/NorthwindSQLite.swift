// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "Northwind",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .library(name: "Northwind", targets: [ "Northwind" ])
  ],
  
  dependencies: [
    .package(url: "git@github.com:55DB091A-8471-447B-8F50-5DFF4C1B14AC/Lighter.git",
             branch: "develop"),
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
