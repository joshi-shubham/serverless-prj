import json

data = '{"user": {"id": 101, "name": "Jessica", "email": "jessica@example.com" }}'
try:
    parsed_data = json.loads(data)
    print("Name: ",parsed_data['user']['name'])
    print("email: ",parsed_data['user']['email'])
except json.JSONDecodeError as e:
    print("There was an error when loading the json data:", e)
except Exception as e:
    print("There was an error when loading the json data:", e)