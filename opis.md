# Baza Danych Szkoły
Autorzy: Jakub Magiera, Konrad Sitek

Projekt "Baza danych firmy pośredniczącej w sprzedaży nieruchomości"

# Założenia projektu
Projekt dotyczył stworzenia bazy danych dla firmy pośredniczącej w sprzedaży nieruchomości. Celem projektu było stworzenie skutecznego narzędzia do zarządzania ofertami nieruchomości oraz udostępnianie ich klientom.

Baza danych zawierała informacje o ofertach nieruchomości, takie jak typ nieruchomości, lokalizacja, cena itp. System umożliwia przeszukiwanie ofert według różnych kryteriów.

Baza pozwala zarządzać swoimi ofertami: dodawać nowe, grupować je według status (aktualne / sprzedane / niesprzedane), publikować opinie oraz śledzić pracę pracowników. Baza danych umożliwia również automatyczne modyfikowanie cen istniejących ofert, zgodnie z tym co obecnie dzieje się na rynku (treny).

## Schemat Pielęgnacji Bazy Danych

???

# Diagram ER
Na diagramie znajduję sie graficzna reprezentacja zależności pomiędzy tabelami w bazie.

# Schemat Bazy Danych
W schemacie bazy danych znajdują się wszystkie tabele, ich skład tj. nazwy oraz typy tych danych oraz czy dana wartość dopuszcza istnienie NULLa.

# Tabele
- Nieruchomości
    - Domy
    - Mieszkania
    - Działki
- Osoby
    - Klienci
    - Pracownicy
- Cechy nieruchomości
- Terminy oglądania
- Wszystkie oferty
    - Aktualne
    - Sprzedane
    - Niesprzedane
- Trendy rynkowe
- Rezerwacje
- Opinie

# Widoki


# Funkcje


## Użycie funkcji


