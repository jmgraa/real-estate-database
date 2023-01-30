import random
import string

for i in range(0, 35):
    result = ", \""
    for j in range (0, 9):
        result += random.choice(string.digits)
    result += "\""
    print(result)