import mysql.connector

import boto
import boto.s3.connection

# Connection to db on rds
def getConnectionRDS():
    cnx = mysql.connector.connect(user='taras',
                              password='taras_smaliukh',
                              host='dbnorthwind.cjgt1chgkycw.eu-central-1.rds.amazonaws.com',
                              database='northwind')
    return cnx

# Credentials to connect S3
bucket_name = 'delabnortwind'
access_key = 'AKIAZNBEQCNNE3EWRMMG'
secret_key = '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'