CREATE STORAGE INTEGRATION integration_s3
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::646469129050:role/SNOWFLAKE'
  STORAGE_ALLOWED_LOCATIONS = ('s3://delabnortwind/Northwind_csv/');

desc integration integration_s3;

create stage s3stage
url = 's3://delabnortwind/Northwind_csv/'
storage_integration = INTEGRATION_S3;

CREATE OR REPLACE TABLE stage_schema.Products(
    ProductID int NOT NULL,
    ProductName varchar(40) NOT NULL,
    SupplierID int,
    CategoryID int,
    QuantityPerUnit varchar(20),
    UnitPrice number,
    ReorderLevel smallint,
    Discontinued boolean NOT NULL,
    UpdatedDate timestamp
);

create stream products_stream on table stage_schema.Products;

create pipe "NORTHWINDDB".DWH_SCHEMA.products_pipe auto_ingest=true as
copy into "NORTHWINDDB".stage_schema.Products
from 
(select $1,$2,$3,$4,$5,$6,$9,$10,$11
 FROM @"NORTHWINDDB".DWH_SCHEMA.s3stage )
pattern='.*products.*.csv'
file_format = 'DE_LAB_CSV';

show pipes;

select system$pipe_status('NORTHWINDDB.DWH_SCHEMA.PRODUCTS_PIPE');