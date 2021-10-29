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
access_key = '<insert your access key>'
secret_key = '<insert your secret key>'
