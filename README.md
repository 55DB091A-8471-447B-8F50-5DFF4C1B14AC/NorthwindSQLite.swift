# Northwind-SQLite3.swift

A fork of Northwind-SQLite3 which packages the Northwind
database as a Swift module/package.

Swift package documentation: 
[NorthwindSQLite.swift](https://lighter-swift.github.io/NorthwindSQLite.swift/documentation/northwind/).

**Note**: 
Due to an Xcode 14/15 bug the Northwind module cannot yet be directly added to an 
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

Steps to workaround Xcode 15beta issues:
- in your Xcode project, select the project in the sidebar
- in the Xcode menu, use the "File" / "New Package …" menu
- select the "Library" template
- in the next dialog use "Add to project" (it defaults to none), and add it to the Xcode projec
- make sure to link the helper package to the target (e.g. via "Frameworks, Libs and Embedded Content")
This is generally a good way to maintain dependencies in Xcode.

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

```mermaid
erDiagram
    CustomerCustomerDemo }o--|| CustomerDemographics : have
    CustomerCustomerDemo }o--|| Customers : through
    Employees ||--|| Employees : "reports to"
    Employees ||--o{ EmployeeTerritories : through
    Orders }o--|| Shippers : "ships via"
    "Order Details" }o--|| Orders : have
    "Order Details" }o--|| Products : contain
    Products }o--|| Categories : in
    Products }o--|| Suppliers : "supplied by"
    Territories ||--|| Regions : in
    EmployeeTerritories }o--|| Territories : have
    Orders }o--|| Customers : place
    Orders }o--|| Employees : "sold by"


    Categories {
        int CategoryID PK
        string CategoryName
        string Description
        blob Picture
    }
    CustomerCustomerDemo {
        string CustomerID PK, FK
        string CustomerTypeID PK, FK
    }
    CustomerDemographics {
        string CustomerTypeID PK
        string CustomerDesc
    }
    Customers {
        string CustomerID PK
        string CompanyName
        string ContactName
        string ContactTitle
        string Address
        string City
        string Region
        string PostalCode
        string Country
        string Phone
        string Fax
    }
    Employees {
        int EmployeeID PK
        string LastName
        string FirstName
        string Title
        string TitleOfCourtesy
        date BirthDate
        date HireDate
        string Address
        string City
        string Region
        string PostalCode
        string Country
        string HomePhone
        string Extension
        blob Photo
        string Notes
        int ReportsTo FK
        string PhotoPath
    }
    EmployeeTerritories {
        int EmployeeID PK, FK
        int TerritoryID PK, FK
    }
    "Order Details" {
        int OrderID PK, FK
        int ProductID PK, FK
        float UnitPrice
        int Quantity
        real Discount
    }
    Orders {
        int OrderID PK
        string CustomerID FK
        int EmployeeID FK
        datetime OrderDate
        datetime RequiredDate
        datetime ShippedDate
        int ShipVia FK
        numeric Freight
        string ShipName
        string ShipAddress
        string ShipCity
        string ShipRegion
        string ShipPostalCode
        string ShipCountry
    }
    Products {
        int ProductID PK
        string ProductName
        int SupplierID FK
        int CategoryID FK
        int QuantityPerUnit
        float UnitPrice
        int UnitsInStock
        int UnitsOnOrder
        int ReorderLevel
        string Discontinued
    }
    Regions {
        int RegionID PK
        string RegionDescription
    }
    Shippers {
        int ShipperID PK
        string CompanyName
        string Phone
    }
    Suppliers {
        int SupplierID PK
        string CompanyName
        string ContactName
        string ContactTitle
        string Address
        string City
        string Region
        string PostalCode
        string Country
        string Phone
        string Fax
        string HomePage
    }
    Territories {
        string TerritoryID PK
        string TerritoryDescription
        int RegionID FK
    }

```

## Views

The following views have been converted from the original Northwind Access database. Please refer to the `src/create.sql` file to view the code behind each of these views.

| View Name |
|-----------|
| [Alphabetical list of products] |
| [Current Product List] |
| [Customer and Suppliers by City] |
| [Invoices] |
| [Orders Qry] |
| [Order Subtotals] |
| [Order Subtotals] |
| [Product Sales for 1997] |
| [Products Above Average Price] |
| [Products by Category] |
| [Quarterly Orders] |
| [Sales Totals by Amount] |
| [Summary of Sales by Quarter] |
| [Summary of Sales by Year] |
| [Category Sales for 1997] |
| [Order Details Extended] |
| [Sales by Category] |

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


# Original ERD Picture

![Northwind ERD Picture](docs/Northwind_ERD.png)
