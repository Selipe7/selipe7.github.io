ioc_list = ["malicious.com", "192.168.13.37", "e3b0c44298fc"]
with open("logs.txt") as f:
    for line in f:
        if any(ioc in line for ioc in ioc_list):
            print("[MATCH] " + line.strip())