# Procedury Składowane
Poniższa procedura synchronizuje wszystkie tabele w bazie, których zawartość jest zależna od czasu. W prawdziwej bazie, data byłaby sprawdzana automatycznie w każdym momencie. Na potrzeby naszego projektu istnieje procedura.
```tsql
CREATE PROCEDURE Synchronizuj
AS
	INSERT INTO Niesprzedane SELECT ID_aktualne FROM Aktualne INNER JOIN Wszystkie_oferty ON Aktualne.ID_aktualne = Wszystkie_oferty.ID_oferty WHERE Data_zakończenia < GETDATE()
	DELETE FROM Aktualne WHERE ID_aktualne IN (SELECT ID_niesprzedane FROM Niesprzedane)

	DELETE FROM Rezerwacje WHERE Koniec <= GETDATE()

    DELETE FROM Aktualne WHERE ID_aktualne IN (SELECT ID_oferty FROM Rezerwacje WHERE Początek >= GETDATE() AND Koniec < GETDATE())
GO
```
Poniższe cztery procedury odpowiadają za dodanie konkretnej nieruchomości do bazy. W interfejsie graficznym wyglądałoby to tak, że po wybraniu typu nieruchomości, pojawiają się kolejne okienka z moliwościa wprowadzenia odpowiednej informacji. W naszym przypadku będziemy przekazywali do procedury odpowiednie informacje, a pozostałe pola wypełnimy NULLami.
```tsql
CREATE PROCEDURE DodajDom @Type VARCHAR(MAX), @Rooms INT, @Floors INT, @Heating VARCHAR(MAX)
AS
    INSERT INTO Domy
    VALUES (@Type, @Rooms, @Floors, @Heating)
GO
```
```tsql
CREATE PROCEDURE DodajMieszkanie @Type VARCHAR(MAX), @Floor INT, @Heating BIT, @Lift BIT
AS
    INSERT INTO Mieszkania
    VALUES (@Type, @Floor, @Heating, @Lift)
GO
```
```tsql
CREATE PROCEDURE DodajDziałkę @Type VARCHAR(MAX), @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT
AS
    INSERT INTO Działki
    VALUES (@Type, @Electricty, @Gas, @Water, @Sewers)
GO
```
```tsql
CREATE PROCEDURE DodajNieruchomość (@Type_of_estate VARCHAR(MAX), @Street VARCHAR(20), @Number INT, @Place VARCHAR(MAX), @Space INT, @Price INT, @Negotiable BIT, @Type VARCHAR(MAX), @Rooms INT, @Floors INT, @Heating VARCHAR(MAX), @Floor INT, @Flat_heating BIT, @Lift BIT, @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT) 
AS
    INSERT INTO Nieruchomości VALUES (@Street, @Number, @Place, @Space, @Price, @Negotiable)

    IF @Type_of_estate = 'dom' BEGIN
        EXEC DodajDom @Type,  @Rooms, @Floors, @Heating
        PRINT('Dodano ogłoszenie domu!')
    END
    ELSE IF @Type_of_estate = 'mieszkanie' BEGIN
        EXEC DodajMieszkanie @Type VARCHAR(MAX), @Floor INT, @Heating BIT, @Lift BIT
        PRINT('Dodano ogłoszenie mieszkania!')
    END
    ELSE IF @Type_of_estate = 'działka' BEGIN
        EXEC DodajDziałkę Type VARCHAR(MAX), @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT
        PRINT('Dodano ogłoszenie działki!')
    END
    ELSE BEGIN
        PRINT('BŁĄD - zły typ nieruchomości!')
    END
GO
```
Poniższa procedura pozwala zakupić nieruchmość z ogłoszenia.
```tsql
CREATE PROCEDURE ZakupNieruchomości @OfferID INT, @ClientID INT
AS
    IF @OfferID IN (SELECT ID_aktualne FROM Wszystkie_oferty) BEGIN
        @place = SELECT Miejscowość FROM Wszystkie_oferty INNER JOIN Nieruchomości ON  Wszystkie_oferty.ID_nieruchomości = Nieruchomości.ID_nieruchomości WHERE ID_oferty = @OfferID
        @mnoznik = SELECT Sum(Zmiana_mnożnika) FROM Trendy_rynkowe WHERE Miejscowość LIKE @place AND Rozpoczęcie <= GETDATE() AND Zakończenie > GETDATE()

        INSERT INTO Sprzedane VALUES (@EstateID, @ClientID, GETDATE(), @mnoznik)
        DELETE FROM Aktualne WHERE ID_aktualne = @OfferID
    END
    ELSE BEGIN
        PRINT('BŁĄD - nieruchomość o podanym ID nie istenieje lub nie jest obecnie dostępna!')
    END
GO
```
Poniższa procedura pozwala zarezerwować na jakiś okres nieruchmość, aby była ona niedostępna dla innych klientów.
```tsql
CREATE PROCEDURE Rezerwacja @OfferID INT, @CustomerID INT, @Begin DATETIME, @End DATETIME
AS
    IF @OfferID IN (SELECT ID_nieruchomości FROM Nieruchomości) BEGIN
        IF @OfferID NOT IN (SELECT ID_rezerwacji FROM Rezerwacje) BEGIN
            IF @OfferID IN (SELECT ID_aktualne FROM Aktualne) BEGIN
                IF @Begin < @End BEGIN                    
                    @pracownik = SELECT Pracownik_obsługujący FROM Wszystkie_oferty WHERE ID_oferty = @OfferID
                    IF @pracownik IN (SELECT Pracownik_obsługujący FROM Rezerwacje INNER JOIN Wszystkie_oferty ON Rezerwacje.ID_oferty = Wszystkie_oferty.ID_oferty WHERE (@Begin < Początek AND @End < Początek) OR (@Begin > Początek AND @End > Koniec) BEGIN
                        INSERT INTO Rezerwacje(ID_oferty, ID_klienta, Początek, Koniec) VALUES (@OfferID, @CustomerID, @Begin, @End)
                    END
                    ELSE BEGIN
                        PRINT('BŁĄD - pracownik obsługujący ogłosznie jest w danym terminie zajęty!')
                    END
                END
                ELSE BEGIN
                    PRINT('BŁĄD - niewłaściwy przedział czasowy rezerwacji!')
                END
            END
            ELSE BEGIN
                PRINT('BŁĄD - to ogłosznie nie jest już aktualne!')
            END
        END
        ELSE BEGIN
            PRINT('BŁĄD - ta nieruchomość jest już zarezerwowana - proszę spróbować później!')
        END
    END
    ELSE BEGIN
        PRINT('BŁĄD - nie istnieje nieruchomość o takim ID!')
    END
GO
```

