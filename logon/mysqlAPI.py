# -*- coding: utf-8 -*-
"""
Created on Tue Oct 23 12:57:07 2018

@author: fih
"""

import mysql.connector

mydb = mysql.connector.connect(             # Open connection to the database.
        host="localhost",
        user="root",
        passwd="",
        database='ny'
        )

    
def newUser(username, password):
    mycursor = mydb.cursor(buffered=True)
    mycursor.execute("INSERT INTO users (username, password) VALUES ('{}','{}')".format(username, password))
    mycursor.close()
    mydb.commit()
    
def deleteUser(username):
    mycursor = mydb.cursor(buffered=True)
    mycursor.execute("DELETE FROM users WHERE username = '{}'".format(username))
    mycursor.close()
    mydb.commit()
    
def CheckUser(username):
    dataArray = []
    mycursor = mydb.cursor(buffered=True)
    mycursor.execute("SELECT * FROM users WHERE username = '{}'".format(username))
    data = mycursor
    mycursor.close()
    mydb.commit()
    for x in data:
        dataArray.append(x)
    if dataArray == []:
        return 0
    else:
        return 1
    
def Login(username, password):
    dataArray = []
    mycursor = mydb.cursor(buffered=True)
    mycursor.execute("SELECT * FROM users WHERE username = '{}' AND password = '{}'".format(username, password))
    data = mycursor
    mycursor.close()
    for x in data:
        dataArray.append(x)
    if (dataArray != []):
        if ((username == dataArray[0][0]) & (password == dataArray[0][1])):
            print("login succesfull")
            return 1
        else:
            print("FAIL: Case Sensitive")
            return 0
    else:
        print("FAILED to login")
        return 0
    
#newUser("Filip", "123")
#deleteUser("Filip")
#print(CheckUser("Filip"))
#Login("Filip", "123")