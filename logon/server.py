# -*- coding: utf-8 -*-
"""
Created on Tue Oct 30 13:54:06 2018

@author: fih
"""

from flask import Flask, request
from flask_restful import Resource, Api
try:
    import mysqlAPI
except:
    print("DID NOT IMPORT mysqlAPI")
from flask_cors import CORS    
    

app = Flask(__name__)
CORS(app)
api = Api(app)



# REST API FUNCTIONS
class CreateUser(Resource):
    def post(self):
        some_json = request.get_json()
        try:
            mysqlAPI.newUser(some_json['username'], some_json['password'])
        except:
            print("Could not create user")
            pass
            
        return some_json, 201
    
class DeleteUser(Resource):
    def post(self):
        some_json = request.get_json()
        try:
            mysqlAPI.deleteUser(some_json['username'])
        except:
            print("Could not delete user")
            pass
                 
        return some_json, 201
    
class CheckUser(Resource):
    def post(self):
        some_json = request.get_json()
        try:
            return mysqlAPI.CheckUser(some_json['username'])
        except:
            print("Could not check if user existed")
    
class Login(Resource):
    def post(self):
        success = {"response": 1}
        failure = {"response": 0}
        some_json = request.get_json()
        clientUsername = some_json['username']
        clientPassword = some_json['password']
        try:
            if (mysqlAPI.Login(clientUsername, clientPassword) == 1): 
                return success
            else:
                return failure
        except: 
            print("Could not login. Connection error")

    
api.add_resource(CreateUser, '/CreateUser/')
api.add_resource(DeleteUser, '/DeleteUser/')
api.add_resource(CheckUser, '/CheckUser/')
api.add_resource(Login, '/Login/')

if __name__== '__main__':
    app.run(debug=True)








