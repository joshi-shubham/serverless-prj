import requests
from dotenv import load_dotenv
import os
import logging
load_dotenv()

def hide_data(password, authsecret):
    # print(authsecret)
    authsecret = authsecret[0:5]+"******"
    return ['********',authsecret ]

logging.basicConfig(filename='app.log', filemode='a', level=logging.INFO, format = '%(asctime)s - %(levelname)s - %(message)s')
token = os.getenv('TOKEN')
password = os.getenv('PASSWORD')
url = "https://httpbin.org/post"
payload = {'username': 'shubham-joshi', 'password': password }
headers = {'Authorization': f"Bearer {token}"}
request_flag = True
try:
    if  not os.getenv('PASSWORD') or not os.getenv('TOKEN'):
        raise Exception("password or token not set")

    response = requests.post(url, json=payload, headers=headers)
except Exception as e:
    request_flag= False
    logging.error(f"Request Failed: {e}")

    # print (e)
finally:
    if request_flag:
        hidden_pass, hidden_token = hide_data(password, token)
        logging.info("Status: {}, Time: {}s".format( response.status_code, response.elapsed.total_seconds() ))
        logging.info("Payload:{{'username': '{}', 'password': {}}}".format(payload['username'],hidden_pass))
        logging.info("Authorization header: Bearer {}".format(hidden_token))