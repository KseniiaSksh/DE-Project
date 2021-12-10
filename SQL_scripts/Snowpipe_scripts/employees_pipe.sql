create or replace pipe "NORTHWINDDB".DWH_SCHEMA.employees_pipe auto_ingest=true as
copy into "NORTHWINDDB".DWH_SCHEMA.Employees(EmployeeID,
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
    RecordStartDate)
from(select $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$16,$17,$19
FROM @"NORTHWINDDB".DWH_SCHEMA.s3stage )
pattern='.*employees.*.csv'
file_format = 'DE_LAB_CSV';
