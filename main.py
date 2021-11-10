import csv
import time
import os
import config
from mysql.connector import Error

"""
1. Connecting to DB
2. Transfer data from RDS to S3 in csv format
3. Extract all data and only data which were changed
"""


# Connecting to RDS DB
def connection_to_rds():
    connection_db = None
    try:
        connection = config.getConnectionRDS()
        print("Connect successful!")

    except Error as e:
        print("Oh no, something wrong with connection to RDS! ---", e)

    return connection


# Upload csv files to S3 bucket
def upload_file(file_name, bucket, object_name=None, args=None):
    try:
        if object_name is None:
            object_name = file_name

        config.client_S3.upload_file(file_name, bucket, object_name, ExtraArgs=args)
        print(f"'{file_name}' has been uploaded to '{config.bucket_name}'")
    except Error as e:
        print("Can't upload file to S3 bucket!", e)



def copy_all_data_from_table(table):
    try:
        cursor.execute(f'SELECT * FROM {table};')
        rows = cursor.fetchall()

        # Continue only if there are rows returned.
        if rows:

            csv_file = f'{table}_{timestr}.csv'

            # New empty list called 'result'. This will be written to a file.
            result = list()

            # The row name is the first entry for each entity in the description tuple.
            column_names = list()
            for i in cursor.description:
                column_names.append(i[0])

            result.append(column_names)
            for row in rows:
                result.append(row)

            # Write result to file.
            with open(csv_file, 'w', newline='') as csvfile:
                csvwriter = csv.writer(csvfile, delimiter='|', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                for row in result:
                    csvwriter.writerow(row)
            upload_file(csv_file, config.bucket_name)
            # Remove csv which were created on a local machine
            os.remove(csv_file)
            print(f'{table} were successfully copied')
    except Error as e:
        print("Oh no, something wrong with data you want to copy! ---", e)



def copy_new_data_from_table(table, last_copied_date):
    try:

        cursor.execute(f"SELECT * FROM {table} WHERE Updated > STR_TO_DATE('{last_copied_date}', '%Y%m%d-%H%i%s');")
        rows = cursor.fetchall()

        # Continue only if there are rows returned.
        if rows:

            csv_file = f'{table}_{timestr}.csv'

            # New empty list called 'result'. This will be written to a file.
            result = list()

            # The row name is the first entry for each entity in the description tuple.
            column_names = list()
            for i in cursor.description:
                column_names.append(i)

            result.append(column_names)
            for row in rows:
                result.append(row)

            # Write result to file.
            with open(csv_file, 'w', newline='') as csvfile:
                csvwriter = csv.writer(csvfile, delimiter='|', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                for row in result:
                    csvwriter.writerow(row)
            upload_file(csv_file, config.bucket_name)
            # Remove csv which were created on a local machine
            os.remove(csv_file)
            print(f'New updated data in {table}')
        else:
            print('no new data')
    except Error as e:
        print("Oh no, something went wrong with uploading new data! ---", e)


# Define current time
timestr = time.strftime("%Y%m%d-%H%M%S")


# Show files in the bucket
s3 = config.session.resource('s3')
my_bucket = s3.Bucket(config.bucket_name)

# Lists with data(table_name, copied_date) from files in S3
s3_file_name_date = list()
s3_file_name_table = list()

for s3_file in my_bucket.objects.all():
    file_name = s3_file.key

    table_name = file_name[:-20]
    copy_date = file_name[-19:-4]
    s3_file_name_date.append(copy_date)
    s3_file_name_table.append(table_name)

# print(s3_file_name_date)
# print(s3_file_name_table)

# Connecting to RDS(run)
conn = connection_to_rds()
cursor = conn.cursor()

# Check DB and find what tables exist in it
get_tables_name = "SHOW TABLES"

cursor.execute(get_tables_name)
query_result = cursor.fetchall()

# List with tables in DB (RDS)
table_list = []

for table in query_result:
    for i in table:
        table_list.append(i)
# print(table_list)


# Check tables in RDS and files in S3
try:
    for table in range(len(table_list)):
        if table_list[table] in s3_file_name_table:
            # If table from RDS were already copied and exist in S3
            date_when_copied = list()
            for i in range(len(s3_file_name_table)):
                # Fill the list with time when data were copied
                if table_list[table] == s3_file_name_table[i]:
                    date_when_copied.append(s3_file_name_date[i])

            # print(date_when_copied)
            if date_when_copied:
                # Find the last copied time to compare if new data were uploaded to the table from last time when data were copied
                last_copied_date = (max(date_when_copied))
                # print(max(date_when_copied))
                copy_new_data_from_table(table_list[table], last_copied_date)

        else:
            # If table from RDS wasn't copied --> copy it
            # print(f'There is not copy of table : {table_list[table]}')
            copy_all_data_from_table(table_list[table])

except Error as e:
    print("Oh no, some error occur! ---", e)

cursor.close()
conn.close()

print('Connection closed')
