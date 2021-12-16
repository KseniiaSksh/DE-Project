CREATE
OR REPLACE PROCEDURE customer_sp() 
RETURNS string 
LANGUAGE javascript 
AS 
$$ 

snowflake.execute (
    { sqlText: `BEGIN TRANSACTION;` });
    
snowflake.execute (
    { sqlText: `update NORTHWINDDB.DWH_SCHEMA.CUSTOMERS cust
set CCURRENTFLAG = FALSE,
    CRECORDENDDATE = st.CRECORDSTARTDATE
from  NORTHWINDDB.STAGE_SCHEMA.CUSTOMERS_STREAM as st
where cust.CustomerID = st.CustomerID 
    and cust.CRECORDSTARTDATE < st.CRECORDSTARTDATE
    and cust.CRECORDENDDATE is null;` });
    
snowflake.execute (
    { sqlText: `insert into NORTHWINDDB.DWH_SCHEMA.CUSTOMERS(
    CUSTOMERSK,
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
select
    CUSTOMERSK,
    CUSTOMERID,
    COMPANYNAME,
    CONTACTNAME,
    CONTACTTITLE,	
    ADDRESS,	
    CITY,	
    REGION,
    POSTALCODE,	
    COUNTRY,	
    cRECORDSTARTDATE
from NORTHWINDDB.STAGE_SCHEMA.CUSTOMERS_STREAM;` });
    
snowflake.execute (
    { sqlText: `COMMIT;` });

$$;

CREATE
OR REPLACE TASK customers_task SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('customers_stream') 
AS CALL CUSTOMER_SP();

ALTER TASK IF EXISTS customers_task RESUME;
ALTER TASK IF EXISTS customers_task SUSPEND;
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
CREATE
OR REPLACE PROCEDURE EMPLOYEE_SP() 
RETURNS string 
LANGUAGE javascript 
AS 
$$ 

snowflake.execute (
    { sqlText: `BEGIN TRANSACTION;` });
    
snowflake.execute (
    { sqlText: `update NORTHWINDDB.DWH_SCHEMA.EMPLOYEES emp
set eCURRENTFLAG = FALSE,
    eRECORDENDDATE = st.eRECORDSTARTDATE
from  NORTHWINDDB.STAGE_SCHEMA.EMPLOYEES_STREAM as st
where emp.EMPLOYEEID = st.EMPLOYEEID 
    and emp.eRECORDSTARTDATE < st.eRECORDSTARTDATE
    and emp.eRECORDENDDATE is null;` });
    
snowflake.execute (
    { sqlText: `insert into NORTHWINDDB.DWH_SCHEMA.EMPLOYEES(
    EMPLOYEESK,
    EmployeeID,
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
select
    EMPLOYEESK,
    EmployeeID,
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
    eRecordStartDate
from NORTHWINDDB.STAGE_SCHEMA.EMPLOYEES_STREAM;` });
    
snowflake.execute (
    { sqlText: `COMMIT;` });

$$;

CREATE
OR REPLACE TASK EMPLOYEES_TASK SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('EMPLOYEES_STREAM') 
AS CALL EMPLOYEE_SP();

ALTER TASK IF EXISTS EMPLOYEES_task RESUME;
ALTER TASK IF EXISTS EMPLOYEES_task SUSPEND;
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
CREATE
OR REPLACE PROCEDURE SUPPLIER_SP() 
RETURNS string 
LANGUAGE javascript 
AS 
$$ 

snowflake.execute (
    { sqlText: `BEGIN TRANSACTION;` });
    
snowflake.execute (
    { sqlText: `update NORTHWINDDB.DWH_SCHEMA.SUPPLIERS sup
set sCURRENTFLAG = FALSE,
    sRECORDENDDATE = st.sRECORDSTARTDATE
from  NORTHWINDDB.STAGE_SCHEMA.SUPPLIERS_STREAM as st
where sup.SUPPLIERID = st.SUPPLIERID 
    and sup.sRECORDSTARTDATE < st.sRECORDSTARTDATE
    and sup.sRECORDENDDATE is null;` });
    
snowflake.execute (
    { sqlText: `insert into NORTHWINDDB.DWH_SCHEMA.SUPPLIERS(
    SUPPLIERSK,
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
select
    SUPPLIERSK,
    SUPPLIERID,
    COMPANYNAME,
    CONTACTNAME,
    CONTACTTITLE,	
    ADDRESS,	
    CITY,	
    REGION,
    POSTALCODE,	
    COUNTRY,	
    sRECORDSTARTDATE
from NORTHWINDDB.STAGE_SCHEMA.SUPPLIERS_STREAM;` });
    
snowflake.execute (
    { sqlText: `COMMIT;` });

$$;

