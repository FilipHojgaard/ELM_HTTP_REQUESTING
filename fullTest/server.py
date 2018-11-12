# -*- coding: utf-8 -*-
"""
Created on Tue Oct 30 13:54:06 2018

@author: fih
"""

from flask import Flask, request
from flask_restful import Resource, Api
from flask_cors import CORS    
import json
    

app = Flask(__name__)
CORS(app)
api = Api(app)


# REST API FUNCTIONS
class Return1(Resource):
    def get(self):            
        return {'value': 1}
    
class Post1(Resource):
    def post(self):
        a = {"answer": 1}
        some_json = request.get_json()
        print(some_json['question'])
        return a

        
api.add_resource(Return1, '/return1/')
api.add_resource(Post1, '/post1/')

if __name__== '__main__':
    app.run(debug=True)








