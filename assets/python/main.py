import os
from time import sleep

result_filename = os.getenv("RESULT_FILENAME")
result_value = os.getenv("RESULT_VALUE")
r = ""

if not result_filename:
    r = "No result filename provided"
    exit(1)

if result_value:
    r = result_value
else:
    r = "No result value provided"


with open(result_filename, "w") as f:
    f.write(r)
