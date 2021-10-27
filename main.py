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
        connection = config.getConnection()
        print("Connect successful!")

    except Error as e:
        print("Oh no!", e)

    return connection

    # connection.close()
    # print("Close")


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

get_data_from_tables = f"SELECT * FROM {table_list[0]}"
print(f'Data from table {table_list[0]}')
cursor.execute(get_data_from_tables)
query_result2 = cursor.fetchall()
for row in query_result2:
    print("CategotyID = ", row[0])
    print("CategotyName = ", row[1])
    print("Description = ", row[2])
print("End of Data")


cursor.close()
conn.close()

print('Connection closed')
# Find tables in DB
