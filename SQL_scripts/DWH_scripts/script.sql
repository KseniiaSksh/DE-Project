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

create or replace TABLE DIM_DATE (
	DATE DATE NOT NULL,
	FULL_DATE_DESC VARCHAR(64) NOT NULL,
	DAY_NUM_IN_WEEK NUMBER(1,0) NOT NULL,
	DAY_NUM_IN_MONTH NUMBER(2,0) NOT NULL,
	DAY_NUM_IN_YEAR NUMBER(3,0) NOT NULL,
	DAY_NAME VARCHAR(10) NOT NULL,
	DAY_ABBREV VARCHAR(3) NOT NULL,
	MONTH_END_IND VARCHAR(64) NOT NULL,
	WEEK_BEGIN_DATE_NKEY NUMBER(9,0) NOT NULL,
	WEEK_BEGIN_DATE DATE NOT NULL,
	WEEK_END_DATE_NKEY NUMBER(9,0) NOT NULL,
	WEEK_END_DATE DATE NOT NULL,
	WEEK_NUM_IN_YEAR NUMBER(9,0) NOT NULL,
	MONTH_NAME VARCHAR(10) NOT NULL,
	MONTH_ABBREV VARCHAR(3) NOT NULL,
	MONTH_NUM_IN_YEAR NUMBER(2,0) NOT NULL,
	YEARMONTH VARCHAR(10) NOT NULL,
	QUARTER NUMBER(1,0) NOT NULL,
	YEARQUARTER VARCHAR(10) NOT NULL,
	YEAR NUMBER(5,0) NOT NULL,
	SQL_TIMESTAMP TIMESTAMP_NTZ(9),
	primary key (date)
);

insert into
	DIM_DATE
select
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
			to_date('1990-01-01 00:00:01', 'YYYY-MM-DD HH24:MI:SS') as DD,
			--start date
			seq1() as Sl,
			row_number() over (
				order by
					Sl
			) as row_numbers,
			dateadd(day, row_numbers, DD) as V_DATE,
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
            --day of the week, month, date, year
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
			end as WEEK_BEGIN_DATE_NKEY, --date of the first day of the week as number
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
			end as WEEK_END_DATE_NKEY,--date of the last day of the week as number
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
			end as YEARMONTH, -- month and year of that day without date
			quarter(V_DATE_1) as CURRENT_QUARTER,--number of the quarter
			year(V_DATE_1) || '-0' || quarter(V_DATE_1) as YEARQUARTER,--year and number of the quarter
			year(V_DATE_1) as CURRENT_YEAR,
			to_timestamp_ntz(V_DATE) as SQL_TIMESTAMP
		from
			table(generator(rowcount => 25203))
		 -- Set to generate 60 years
	) v;
--ORDER DETAILS
create or replace TABLE ORDERDETAILS (
	ORDERID NUMBER(38,0) NOT NULL,
	PRODUCTSK NUMBER(38,0) NOT NULL,
	CUSTOMERSK NUMBER(38,0) NOT NULL,
	EMPLOYEESK NUMBER(38,0) NOT NULL,
    SUPPLIERSK NUMBER(38,0) NOT NULL,
	SHIPPERID NUMBER(38,0) NOT NULL,
	ORDERDATEKEY NUMBER(9,0),
	REQUIREDDATEKEY NUMBER(9,0),
	SHIPPEDDATEKEY NUMBER(9,0),
	PRODUCTUNITPRICE NUMBER(38,0) NOT NULL,
	PRODUCTQUANTITY NUMBER(38,0) NOT NULL,
	PRODUCTDISCOUNT FLOAT NOT NULL,
	FREIGHT NUMBER(38,0),
	SHIPNAME VARCHAR(40),
	SHIPADDRESS VARCHAR(60),
	SHIPCITY VARCHAR(15),
	SHIPREGION VARCHAR(15),
	SHIPPOSTALCODE VARCHAR(10),
	SHIPCOUNTRY VARCHAR(15),
	constraint COMPOSITEPK primary key (ORDERID, PRODUCTSK),
	foreign key (PRODUCTSK) references NORTHWINDDB.DWH_SCHEMA.PRODUCTS(PRODUCTSK),
	foreign key (SHIPPERID) references NORTHWINDDB.DWH_SCHEMA.SHIPPERS(SHIPPERID)
);
