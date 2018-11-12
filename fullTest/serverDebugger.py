# -*- coding: utf-8 -*-
"""
Created on Mon Nov 12 10:34:32 2018

@author: fih
"""

import requests
import json


def postTest(jsonToPost):
    req = requests.post('http://localhost:5000/post1/', json=jsonToPost)
    json_response = json.loads(req.content)
    print(json_response)
    


data = {"question": "is"}

data2 = json.dumps(data)

postTest(data2)
    
    
    
    
    
