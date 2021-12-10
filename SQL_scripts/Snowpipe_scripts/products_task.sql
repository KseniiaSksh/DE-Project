create or replace stream products_stream on table stage_schema.Products APPEND_ONLY = TRUE;

CREATE
OR REPLACE TASK products_task SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('products_stream') AS
INSERT INTO
    "NORTHWINDDB"."DWH_SCHEMA"."PRODUCTS"(
      ProductID,
      ProductName,
      QuantityPerUnit,
      UNITPRICE,
      REORDERLEVEL,
      DISCONTINUED,
      CATEGORYNAME,
      CATEGORYDESCRIPTION,
      RECORDSTARTDATE
    )
SELECT
      DISTINCT(p.PRODUCTID),
      p.PRODUCTNAME,
      p.QuantityPerUnit,
      p.UNITPRICE,
      p.REORDERLEVEL,
      p.DISCONTINUED,
      c.CATEGORYNAME,
      c.CATEGORYDESCRIPTION,
      p.UPDATEDDATE
FROM
    products_stream p
    LEFT JOIN stage_schema.categories c
    ON p.CategoryID=c.CategoriesID;
ALTER TASK IF EXISTS products_task RESUME;
SHOW TASKS;