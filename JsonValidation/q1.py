import requests
import json
fields = ['id', 'name', 'email', 'address']
try:
    r = requests.get('https://jsonplaceholder.typicode.com/users/1')
    # print(r.text)
    data = json.loads(r.text)
    # print(data)
    if (not data['id'] or not data['name'] or not data['email'] or  not data['address'] or not data['address']['city'] or not data['address']['zipcode']):
        print("Missing/invalid fields")
    else:
        print("Response is valid")
except Exception as e:
    print("error", e)