import re
import pandas as pd
m =  re.match(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$', "seee@gmai.com" )
if m:
    print("match")
else:
    print("not match")