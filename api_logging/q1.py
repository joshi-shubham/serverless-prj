import requests
import logging
import random
error_codes = [ 500]
logging.basicConfig(filename='log.log', filemode='a', level=logging.INFO, format = '%(asctime)s - %(levelname)s - %(message)s')
logging.info("here")

count_500 = 0

status_dict = {200: logging.info(f"Request to /status/{choice} succeeded),
               400:"Bad Request",
               401:"Unauthorized",
               500:" failed after 3 retries"}



    
        
        
choice = random.choice(error_codes)
url = 'https://httpbin.org/status/'+ str(choice)
try:
    response = requests.get(url)
    # print(response.status_code)
    if response.status_code == 200:
        )
        
    elif response.status_code == 400:
        logging.warning(f"request to /status/{choice} failed: Bad Request.")
    elif response.status_code ==401:
        logging.warning(f"request to /status/{choice} failed: Unauthorized.")
    elif response.status_code == 500:
        for i in range(3):
            response = requests.get(url)
            if response.status_code == 
except Exception as e:
    print("error",e)
