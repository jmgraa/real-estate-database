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
CREATE PROCEDURE DodajNieruchomość (@Type_of_estate VARCHAR(MAX), @Street VARCHAR(20), @Number INT, @Place VARCHAR(MAX), @Space INT, @Price INT, @Negotiable BIT, @Type VARCHAR(MAX), @Rooms INT, @Floors INT, @Heating VARCHAR(MAX), @Floor INT, @Heating BIT, @Lift BIT, @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT) 
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
```tsql
CREATE PROCEDURE Synchronizuj
AS
	INSERT INTO Niesprzedane SELECT ID_aktualne FROM Aktualne INNER JOIN Wszystkie_oferty ON Aktualne.ID_aktualne = Wszystkie_oferty.ID_oferty WHERE Data_zakończenia < GETDATE()
	DELETE FROM Aktualne WHERE ID_aktualne IN (SELECT ID_niesprzedane FROM Niesprzedane)

    DELETE FROM Rezerwacje WHERE Koniec <= GETDATE()
GO
```
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
                        DELETE FROM Aktualne WHERE ID_aktualne = @OfferID
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


# Wyzwalacze
