CREATE
OR REPLACE TABLE Shippers (
    ShipperID int PRIMARY KEY,
    CompanyName varchar(40) NOT NULL,
    Phone varchar(24)
);

CREATE
OR REPLACE TABLE Customers (
    CustomerSK int DEFAULT AUTOINCREMENT(1, 1) PRIMARY KEY,
    CustomerID varchar(5) NOT NULL,
    CompanyName varchar(40) NOT NULL,
    ContactName varchar(30),
    ContactTitle varchar(30),
    Address varchar(60),
    City varchar(15),
    Region varchar(15),
    PostalCode varchar(10),
    Country varchar(15),
    CurrentFlag boolean DEFAULT 1,
    RecordStartDate date DEFAULT CURRENT_DATE(),
    RecordStartDate date DEFAULT CURRENT_DATE()
);

--EMPLOYEES
CREATE
OR REPLACE TABLE Employees (
    EmployeeSK int DEFAULT AUTOINCREMENT(1, 1) PRIMARY KEY,
    EmployeeID int NOT NULL,
    LastName varchar(20) NOT NULL,
    FirstName varchar(10) NOT NULL,
    Title varchar(30),
    TitleOfCourtesy varchar(25),
    BirthDate date,
    HireDate date,
    Address varchar(60),
    City varchar(15),
    Region varchar(15),
    PostalCode varchar(10),
    Country varchar(15),
    Notes text,
    ReportsTo int,
    CurrentFlag boolean DEFAULT 1,
    RecordStartDate date DEFAULT CURRENT_DATE(),
    RecordStartDate date DEFAULT CURRENT_DATE()
);

PRIMARY KEY (EmployeeSK);

--SUPPLIERS
CREATE
OR REPLACE TABLE Suppliers (
    SupplierSK int DEFAULT AUTOINCREMENT(1, 1) PRIMARY KEY,
    SupplierID int NOT NULL,
    CompanyName varchar(40) NOT NULL,
    ContactName varchar(30),
    ContactTitle varchar(30),
    Address varchar(60),
    City varchar(15),
    Region varchar(15),
    PostalCode varchar(10),
    Country varchar(15),
    CurrentFlag boolean DEFAULT 1,
    RecordStartDate date DEFAULT CURRENT_DATE(),
    RecordStartDate date DEFAULT CURRENT_DATE()
);

--ORDER DETAILS
CREATE
OR REPLACE TABLE OrderDetails(
    OrderID int NOT NULL,
    ProductSK int NOT NULL FOREIGN KEY REFERENCES Products(ProductSK),
    CustomerSK int NOT NULL FOREIGN KEY REFERENCES Customers(CustomerSK),
    EmployeeSK int NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeSK),
    ShipperID int NOT NULL FOREIGN KEY REFERENCES Shippers(ShipperID),
    OrderDateKey number(9) FOREIGN KEY REFERENCES DIM_DATE(DATE_PKEY),
    RequiredDateKey number(9) FOREIGN KEY REFERENCES DIM_DATE(DATE_PKEY),
    ShippedDateKey number(9) FOREIGN KEY REFERENCES DIM_DATE(DATE_PKEY),
    ProductUnitPrice number NOT NULL,
    ProductQuantity smallint NOT NULL,
    ProductDiscount real NOT NULL,
    Freight number,
    ShipName varchar(40),
    ShipAddress varchar(60),
    ShipCity varchar(15),
    ShipRegion varchar(15),
    ShipPostalCode varchar(10),
    ShipCountry varchar(15),
    CONSTRAINT compositePK PRIMARY KEY (OrderID, ProductSK);

--PRODUCTS
CREATE
OR REPLACE TABLE Products(
    ProductSK int DEFAULT AUTOINCREMENT(1, 1) PRIMARY KEY,
    ProductID int NOT NULL,
    ProductName varchar(40) NOT NULL,
    QuantityPerUnit varchar(20),
    UnitPrice number,
    ReorderLevel smallint,
    Discontinued boolean NOT NULL,
    CategoryName varchar(15) NOT NULL,
    CategoryDescription text,
    CurrentFlag boolean DEFAULT 1,
    RecordStartDate date DEFAULT CURRENT_DATE(),
    RecordStartDate date DEFAULT CURRENT_DATE()
);