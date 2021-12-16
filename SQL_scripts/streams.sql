create or replace stream ORDERDETAILS_STREAM on table ORDERDETAILS append_only = true;

create or replace stream PRODUCTS_STREAM on table PRODUCTS append_only = true;

create or replace stream CUSTOMERS_STREAM on table CUSTOMERS append_only = true;

create or replace stream EMPLOYEES_STREAM on table EMPLOYEES append_only = true;

create or replace stream SUPPLIERS_STREAM on table SUPPLIERS append_only = true;