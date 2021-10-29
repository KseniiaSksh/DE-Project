
--drop unnecessary tables
DROP TABLE IF EXISTS Territories;
DROP TABLE IF EXISTS Region;
DROP TABLE IF EXISTS Contacts;

ALTER TABLE Shippers 
ADD PRIMARY KEY (ShipperID);

--CUSTOMERS
CREATE OR REPLACE TABLE Customers AS
SELECT CustomerID AS CustomerSK,
    CustomerID,
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
FROM Customers;

ALTER TABLE Customers 
ADD PRIMARY KEY (CustomerSK);

--EMPLOYEES
CREATE OR REPLACE TABLE Employees AS
SELECT EmployeeID AS EmployeeSK,
    EmployeeID,
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
FROM Employees;

ALTER TABLE Employees 
ADD PRIMARY KEY (EmployeeSK);


--SUPPLIERS
CREATE OR REPLACE TABLE Suppliers AS
SELECT SupplierID AS SupplierSK,
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
FROM Suppliers;

ALTER TABLE Suppliers 
ADD PRIMARY KEY (SupplierSK);


--ORDER DETAILS
CREATE TABLE OrderDetails AS
SELECT Orders.OrderID,
    ProductID AS ProductSK,
    CustomerID AS CustomerSK,
    EmployeeID AS EmployeeSK,
    ShipVia AS ShipperID,
    TRY_TO_TIMESTAMP(OrderDate) AS OrderDateKey,
    TRY_TO_TIMESTAMP(RequiredDate) AS RequiredDateKey,
    TRY_TO_TIMESTAMP(ShippedDate) AS ShippedDateKey,
    UnitPrice AS ProductUnitPrice,
    Quantity AS ProductQuantity,
    Discount AS ProductDiscount,
    Freight,
    ShipName,
    ShipAddress,
    ShipCity,
    ShipRegion,
    ShipPostalCode,
    ShipCountry
FROM Orders
JOIN [Order Details] AS od
ON Orders.OrderID = od.OrderId;

ALTER TABLE OrderDetails
ADD FOREIGN KEY (ProductSK) REFERENCES Products(ProductSK);

ALTER TABLE OrderDetails
ADD FOREIGN KEY (CustomerSK) REFERENCES Customers(CustmoerSK);

ALTER TABLE OrderDetails
ADD FOREIGN KEY (EmployeeSK) REFERENCES Employees(EmployeeSK);

ALTER TABLE OrderDetails
ADD FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID);

ALTER TABLE OrderDetails
ADD PRIMARY KEY (OrderID, ProductSK)

--PRODUCTS
CREATE OR REPLACE TABLE Products AS
SELECT ProductID AS ProductSK,
    ProductID,
    ProductName,
    QuantityPerUnit,
    UnitPrice,
    ReorderLevel,
    Discontinued,
    CategoryName,
    Description AS CategoryDescription,
    1 AS CurrentFlag,
    CURRENT_TIMESTAMP(2) AS RecordStartDate,
    CURRENT_TIMESTAMP(2) AS RecordEndDate
FROM Products
JOIN Categories
ON Products.CategoryID = Categories.CategoryID;

ALTER TABLE Products 
ADD PRIMARY KEY (ProductSK);