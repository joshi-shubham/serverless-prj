import requests
from dotenv import load_dotenv
import os
import datetime
load_dotenv()

def get_timestamp():
    return datetime.datetime.strftime(datetime.datetime.now(),'%Y-%m-%d %H:%M:%S,%f')
def hide_data(password, authsecret):
    # print(authsecret)
    authsecret = authsecret[0:5]+"******"
    return ['********',authsecret ]

url = "https://httpbin.org/post"
payload = {'username': 'shubham-joshi', 'password': os.getenv('PASSWORD') }
headers = {'Authorization': f"Bearer {os.getenv('TOKEN')}"}
pass_token_flag = True
try:
    if  not os.getenv('PASSWORD') or not os.getenv('TOKEN'):
        pass_token_flag = False
        raise Exception("password or token not set")

    response = requests.post(url, json=payload, headers=headers)
except Exception as e:
    with open('api.log', 'a') as log_file:
        log_file.write(f"{get_timestamp()} - ERROR - {str(e)}\n")
    print (e)
finally:
    if pass_token_flag:
        hidden_pass, hidden_token = hide_data(os.getenv('PASSWORD'), os.getenv('TOKEN'))
        log = "{} - INFO - Status: {}, Time: {}s\n".format(get_timestamp(), response.status_code, response.elapsed.total_seconds() )
        log += "{} - INFO - Payload:{{'username': '{}', 'password': {}}}\n".format(get_timestamp(), payload['username'],hidden_pass )
        log += "{} - INFO - Authorization header: Bearer {}\n".format(get_timestamp(), hidden_token)
        with open('api.log', 'a') as log_file:
            log_file.write(log)