import random

rodzaje_zabudowy = ("wolnostojący", "bliźniak", "szeregowiec", "gospodarstwo", "letniskowy")

rodzaje_ogrzewania = ("gaz", "prąd", "sieć miejska", "paliwo stałe")

rodzaj_bloku = ("blok", "kamienica", "apartamentowiec")

rodzaje_działek = ("rekreacyjna", "budowlana", "rolna", "leśna", "inwestycjyjna", "siedliskowa", "ogródek działkowy")

domy = []
mieszkania = []
dzialki = []

for i in range (1, 51):
    number = random.randint(1, 3)

    if number == 1:
        result = '(' + str(i) + ', "' + random.choice(rodzaje_zabudowy) + '", ' + str(random.randint(3, 10)) + ', "' + random.choice(rodzaje_ogrzewania) + '"),'
        domy.append(result)
    elif number == 2:
        result = '(' + str(i) + ', "' + random.choice(rodzaj_bloku) + '", ' + str(random.randint(0, 10)) + ', ' + str(random.randint(0, 1)) + ', ' + str(random.randint(0, 1)) + '),'
        mieszkania.append(result)
    elif number == 3:
        result = '(' + str(i) + ', "' + random.choice(rodzaje_działek) + '", ' + str(random.randint(0, 1)) + ', ' + str(random.randint(0, 1)) + ', ' + str(random.randint(0, 1)) + ', ' + str(random.randint(0, 1)) + '),'
        dzialki.append(result)

for dom in domy:
    print(dom)

print()

for mieszkanie in mieszkania:
    print(mieszkanie)

print()

for dzialka in dzialki:
    print(dzialka)