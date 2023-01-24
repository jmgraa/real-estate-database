--Testowanie 

EXEC DodajOpinię '22110855460',18, 10 ,'Wszystko super!'
EXEC DodajOpinię '22110855460',18, 11 ,'Zbyt wysoka ocena'
EXEC DodajOpinię '22110855460',18, 10 ,'Dodanie opini jeszcze raz'

Exec ZakupNieruchomości 2, '31072069990'

EXEC ZakupNieruchomości 45,'24102948963'
/*/ Proba zakupu nieruchomosci ze sprzedane */


EXEC DodajNieruchomość 'mieszkanie','Aleja Kijowska', 37 , 'Kraków', 61,542000, 0 , 'apartament' , NULL , NULL , NULL, 2 , 1 , 1 , 1 , NULL, NULL, NULL,NULL
EXEC DodajNieruchomość 'mieszkanie','Aleja Kijowska', 37 , 'Kraków', 80,420000, 0 , 'apartament' , NULL , NULL , NULL, 3 , 1 , 1 , 1 , NULL, NULL, NULL,NULL
EXEC DodajOgłoszenie 52, '2023-05-01'
EXEC DodajOgłoszenie 53, '2024-01-02'
/*/ Dodanie kilku mieszkan pod jednym adresem */


EXEC DodajNieruchomość 'działka','Słoneczna', 68 , 'Kraków',100000 ,530123, 0 , 'budowlana' , NULL , NULL , NULL, NULL , NULL , NULL , NULL , 1, 1,1,1
EXEC DodajOgłoszenie 54,'2023-02-01'

EXEC DodajNieruchomość 'dom','Sosnowa', 31 , 'Częstochowa', 312,1104001, 1 , 'wolnostojący' , 15 , 2 , 'gaz', NULL , NULL , NULL , NULL , NULL, NULL, NULL,NULL
EXEC DodajOgłoszenie 55,'2023-02-01'



EXEC ZarezerwujTerminOglądania '08230862902', 52,  '2023-03-01 16:00:30', '2023-03-01 17:00:00'
EXEC ZarezerwujTerminOglądania '20082281942', 52,  '2023-03-01 16:50:30', '2023-03-01 18:00:00'
/*/ Dodanie terminu w którym pracownik jest zajęty */


EXEC ZarezerwujTerminOglądania '86072900736', 20,  '2023-03-01 12:00:00', '2023-03-02 18:00:00'
/*/ Dodanie terminu który trwa zbyt długo */


EXEC ZarezerwujTerminOglądania '08230862902', 3,  '2024-03-01 12:00:00', '2024-03-01 13:00:00'
/*/ Kiedy nie miesci sie w ramach czasowych */