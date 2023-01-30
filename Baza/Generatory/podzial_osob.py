from data import people
import random

mails = ("gmail.com", "interia.pl", "onet.pl", "wp.pl", "op.pl", "yahoo.com", "outlook.com", "o2.pl")

jobs = ("agent nieruchomości", "doradca klienta", "specjalista ds. nieruchomości", "menedżer ds. nieruchomości", "rzeczoznawca nieruchomości")

clients = []
workers = []

choices = ("client", "worker")

for person in people:
    result = '("' + person[0] + '", "'
    option = random.choice(choices)

    if option == "client":
        result += person[1].lower() + '.' + person[2].lower() + '@' + random.choice(mails) + '"),'
        workers.append(result)
    elif option == "worker":
        result += '0, ' + random.choice(jobs) + '"),'
        workers.append(result)

for client in clients:
    print(client)

print()

for worker in workers:
    print(worker)