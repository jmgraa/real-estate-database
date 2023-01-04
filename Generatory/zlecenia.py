from data import workers
import random

id_property = []

for i in range (1, 51):
    id_property.append(i)

for i in range (1, 51):
    begin_day = random.randint(1, 28)
    begin_month = random.randint(1, 12)
    begin_year = random.randint(2022, 2023)

    end_day = random.randint(begin_day + 1, 29)
    end_month = random.randint(begin_month, 12)
    end_year = random.randint(begin_year, 2023) 

    if begin_day < 10:
        begin_day = '0' + str(begin_day)

    if begin_month < 10:
        begin_month = '0' + str(begin_month)

    if end_day < 10:
        end_day = '0' + str(end_day)

    if end_month < 10:
        end_month = '0' + str(end_month)

    minute = random.randint(0, 59)
    hour = random.randint(0, 23)

    if minute < 10:
        minute = '0' + str(minute)

    if hour < 10:
        hour = '0' + str(hour)

    begin = f'{begin_year}-{begin_month}-{begin_day} {hour}:{minute}:00'

    minute = random.randint(0, 59)
    hour = random.randint(0, 23)

    if minute < 10:
        minute = '0' + str(minute)

    if hour < 10:
        hour = '0' + str(hour)

    end = f'{end_year}-{end_month}-{end_day} {hour}:{minute}:00'

    property = random.choice(id_property)
    id_property.remove(property)

    result = "(" + str(i) + ", " + str(property) + ", '" + random.choice(workers)[0] + "', " + begin + ", " + end + "),"

    print(result)