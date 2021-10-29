--drop unnecessary tables
DROP TABLE IF EXISTS Territories;

DROP TABLE IF EXISTS Region;

DROP TABLE IF EXISTS Contacts;

ALTER TABLE
    Shippers
ADD
    PRIMARY KEY (ShipperID);

--CUSTOMERS
CREATE
OR REPLACE TABLE Customers AS
SELECT
    CustomerID AS CustomerSK,
    CustomerID
    CompanyName,
    ContactName,
    ContactTitle,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    1 AS CurrentFlag,
    CURRENT_TIMESTAMP(2) AS RecordStartDate,
    CURRENT_TIMESTAMP(2) AS RecordEndDate
FROM
    Customers;

ALTER TABLE
    Customers
ADD
    PRIMARY KEY (CustomerSK);

--EMPLOYEES
CREATE
OR REPLACE TABLE Employees AS
SELECT
    TRY_TO_NUMBER(EmployeeID) AS EmployeeSK,
    TRY_TO_NUMBER(EmployeeID) AS EmployeeID,
    LastName,
    FirstName,
    Title,
    TitleOfCourtesy,
    TRY_TO_DATE(BirthDate),
    TRY_TO_DATE(HireDate),
    Address,
    City,
    Region,
    PostalCode,
    Country,
    Notes,
    ReportsTo,
    1 AS CurrentFlag,
    CURRENT_TIMESTAMP(2) AS RecordStartDate,
    CURRENT_TIMESTAMP(2) AS RecordEndDate
FROM
    Employees;

ALTER TABLE
    Employees
ADD
    PRIMARY KEY (EmployeeSK);

--SUPPLIERS
CREATE
OR REPLACE TABLE Suppliers AS
SELECT
    SupplierID AS SupplierSK,
    SupplierID,
    CompanyName,
    ContactName,
    ContactTitle,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    1 AS CurrentFlag,
    CURRENT_TIMESTAMP(2) AS RecordStartDate,
    CURRENT_TIMESTAMP(2) AS RecordEndDate
FROM
    Suppliers;

ALTER TABLE
    Suppliers
ADD
    PRIMARY KEY (SupplierSK);

--ORDER DETAILS
CREATE TABLE OrderDetails AS
SELECT
    TRY_TO_NUMBER(Orders.OrderID) AS OrderID,
    TRY_TO_NUMBER(ProductID) AS ProductSK,
    CustomerID AS CustomerSK,
    TRY_TO_NUMBER(EmployeeID) AS EmployeeSK,
    TRY_TO_NUMBER(ShipVia) AS ShipperID,
    TRY_TO_DATE(OrderDate) AS OrderDateKey,
    TRY_TO_DATE(RequiredDate) AS RequiredDateKey,
    TRY_TO_DATE(ShippedDate) AS ShippedDateKey,
    TRY_TO_NUMBER(UnitPrice) AS ProductUnitPrice,
    TRY_TO_NUMBER(Quantity) AS ProductQuantity,
    TRY_TO_NUMBER(Discount) AS ProductDiscount,
    TRY_TO_NUMBER(Freight) AS Freight,
    ShipName,
    ShipAddress,
    ShipCity,
    ShipRegion,
    ShipPostalCode,
    ShipCountry
FROM
    Orders
    JOIN [Order Details] AS od ON Orders.OrderID = od.OrderId;

ALTER TABLE
    OrderDetails
ADD
    FOREIGN KEY (ProductSK) REFERENCES Products(ProductSK);

ALTER TABLE
    OrderDetails
ADD
    FOREIGN KEY (CustomerSK) REFERENCES Customers(CustmoerSK);

ALTER TABLE
    OrderDetails
ADD
    FOREIGN KEY (EmployeeSK) REFERENCES Employees(EmployeeSK);

ALTER TABLE
    OrderDetails
ADD
    FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID);

ALTER TABLE
    OrderDetails
ADD
    PRIMARY KEY (OrderID, ProductSK);

--PRODUCTS
CREATE
OR REPLACE TABLE Products AS
SELECT
    TRY_TO_NUMBER(ProductID) AS ProductSK,
    TRY_TO_NUMBER(ProductID) AS ProductID,
    ProductName,
    TQuantityPerUnit),
    TRY_TO_NUMBER(UnitPrice) AS UnitPrice,
    RY_TO_NUMBER(ReorderLevel) AS ReorderLevel,
    Discontinued,
    CategoryName,
    Description AS CategoryDescription,
    1 AS CurrentFlag,
    CURRENT_TIMESTAMP(2) AS RecordStartDate,
    CURRENT_TIMESTAMP(2) AS RecordEndDate
FROM
    Products
    JOIN Categories ON Products.CategoryID = Categories.CategoryID;

ALTER TABLE
    Products
ADD
    PRIMARY KEY (ProductSK);

CREATE TABLE DateDimension