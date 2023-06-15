# Northwind-SQLite3.swift

A fork of Northwind-SQLite3 which packages the Northwind
database as a Swift module/package.

Swift package documentation: 
[NorthwindSQLite.swift](https://lighter-swift.github.io/NorthwindSQLite.swift/documentation/northwind/).

**Note**: 
Due to an Xcode 14 bug the Northwind module cannot yet be directly added to an 
Xcode project as a package dependency.
A ["Local Package"](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages)
needs to be setup.
It works fine in regular SPM contexts.

### Examples

- [NorthwindWebAPI](https://github.com/Lighter-swift/Examples/blob/develop/Sources/NorthwindWebAPI/) (A server side Swift example
  exposing the DB as a JSON API endpoint, and providing a few pretty HTML
  pages showing data contained.)
- [NorthwindSwiftUI](https://github.com/Lighter-swift/Examples/blob/develop/Sources/NorthwindSwiftUI/) (A SwiftUI example that lets
  one browse the Northwind database. Uses the Lighter API in combination with
  its async/await supports.)
  
### Package.swift

Example of a "LocalHelper" `Package.swift` that imports Northwind
for Xcode use:
```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "LocalHelper",
    platforms: [ .macOS(.v10_15), .iOS(.v13) ], // <= required
    products: [
        .library(
            name: "LocalHelper",
            targets: ["LocalHelper"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Lighter-swift/NorthwindSQLite.swift.git",
               branch: "develop")
    ],
    targets: [
        .target(
            name: "LocalHelper",
            dependencies: [
              .product(name: "Northwind", package: "NorthwindSQLite.swift")
            ])
    ]
)
```

To just re-export Northwind, use this in the LocalHelper.swift:
```swift
@_exported import Northwind
```


<hr />

This is a version of the Microsoft Access 2000 Northwind sample database, re-engineered for SQLite3.

The Northwind sample database was provided with Microsoft Access as a tutorial schema for managing small business customers, orders, inventory, purchasing, suppliers, shipping, and employees. Northwind is an excellent tutorial schema for a small-business ERP, with customers, orders, inventory, purchasing, suppliers, shipping, employees, and single-entry accounting.

All the TABLES and VIEWS from the MSSQL-2000 version have been converted to Sqlite3 and included here. Included is a single version prepopulated with data. Should you decide to, you can use the included python script to pump the database full of more data.

[Download here](https://raw.githubusercontent.com/jpwhite3/northwind-SQLite3/master/dist/northwind.db)

# Structure

![alt tag](images/Northwind_ERD.png)

# Build Instructions

## Prerequisites

- You are running in a unix-like environment (Linux, MacOS)
- Python 3.6 or higher (`python3 --version`)
- SQLite3 installed `sqlite3 -help`

## Build

```bash
make build  # Creates database at ./dist/northwind.db
```

## Populate with more data

```bash
make populate
```

## Print report of row counts

```bash
make report
```
