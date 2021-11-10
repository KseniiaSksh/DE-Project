import mysql.connector

import boto3
from boto3 import Session

# Connection to db in rds
def getConnectionRDS():

    cnx = mysql.connector.connect(user='xxxxxxxxxx',
                              password='xxxxxxxxxxxxxxx',
                              host='xxxxxxxxxxxxxxxxxx',
                              database='xxxxxxxx')
    return cnx

# Credentials to connect S3
bucket_name = 'xxxxxxxxxxx'
access_key = 'xxxxxxxxxxxxx'
secret_key = 'xxxxxxxxxxxxxxxx'

client_S3 = boto3.client('s3',
                         aws_access_key_id=access_key,
                         aws_secret_access_key=secret_key
)

session = Session(aws_access_key_id=access_key,

                  aws_secret_access_key=secret_key)
