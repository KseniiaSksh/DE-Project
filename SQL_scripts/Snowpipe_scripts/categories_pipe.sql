create or replace pipe "NORTHWINDDB".STAGE_SCHEMA.categories_pipe 
auto_ingest=true 
as
copy into "NORTHWINDDB".STAGE_SCHEMA.categories(
CategoriesID,
CategoryName,
CategoryDescription
)
from(select $1,$2,$3
FROM @"NORTHWINDDB".DWH_SCHEMA.s3stage )
pattern='.*categories.*.csv'
file_format = 'DE_LAB_CSV';

//stage_table
create or replace table categories(
CategoriesID int,
CategoryName varchar(40) NOT NULL,
CategoryDescription varchar(100) NOT NULL)
