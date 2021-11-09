create pipe "NORTHWINDDB".DWH_SCHEMA.categories_pipe auto_ingest=true as
copy into "NORTHWINDDB"."DWH_SCHEMA"."PRODUCTS"
from @"NORTHWINDDB".DWH_SCHEMA.DE_LAB_STAGE
file_format = (type = 'CSV');
