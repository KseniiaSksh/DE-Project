import csv
import io
import pandas as pd
import boto
import os
import boto3
import s3fs as s3fs
from boto3 import Session

import config

import mysql.connector
from mysql.connector import Error
import re

"""
1. Connecting to DB
2. Transfer data from RDS to S3 in csv format
3. Extract all data and only data which were changed
"""


# Connecting to DB
def connection_to_db():
    connection_db = None
    try:
        connection = config.getConnectionRDS()
        print("Connect successful!")

    except Error as e:
        print("Oh no!", e)

    return connection


def upload_file(file_name, bucket, object_name=None, args=None):
    if object_name is None:
        object_name = file_name

    client_S3.upload_file(file_name, bucket, object_name, ExtraArgs=args)
    print(f"'{file_name}' has been uploaded to '{config.bucket_name}'")

conn = connection_to_db()
cursor = conn.cursor()
get_tables_name = "SHOW TABLES"

cursor.execute(get_tables_name)
query_result = cursor.fetchall()
table_list = []

for table in query_result:
    for i in table:
        table_list.append(i)
print(table_list)

client_S3 = boto3.client(
    's3',
    aws_access_key_id = config.access_key,
    aws_secret_access_key = config.secret_key
)

session = Session(aws_access_key_id=config.access_key,
                  aws_secret_access_key=config.secret_key)
s3 = session.resource('s3')
your_bucket = s3.Bucket(config.bucket_name)

## Show files in the bucket
# for s3_file in your_bucket.objects.all():
#     print(s3_file.key)


try:
    cursor.execute(f"SELECT * FROM {table_list[1]};")
    rows = cursor.fetchall()
finally:
    conn.close()

# Continue only if there are rows returned.

csv_file = f'{table_list[1]}_actualdate.csv'

s3 = s3fs.S3FileSystem(anon=False)


if rows:
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
        csvwriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for row in result:
            csvwriter.writerow(row)
        upload_file(csv_file, config.bucket_name)


cursor.close()
conn.close()

print('Connection closed')
# Find tables in DB
