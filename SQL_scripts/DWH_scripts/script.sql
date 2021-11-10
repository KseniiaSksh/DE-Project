CREATE
OR REPLACE TABLE Shippers (
	ShipperID int PRIMARY KEY,
	CompanyName varchar(40) NOT NULL,
	Phone varchar(24)
);

CREATE
OR REPLACE TABLE Customers (
	CustomerSK int IDENTITY(1, 1) PRIMARY KEY,
	CustomerID varchar(5) NOT NULL,
	CompanyName varchar(40) NOT NULL,
	ContactName varchar(30),
	ContactTitle varchar(30),
	Address varchar(60),
	City varchar(15),
	Region varchar(15),
	PostalCode varchar(10),
	Country varchar(15),
	CurrentFlag boolean DEFAULT true,
	RecordStartDate date DEFAULT CURRENT_DATE(),
	RecordEndDate date DEFAULT NULL
);

--EMPLOYEES
CREATE
OR REPLACE TABLE Employees (
	EmployeeSK int AUTOINCREMENT(1, 1) PRIMARY KEY,
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
	CurrentFlag boolean DEFAULT true,
	RecordStartDate date DEFAULT CURRENT_DATE(),
	RecordEndDate date DEFAULT NULL
);

--SUPPLIERS
CREATE
OR REPLACE TABLE Suppliers (
	SupplierSK int AUTOINCREMENT(1, 1) PRIMARY KEY,
	SupplierID int NOT NULL,
	CompanyName varchar(40) NOT NULL,
	ContactName varchar(30),
	ContactTitle varchar(30),
	Address varchar(60),
	City varchar(15),
	Region varchar(15),
	PostalCode varchar(10),
	Country varchar(15),
	CurrentFlag boolean DEFAULT true,
	RecordStartDate date DEFAULT CURRENT_DATE(),
	RecordEndDate date DEFAULT NULL
);

--PRODUCTS
CREATE
OR REPLACE TABLE Products(
	ProductSK int AUTOINCREMENT(1, 1) PRIMARY KEY,
	ProductID int NOT NULL,
	ProductName varchar(40) NOT NULL,
	QuantityPerUnit varchar(20),
	UnitPrice number,
	ReorderLevel smallint,
	Discontinued boolean NOT NULL,
	CategoryName varchar(15) NOT NULL,
	CategoryDescription text,
	CurrentFlag boolean DEFAULT true,
	RecordStartDate date DEFAULT CURRENT_DATE(),
	RecordEndDate date DEFAULT NULL
);

create
or replace table DIM_DATE (
	DATE_PKEY number(9) PRIMARY KEY,
	DATE date not null,
	FULL_DATE_DESC varchar(64) not null,
	DAY_NUM_IN_WEEK number(1) not null,
	DAY_NUM_IN_MONTH number(2) not null,
	DAY_NUM_IN_YEAR number(3) not null,
	DAY_NAME varchar(10) not null,
	DAY_ABBREV varchar(3) not null,
	MONTH_END_IND varchar(64) not null,
	WEEK_BEGIN_DATE_NKEY number(9) not null,
	WEEK_BEGIN_DATE date not null,
	WEEK_END_DATE_NKEY number(9) not null,
	WEEK_END_DATE date not null,
	WEEK_NUM_IN_YEAR number(9) not null,
	MONTH_NAME varchar(10) not null,
	MONTH_ABBREV varchar(3) not null,
	MONTH_NUM_IN_YEAR number(2) not null,
	YEARMONTH varchar(10) not null,
	QUARTER number(1) not null,
	YEARQUARTER varchar(10) not null,
	YEAR number(5) not null,
	SQL_TIMESTAMP timestamp_ntz
);

-- Populate data into DIM_DATE
insert into
	DIM_DATE
select
	DATE_PKEY,
	DATE_COLUMN,
	FULL_DATE_DESC,
	DAY_NUM_IN_WEEK,
	DAY_NUM_IN_MONTH,
	DAY_NUM_IN_YEAR,
	DAY_NAME,
	DAY_ABBREV,
	MONTH_END_IND,
	WEEK_BEGIN_DATE_NKEY,
	WEEK_BEGIN_DATE,
	WEEK_END_DATE_NKEY,
	WEEK_END_DATE,
	WEEK_NUM_IN_YEAR,
	MONTH_NAME,
	MONTH_ABBREV,
	MONTH_NUM_IN_YEAR,
	YEARMONTH,
	CURRENT_QUARTER,
	YEARQUARTER,
	CURRENT_YEAR,
	SQL_TIMESTAMP