CREATE
OR REPLACE TASK SUPPLIERS_TASK SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('SUPPLIERS_STREAM') 
AS CALL SUPPLIER_SP();

ALTER TASK IF EXISTS SUPPLIERS_task RESUME;
ALTER TASK IF EXISTS SUPPLIERS_task SUSPEND;
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
CREATE
OR REPLACE PROCEDURE PRODUCT_SP() 
RETURNS string 
LANGUAGE javascript 
AS 
$$ 

snowflake.execute (
    { sqlText: `BEGIN TRANSACTION;` });
    
snowflake.execute (
    { sqlText: `update NORTHWINDDB.DWH_SCHEMA.PRODUCTS prod
set pCURRENTFLAG = FALSE,
    pRECORDENDDATE = st.pRECORDSTARTDATE
from  NORTHWINDDB.STAGE_SCHEMA.PRODUCTS_STREAM as st
where prod.PRODUCTID = st.PRODUCTID 
    and prod.pRECORDSTARTDATE < st.pRECORDSTARTDATE
    and prod.pRECORDENDDATE is null;` });
    
snowflake.execute (
    { sqlText: `INSERT INTO
    "NORTHWINDDB"."DWH_SCHEMA"."PRODUCTS"(
      ProductID,
      ProductName,
      QuantityPerUnit,
      UNITPRICE,
      REORDERLEVEL,
      DISCONTINUED,
      CATEGORYNAME,
      CATEGORYDESCRIPTION,
      pRECORDSTARTDATE
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
      p.pRECORDSTARTDATE
FROM
    products_stream p
    LEFT JOIN stage_schema.categories c
    ON p.CategoryID=c.CategoriesID;` });
    
snowflake.execute (
    { sqlText: `COMMIT;` });

$$;

CREATE
OR REPLACE TASK PRODUCTS_TASK SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('PRODUCTS_STREAM') 
AS CALL PRODUCT_SP();

ALTER TASK IF EXISTS PRODUCTS_task RESUME;
ALTER TASK IF EXISTS PRODUCTS_task SUSPEND;
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
create or replace task ORDERDETAILS_TASK
	schedule='1 minute'
	when SYSTEM$STREAM_HAS_DATA('orderdetails_stream')
	as INSERT INTO
       "NORTHWINDDB"."DWH_SCHEMA"."ORDERDETAILS"(
         ORDERID,
         PRODUCTSK,
         CUSTOMERSK,
         EMPLOYEESK,
         SUPPLIERSK,
         SHIPPERID,
         ORDERDATE,
         REQUIREDDATE,
         SHIPPEDDATE,
         PRODUCTUNITPRICE,
         PRODUCTQUANTITY,
         PRODUCTDISCOUNT,
         FREIGHT,
         SHIPNAME,
         SHIPADDRESS,
         SHIPCITY,
         SHIPREGION,
         SHIPPOSTALCODE,
         SHIPCOUNTRY
       )
       
SELECT
        od.ORDERID,
        PRODUCTSK,
        CUSTOMERSK,
        EMPLOYEESK,
        SUPPLIERSK,
        SHIPVIA,
        ORDERDATE,
        REQUIREDDATE,
        SHIPPEDDATE,
        od.UNITPRICE,
        QUANTITY,
        DISCOUNT,
        FREIGHT,
        SHIPNAME,
        SHIPADDRESS,
        SHIPCITY,
        SHIPREGION,
        SHIPPOSTALCODE,
        SHIPCOUNTRY
FROM "NORTHWINDDB"."STAGE_SCHEMA".orderdetails_stream as od
JOIN "NORTHWINDDB"."DWH_SCHEMA"."PRODUCTS" as pd
    ON od.ProductID = pd.ProductID and pCurrentFlag=TRUE
JOIN "NORTHWINDDB"."STAGE_SCHEMA"."PRODUCTS" ps
    ON od.ProductID = ps.ProductID
JOIN "NORTHWINDDB"."DWH_SCHEMA"."SUPPLIERS" sup
    ON ps.SupplierID = sup.SupplierID and ps.ProductID = od.ProductID and sCurrentFlag=TRUE
JOIN "NORTHWINDDB"."STAGE_SCHEMA"."ORDERS" as ord
    ON od.OrderId = ord.OrderId
JOIN "NORTHWINDDB"."DWH_SCHEMA"."EMPLOYEES" as emp
    ON ord.EmployeeID = emp.EmployeeID and eCurrentFlag=TRUE
JOIN "NORTHWINDDB"."DWH_SCHEMA"."CUSTOMERS" cust
    ON ord.CustomerID = cust.CustomerID and cCurrentFlag=TRUE;
    
ALTER TASK IF EXISTS ORDERDETAILS_TASK RESUME;
ALTER TASK IF EXISTS ORDERDETAILS_TASK SUSPEND;
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
