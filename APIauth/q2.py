from requests.auth import HTTPBasicAuth
import requests
basic = HTTPBasicAuth('user', 'passwd')
r = requests.get('https://httpbin.org/basic-auth/user/passwd', auth=basic)
print(r.status_code)