## Wykonywanie Procedur
Dodanie do bazy mieszkania w apartamentowcu na ósmym piętrze, znajdującego się na ulicy Krakowskiej 15 w Tarnowie. Mieszkanie ma 60m^2 i kosztuje 950 tysięcy złotych. Nie ma możliwości negocjacji ceny. W budynku, w którym znajduje się mieszakanie jest winda oraz jest ono ogrzewane z sieci.
```tsql
EXEC DodajNieruchomość ('mieszkanie', 'Krakowska', '15', 'Tarnów', 60, 950000, 0, 'apartamentowiec', NULL, NULL, NULL, 8, 1, 1, NULL, NULL, NULL, NULL)
```
```tsql
Zakup nieruchomości z ogłoszenia o ID_oferty 12 przez klienta o ID_klienta 34.
EXEC ZakupNieruchomości 12, 34
```
```tsql
Zarezerowanie nieruchomości z ogłoszenie o ID_oferty 9 przez klienta o ID_klienta 5 od 13 maja 2023 12:00 do 15 maja 2023 16:00.
EXEC Rezerwacja 9, 5, '2023-05-13 12:00:00', '2023-05-15 16:00:00'
```

# Wyzwalacze
W momencie, w którym zostanie dodany trend, wyzwalacz aktualizuje ceny odpowiednich nieruchomości.
```tsql
CREATE TRIGGER Dodanie_trendu
ON Trendy_rynkowe
AFTER INSERT
AS
BEGIN
    DECLARE @mnoznik FLOAT = (SELECT Zmiana_Mnożnika FROM INSERTED)
    DECLARE @miasto VARCHAR(MAX) = (SELECT Miejscowość FROM INSERTED)

    IF ((SELECT Nazwa_trendu FROM INSERTED) = 'wzrost')
    BEGIN
        UPDATE Nieruchomości
        
        SET Nieruchomości.Cena = Nieruchomości.Cena + Nieruchomości.Cena * @mnoznik
        WHERE Nieruchomości.Miejscowość = @miasto AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
    END

    ELSE IF ((SELECT Nazwa_trendu FROM INSERTED) = 'spadek')
    BEGIN
        UPDATE Nieruchomości
        SET Nieruchomości.Cena = Nieruchomości.Cena - Nieruchomości.Cena * @mnoznik
        WHERE Nieruchomości.Miejscowość = @miasto AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
    END
END
GO
```
W momencie, w którym zostanie utworzone ogłoszenie, wyzwalacz sam dobiera do niego pracownika obłsugującego, który w danym momencie obsługuje najmniej ogłoszeń.
```tsql
CREATE TRIGGER Przydzielenie_pracownika
ON Wszystkie_oferty
AFTER INSERT
AS
BEGIN
    DECLARE @pracownik INT = (SELECT TOP 1 ID_pracownika FROM Pracownicy ORDER BY Liczba_aktualnych_zleceń ASC)

    UPDATE Pracownicy
        SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń + 1
        WHERE ID_pracownika = @pracownik

    UPDATE Wszystkie_oferty
        SET Pracownik_obsługujący = @pracownik
        WHERE ID_oferty = (SELECT TOP 1 ID_oferty FROM Wszystkie_oferty ORDER BY ID_oferty DESC)
END
GO
```
W przypadku sprzedania nieruchomości lub przeterminowania ogłoszenia, pracownik przestaje obsługiwać daną ogłoszenie.
```tsql
CREATE TRIGGER Zwolnienie_pracownika_sprzedane
ON Sprzedane
AFTER INSERT
AS
BEGIN
    DECLARE @pracownik INT = (SELECT Pracownik_obsługujący FROM INSERTED INNER JOIN Wszystkie_oferty ON INSERTED.ID_sprzedane = Wszystkie_oferty.ID_oferty)

    UPDATE Pracownicy
        SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń - 1
        WHERE ID_pracownika = @pracownik
END
GO
```
```tsql
CREATE TRIGGER Zwolnienie_pracownika_niesprzedane
ON Niesprzedane
AFTER INSERT
AS
BEGIN
    DECLARE @pracownik INT = (SELECT Pracownik_obsługujący FROM INSERTED INNER JOIN Wszystkie_oferty ON INSERTED.ID_niesprzedane = Wszystkie_oferty.ID_oferty)

    UPDATE Pracownicy
        SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń - 1
        WHERE ID_pracownika = @pracownik
END
GO
```
W momencie, w którym skończy się rezerwacja, ogłoszenie wraca do aktualnych (znów jest widoczne dla innych klientów).
```tsql
CREATE TRIGGER Koniec_rezerwacji
ON Rezerwacje
AFTER DELETE
AS
BEGIN
    INSERT INTO Aktualne SELECT ID_oferty FROM DELETED 
END
GO
```