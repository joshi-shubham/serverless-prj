import requests
payload = {'userId': '1'}
try:
    r =  requests.get("https://jsonplaceholder.typicode.com/posts", params=payload)
    if (r.status_code != 200):
        raise Exception("status is",r.status_code)
    posts = r.json()

    # print(posts)  
    for post in posts:
        print(post['title'])
    
except Exception as e:
    print("Cannot connect", e)

