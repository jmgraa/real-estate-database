from data import streets
from data import places
import random

for i in range (1, 51):
    result = ""
    number = random.randint(1, 500)
    area = random.randint(20, 500)
    price = random.randint(50000, 1000000)
    negotiable = random.randint(0, 1)

    print("(" + str(i) + ", '" + random.choice(streets) + "', " + str(number) + ", '" + random.choice(places) + "', " + str(area) + ", " + str(price) + ", " + str(negotiable) + "),")