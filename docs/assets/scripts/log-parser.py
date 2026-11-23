import re

logfile = "system.log"
pattern = r"failed login"

with open(logfile, 'r') as f:
    for line in f:
        if re.search(pattern, line, re.IGNORECASE):
            print(line.strip())
