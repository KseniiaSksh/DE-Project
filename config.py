
import mysql.connector

def getConnection():
    cnx = mysql.connector.connect(user='taras',
                              password='taras_smaliukh',
                              host='dbnorthwind.cjgt1chgkycw.eu-central-1.rds.amazonaws.com',
                              database='northwind')
    return cnx