from
	(
		select
			to_date('2015-01-01 00:00:01', 'YYYY-MM-DD HH24:MI:SS') as DD,
			/*<<Modify date for preferred table start date*/
			seq1() as Sl,
			row_number() over (
				order by
					Sl
			) as row_numbers,
			dateadd(day, row_numbers, DD) as V_DATE,
			case
				when date_part(dd, V_DATE) < 10
				and date_part(mm, V_DATE) > 9 then date_part(year, V_DATE) || date_part(mm, V_DATE) || '0' || date_part(dd, V_DATE)
				when date_part(dd, V_DATE) < 10
				and date_part(mm, V_DATE) < 10 then date_part(year, V_DATE) || '0' || date_part(mm, V_DATE) || '0' || date_part(dd, V_DATE)
				when date_part(dd, V_DATE) > 9
				and date_part(mm, V_DATE) < 10 then date_part(year, V_DATE) || '0' || date_part(mm, V_DATE) || date_part(dd, V_DATE)
				when date_part(dd, V_DATE) > 9
				and date_part(mm, V_DATE) > 9 then date_part(year, V_DATE) || date_part(mm, V_DATE) || date_part(dd, V_DATE)
			end as DATE_PKEY,
			V_DATE as DATE_COLUMN,
			dayname(dateadd(day, row_numbers, DD)) as DAY_NAME_1,
			case
				when dayname(dateadd(day, row_numbers, DD)) = 'Mon' then 'Monday'
				when dayname(dateadd(day, row_numbers, DD)) = 'Tue' then 'Tuesday'
				when dayname(dateadd(day, row_numbers, DD)) = 'Wed' then 'Wednesday'
				when dayname(dateadd(day, row_numbers, DD)) = 'Thu' then 'Thursday'
				when dayname(dateadd(day, row_numbers, DD)) = 'Fri' then 'Friday'
				when dayname(dateadd(day, row_numbers, DD)) = 'Sat' then 'Saturday'
				when dayname(dateadd(day, row_numbers, DD)) = 'Sun' then 'Sunday'
			end || ', ' || case
				when monthname(dateadd(day, row_numbers, DD)) = 'Jan' then 'January'
				when monthname(dateadd(day, row_numbers, DD)) = 'Feb' then 'February'
				when monthname(dateadd(day, row_numbers, DD)) = 'Mar' then 'March'
				when monthname(dateadd(day, row_numbers, DD)) = 'Apr' then 'April'
				when monthname(dateadd(day, row_numbers, DD)) = 'May' then 'May'
				when monthname(dateadd(day, row_numbers, DD)) = 'Jun' then 'June'
				when monthname(dateadd(day, row_numbers, DD)) = 'Jul' then 'July'
				when monthname(dateadd(day, row_numbers, DD)) = 'Aug' then 'August'
				when monthname(dateadd(day, row_numbers, DD)) = 'Sep' then 'September'
				when monthname(dateadd(day, row_numbers, DD)) = 'Oct' then 'October'
				when monthname(dateadd(day, row_numbers, DD)) = 'Nov' then 'November'
				when monthname(dateadd(day, row_numbers, DD)) = 'Dec' then 'December'
			end || ' ' || to_varchar(dateadd(day, row_numbers, DD), ' dd, yyyy') as FULL_DATE_DESC,
			dateadd(day, row_numbers, DD) as V_DATE_1,
			dayofweek(V_DATE_1) + 1 as DAY_NUM_IN_WEEK,
			Date_part(dd, V_DATE_1) as DAY_NUM_IN_MONTH,
			dayofyear(V_DATE_1) as DAY_NUM_IN_YEAR,
			case
				when dayname(V_DATE_1) = 'Mon' then 'Monday'
				when dayname(V_DATE_1) = 'Tue' then 'Tuesday'
				when dayname(V_DATE_1) = 'Wed' then 'Wednesday'
				when dayname(V_DATE_1) = 'Thu' then 'Thursday'
				when dayname(V_DATE_1) = 'Fri' then 'Friday'
				when dayname(V_DATE_1) = 'Sat' then 'Saturday'
				when dayname(V_DATE_1) = 'Sun' then 'Sunday'
			end as DAY_NAME,
			dayname(dateadd(day, row_numbers, DD)) as DAY_ABBREV,
			case
				when last_day(V_DATE_1) = V_DATE_1 then 'Month-end'
				else 'Not-Month-end'
			end as MONTH_END_IND,
			case
				when date_part(mm, date_trunc('week', V_DATE_1)) < 10
				and date_part(dd, date_trunc('week', V_DATE_1)) < 10 then date_part(yyyy, date_trunc('week', V_DATE_1)) || '0' || date_part(mm, date_trunc('week', V_DATE_1)) || '0' || date_part(dd, date_trunc('week', V_DATE_1))
				when date_part(mm, date_trunc('week', V_DATE_1)) < 10
				and date_part(dd, date_trunc('week', V_DATE_1)) > 9 then date_part(yyyy, date_trunc('week', V_DATE_1)) || '0' || date_part(mm, date_trunc('week', V_DATE_1)) || date_part(dd, date_trunc('week', V_DATE_1))
				when date_part(mm, date_trunc('week', V_DATE_1)) > 9
				and date_part(dd, date_trunc('week', V_DATE_1)) < 10 then date_part(yyyy, date_trunc('week', V_DATE_1)) || date_part(mm, date_trunc('week', V_DATE_1)) || '0' || date_part(dd, date_trunc('week', V_DATE_1))
				when date_part(mm, date_trunc('week', V_DATE_1)) > 9
				and date_part(dd, date_trunc('week', V_DATE_1)) > 9 then date_part(yyyy, date_trunc('week', V_DATE_1)) || date_part(mm, date_trunc('week', V_DATE_1)) || date_part(dd, date_trunc('week', V_DATE_1))
			end as WEEK_BEGIN_DATE_NKEY,
			date_trunc('week', V_DATE_1) as WEEK_BEGIN_DATE,
			case
				when date_part(mm, last_day(V_DATE_1, 'week')) < 10
				and date_part(dd, last_day(V_DATE_1, 'week')) < 10 then date_part(yyyy, last_day(V_DATE_1, 'week')) || '0' || date_part(mm, last_day(V_DATE_1, 'week')) || '0' || date_part(dd, last_day(V_DATE_1, 'week'))
				when date_part(mm, last_day(V_DATE_1, 'week')) < 10
				and date_part(dd, last_day(V_DATE_1, 'week')) > 9 then date_part(yyyy, last_day(V_DATE_1, 'week')) || '0' || date_part(mm, last_day(V_DATE_1, 'week')) || date_part(dd, last_day(V_DATE_1, 'week'))
				when date_part(mm, last_day(V_DATE_1, 'week')) > 9
				and date_part(dd, last_day(V_DATE_1, 'week')) < 10 then date_part(yyyy, last_day(V_DATE_1, 'week')) || date_part(mm, last_day(V_DATE_1, 'week')) || '0' || date_part(dd, last_day(V_DATE_1, 'week'))
				when date_part(mm, last_day(V_DATE_1, 'week')) > 9
				and date_part(dd, last_day(V_DATE_1, 'week')) > 9 then date_part(yyyy, last_day(V_DATE_1, 'week')) || date_part(mm, last_day(V_DATE_1, 'week')) || date_part(dd, last_day(V_DATE_1, 'week'))
			end as WEEK_END_DATE_NKEY,
			last_day(V_DATE_1, 'week') as WEEK_END_DATE,
			week(V_DATE_1) as WEEK_NUM_IN_YEAR,
			case
				when monthname(V_DATE_1) = 'Jan' then 'January'
				when monthname(V_DATE_1) = 'Feb' then 'February'
				when monthname(V_DATE_1) = 'Mar' then 'March'
				when monthname(V_DATE_1) = 'Apr' then 'April'
				when monthname(V_DATE_1) = 'May' then 'May'
				when monthname(V_DATE_1) = 'Jun' then 'June'
				when monthname(V_DATE_1) = 'Jul' then 'July'
				when monthname(V_DATE_1) = 'Aug' then 'August'
				when monthname(V_DATE_1) = 'Sep' then 'September'
				when monthname(V_DATE_1) = 'Oct' then 'October'
				when monthname(V_DATE_1) = 'Nov' then 'November'
				when monthname(V_DATE_1) = 'Dec' then 'December'
			end as MONTH_NAME,
			monthname(V_DATE_1) as MONTH_ABBREV,
			month(V_DATE_1) as MONTH_NUM_IN_YEAR,
			case
				when month(V_DATE_1) < 10 then year(V_DATE_1) || '-0' || month(V_DATE_1)
				else year(V_DATE_1) || '-' || month(V_DATE_1)
			end as YEARMONTH,
			quarter(V_DATE_1) as CURRENT_QUARTER,
			year(V_DATE_1) || '-0' || quarter(V_DATE_1) as YEARQUARTER,
			year(V_DATE_1) as CURRENT_YEAR,
			to_timestamp_ntz(V_DATE) as SQL_TIMESTAMP
		from
			table(generator(rowcount = > 8401))
			/*<< Set to generate 20 years. Modify rowcount to increase or decrease size*/
	) v;

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
	CONSTRAINT compositePK PRIMARY KEY (OrderID, ProductSK)
);