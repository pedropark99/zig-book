import requests
resp = requests.get("http://127.0.0.1:3490")
print("Status code: ", resp.status_code)
print("Response body: ", resp.content)

