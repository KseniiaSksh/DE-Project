CREATE STORAGE INTEGRATION integration_s3
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::646469129050:role/SNOWFLAKE'
  STORAGE_ALLOWED_LOCATIONS = ('s3://delabnortwind/Northwind_csv/');

desc integration integration_s3;

create stage s3stage
url = 's3://delabnortwind/'
storage_integration = INTEGRATION_S3;

create or replace pipe CATEGORIES_PIPE auto_ingest=true as copy into "NORTHWINDDB".STAGE_SCHEMA.categories(
CategoriesID,
CategoryName,
CategoryDescription
)
from(select $1,$2,$3
FROM @"NORTHWINDDB".STAGE_SCHEMA.s3stage )
pattern='.*categories.*.csv'
file_format = 'DE_LAB_CSV';

create or replace pipe CUSTOMERS_PIPE auto_ingest=true as 
copy into "NORTHWINDDB".STAGE_SCHEMA.Customers(
CUSTOMERID,
COMPANYNAME,
CONTACTNAME,
CONTACTTITLE,	
ADDRESS,	
CITY,	
REGION,
POSTALCODE,	
COUNTRY,	
cRECORDSTARTDATE)	                                            
from (select $1,$2,$3,$4,$5,$6,$7,$8,$9, $13
    FROM @"NORTHWINDDB".STAGE_SCHEMA.S3STAGE)
pattern='.*customers.*.csv'
file_format = 'DE_LAB_CSV';

create or replace pipe EMPLOYEES_PIPE auto_ingest=true as 
copy into "NORTHWINDDB".STAGE_SCHEMA.Employees(EmployeeID,
	LastName,
	FirstName,
	Title,
	TitleOfCourtesy,
	BirthDate,
	HireDate,
	Address,
	City,
	Region,
	PostalCode,
	Country,
	Notes,
	ReportsTo,
    eRecordStartDate)
from(select $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$16,$17,$19
    FROM @"NORTHWINDDB".STAGE_SCHEMA.s3stage )
pattern='.*employees.*.csv'
file_format = 'DE_LAB_CSV';

create or replace pipe ORDERDETAILS_PIPE auto_ingest=true as copy into "NORTHWINDDB".STAGE_SCHEMA.ORDERDETAILS(
    ORDERID,
    PRODUCTID,
    UNITPRICE,
    QUANTITY,
    DISCOUNT
)
from(select $1,$2,$3,$4,$5
    FROM @"NORTHWINDDB".STAGE_SCHEMA.s3stage )
pattern='.*order_details.*.csv'
file_format = 'DE_LAB_CSV';

create or replace pipe ORDERS_PIPE auto_ingest=true as copy into "NORTHWINDDB".STAGE_SCHEMA.ORDERS(
    ORDERID,
    CUSTOMERID,
    EMPLOYEEID,
    ORDERDATE,
    REQUIREDDATE,
    SHIPPEDDATE,
    SHIPVIA,
    FREIGHT,
    SHIPNAME,
    SHIPADDRESS,
    SHIPCITY,
    SHIPREGION,
    SHIPPOSTALCODE,
    SHIPCOUNTRY
)
from(select $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14
    FROM @"NORTHWINDDB".STAGE_SCHEMA.s3stage )
pattern='.*orders.*.csv'
file_format = 'DE_LAB_CSV';

create or replace pipe PRODUCTS_PIPE auto_ingest=true as copy into "NORTHWINDDB".stage_schema.Products
from 
(select $1,$2,$3,$4,$5,$6,$9,$10,$11
    FROM @"NORTHWINDDB".STAGE_SCHEMA.s3stage )
pattern='.*products.*.csv'
file_format = 'DE_LAB_CSV';

create or replace pipe SHIPPERS_PIPE auto_ingest=true as copy into "NORTHWINDDB".DWH_SCHEMA.Shippers(
    SHIPPERID,
    COMPANYNAME,
    PHONE
)	                                            
from (select $1,$2,$3
    FROM @"NORTHWINDDB".STAGE_SCHEMA.S3STAGE)
pattern='.*shippers.*.csv'
file_format = 'DE_LAB_CSV';

create or replace pipe SUPPLIERS_PIPE auto_ingest=true as copy into "NORTHWINDDB".STAGE_SCHEMA.Suppliers(
    SUPPLIERID,
    COMPANYNAME,
    CONTACTNAME,
    CONTACTTITLE,	
    ADDRESS,	
    CITY,	
    REGION,
    POSTALCODE,	
    COUNTRY,	
    sRECORDSTARTDATE)	                                            
from (select $1,$2,$3,$4,$5,$6,$7,$8,$9, $13
    FROM @"NORTHWINDDB".STAGE_SCHEMA.S3STAGE)
pattern='.*suppliers.*.csv'
file_format = 'DE_LAB_CSV';
