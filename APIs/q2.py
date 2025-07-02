import requests
import json
try:
    with open("/workspaces/serverless-prj/APIs/sample_post_data.json", 'r') as file:
        post = json.load(file)
        print(post)
    # payload = {"title": "Interview Practice", "body": "This is a dummy post to practice POST request handling.","userId": 103}
    r = requests.post("https://jsonplaceholder.typicode.com/posts", json=post)
    r.raise_for_status()
    print(r.status_code)
    print(r.text)
except Exception as e:
    print("error:", e)
