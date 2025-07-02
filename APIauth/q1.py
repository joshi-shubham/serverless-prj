import requests
import os
url = 'https://httpbin.org/bearer'


try:
    token = os.environ['API_TOKEN']
    headers = {'Authorization': f"Bearers {token}"}
    r = requests.get(url, headers=headers)
    print(r.json())
except Exception as e:
    print(e)