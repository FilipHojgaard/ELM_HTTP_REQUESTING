# -*- coding: utf-8 -*-
"""
Created on Tue Nov  6 13:54:20 2018

@author: fih
"""


import requests;
import json;


def debugCreateUser(username, password):
    newdata = {
         "username": username,
         "password": password}
        
    req = requests.post('http://localhost:5000/CreateUser/', json=newdata)
    json_response = json.loads(req.content)
    print(req.content)
    
    
def debugDeleteUser(username):
    newdata = {'username': username}
    
    req = requests.post('http://localhost:5000/DeleteUser/', json=newdata)
    json_response = json.loads(req.content)
    print(req.content)
    
    
def debugCheckUser(username):
    newdata = {'username': username}
    
    req = requests.post('http://localhost:5000/CheckUser/', json=newdata)
    json_response = json.loads(req.content)
    print(req.content)
    

def debugLogin(username, password):
    newdata = {'username': username,
               'password': password}
    
    req = requests.post('http://localhost:5000/Login/', json=newdata)
    json_response = json.loads(req.content)
    print(req.content)

#debugCreateUser("ny", "test")
debugDeleteUser("Filip")    
#debugCheckUser("Filip")
#debugLogin('Filip', '123')
    
    
    
    
    
