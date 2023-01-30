IF OBJECT_ID('Domy','U') IS NOT NULL
	DROP TABLE Domy
GO
IF OBJECT_ID('Mieszkania','U') IS NOT NULL
	DROP TABLE Mieszkania
GO
IF OBJECT_ID('Działki','U') IS NOT NULL
	DROP TABLE Działki
GO
IF OBJECT_ID('Cechy_nieruchomości','U') IS NOT NULL
	DROP TABLE Cechy_nieruchomości
GO
IF OBJECT_ID('Rezerwacje','U') IS NOT NULL
	DROP TABLE Rezerwacje
GO
IF OBJECT_ID('Terminy_oglądania','U') IS NOT NULL
	DROP TABLE Terminy_oglądania
GO
IF OBJECT_ID('Oferty_kupna', 'U') IS NOT NULL
    DROP TABLE Oferty_kupna
GO
IF OBJECT_ID('Aktualne', 'U') IS NOT NULL
    DROP TABLE Aktualne
GO
IF OBJECT_ID('Niesprzedane', 'U') IS NOT NULL
    DROP TABLE Niesprzedane
GO
IF OBJECT_ID('Opinie','U') IS NOT NULL
	DROP TABLE Opinie
GO
IF OBJECT_ID('Sprzedane', 'U') IS NOT NULL
    DROP TABLE Sprzedane
GO
IF OBJECT_ID('Wszystkie_oferty', 'U') IS NOT NULL
    DROP TABLE Wszystkie_oferty
GO
IF OBJECT_ID('Trendy_rynkowe','U') IS NOT NULL
	DROP TABLE Trendy_rynkowe
GO
IF OBJECT_ID('Klienci','U') IS NOT NULL
	DROP TABLE Klienci
GO
IF OBJECT_ID('Pracownicy','U') IS NOT NULL
	DROP TABLE Pracownicy
GO
IF OBJECT_ID('Osoby', 'U') IS NOT NULL
    DROP TABLE Osoby
GO
IF OBJECT_ID('Nieruchomości','U') IS NOT NULL
	DROP TABLE Nieruchomości
GO
IF OBJECT_ID('Synchronizuj', 'P') IS NOT NULL
    DROP PROCEDURE Synchronizuj
GO
IF OBJECT_ID('DodajDom', 'P') IS NOT NULL
    DROP PROCEDURE DodajDom
GO
IF OBJECT_ID('DodajMieszkanie', 'P') IS NOT NULL
    DROP PROCEDURE DodajMieszkanie
GO
IF OBJECT_ID('DodajDziałkę', 'P') IS NOT NULL
    DROP PROCEDURE DodajDziałkę
GO
IF OBJECT_ID('DodajNieruchomość', 'P') IS NOT NULL
    DROP PROCEDURE DodajNieruchomość
GO
IF OBJECT_ID('DodajOgłoszenie', 'P') IS NOT NULL
    DROP PROCEDURE DodajOgłoszenie
GO
IF OBJECT_ID('ZakupNieruchomości', 'P') IS NOT NULL
    DROP PROCEDURE ZakupNieruchomości
GO
IF OBJECT_ID('Rezerwacja', 'P') IS NOT NULL
    DROP PROCEDURE Rezerwacja
GO
IF OBJECT_ID('DodajOpinię', 'P') IS NOT NULL
    DROP PROCEDURE DodajOpinię
GO
IF OBJECT_ID('ZarezerwujTerminOglądania', 'P') IS NOT NULL
    DROP PROCEDURE ZarezerwujTerminOglądania
GO
IF OBJECT_ID('DodanieTrendu', 'TR') IS NOT NULL
    DROP TRIGGER DodanieTrendu
GO
IF OBJECT_ID('KoniecTrendu', 'TR') IS NOT NULL
    DROP TRIGGER KoniecTrendu
GO
IF OBJECT_ID('PrzydzieleniePracownika', 'TR') IS NOT NULL
    DROP TRIGGER PrzydzieleniePracownika
GO
IF OBJECT_ID('ZwolnieniePracownikaSprzedane', 'TR') IS NOT NULL
    DROP TRIGGER ZwolnieniePracownikaSprzedane
GO
IF OBJECT_ID('ZwolnieniePracownikaNiesprzedane', 'TR') IS NOT NULL
    DROP TRIGGER ZwolnieniePracownikaNiesprzedane
GO
IF OBJECT_ID('Ranking_pracowników', 'V') IS NOT NULL
    DROP VIEW Ranking_pracowników
GO
IF OBJECT_ID('Liczba_ofert_w_miesiącu', 'V') IS NOT NULL
    DROP VIEW Liczba_ofert_w_miesiącu
GO
IF OBJECT_ID('Suma_wartości', 'V') IS NOT NULL
    DROP VIEW Suma_wartości
GO
IF OBJECT_ID('Liczba_terminów_pracowników', 'V') IS NOT NULL
    DROP VIEW Liczba_terminów_pracowników
GO
IF OBJECT_ID('Obrót_pracowników', 'V') IS NOT NULL
    DROP VIEW Obrót_pracowników
GO
IF OBJECT_ID('Aktualne_z_miasta', 'IF') IS NOT NULL
    DROP FUNCTION Aktualne_z_miasta
GO
IF OBJECT_ID('Oferty_typu', 'TF') IS NOT NULL
    DROP FUNCTION Oferty_typu
GO
IF OBJECT_ID('Oferty_od_do','IF') IS NOT NULL
    DROP FUNCTION Oferty_od_do
GO 
IF OBJECT_ID('Info_oferta', 'IF') IS NOT NULL
	DROP FUNCTION Info_oferta
GO
IF OBJECT_ID('Info_oferta', 'IF') IS NOT NULL
	DROP FUNCTION Info_oferta
GO	
IF OBJECT_ID('Pracownik_aktualne', 'V') IS NOT NULL
    DROP VIEW Pracownik_aktualne
GO
IF OBJECT_ID('Pracownik_sprzedane', 'V') IS NOT NULL
    DROP VIEW Pracownik_sprzedane
GO
IF OBJECT_ID('Pracownik_niesprzedane', 'V') IS NOT NULL
    DROP VIEW Pracownik_niesprzedane
GO
IF OBJECT_ID('Pracownik_statystyki', 'V') IS NOT NULL
    DROP VIEW Pracownik_statystyki
GO

CREATE TABLE Nieruchomości (
	ID_nieruchomości INT IDENTITY(1,1) PRIMARY KEY,

	Ulica VARCHAR(MAX) NULL,
	Numer INT NOT NULL,
	Miejscowość VARCHAR(MAX) NOT NULL,

	Powierzchnia INT NOT NULL,
	Cena INT NOT NULL,
    Możliwość_negocjacji_ceny BIT NOT NULL,

    CHECK (Numer >= 0),
    CHECK (Powierzchnia > 0),
    CHECK (Cena > 0)
)

CREATE TABLE Domy (
    ID_domu INT REFERENCES Nieruchomości PRIMARY KEY,

    Rodzaj_zabudowy VARCHAR(MAX) NOT NULL,
    Liczba_pokoi INT NOT NULL,
    Liczba_pięter INT NOT NULL,
    Rodzaj_ogrzewania VARCHAR(MAX) NOT NULL,

    CHECK (Liczba_pokoi > 0),
    CHECK (Liczba_pięter >= 0)
)

CREATE TABLE Mieszkania (
    ID_mieszkania INT REFERENCES Nieruchomości PRIMARY KEY,

    Numer_mieszkania INT NOT NULL,
    Rodzaj_zabudowy VARCHAR(MAX) NOT NULL,
    Piętro INT NOT NULL,
    Ogrzewanie_z_sieci BIT NOT NULL,
    Winda_w_budynku BIT NOT NULL,

    CHECK (Numer_mieszkania >= 0)
)

CREATE TABLE Działki (
    ID_działki INT REFERENCES Nieruchomości PRIMARY KEY,

    Rodzaj_dzialki VARCHAR(MAX) NOT NULL,
    Dostep_do_pradu BIT NOT NULL,
    Dostep_do_gazu BIT NOT NULL,
    Dostep_do_wody BIT NOT NULL,
    Dostep_do_kanalizacji BIT NOT NULL,
)

CREATE TABLE Osoby (
    Pesel VARCHAR(11) PRIMARY KEY,

    Imię VARCHAR(MAX) NOT NULL,
    Nazwisko VARCHAR(MAX) NOT NULL,
    Numer_telefonu VARCHAR(12) NOT NULL
)

CREATE TABLE Klienci (
	ID_klienta VARCHAR(11) REFERENCES Osoby PRIMARY KEY,

    Adres_email VARCHAR(MAX) NULL
)

CREATE TABLE Pracownicy (
	ID_pracownika VARCHAR(11) REFERENCES Osoby PRIMARY KEY,

    Liczba_aktualnych_zleceń INT DEFAULT 0,
    Stanowisko VARCHAR(MAX) NOT NULL,

    CHECK (Liczba_aktualnych_zleceń >= 0 OR Liczba_aktualnych_zleceń IS NULL)
)

CREATE TABLE Cechy_nieruchomości (
    ID_nieruchomości INT NOT NULL,
    Nazwa_cechy VARCHAR(450) NOT NULL,

    CONSTRAINT ID_cechy PRIMARY KEY (ID_nieruchomości, Nazwa_cechy),

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości)
)

CREATE TABLE Wszystkie_oferty (
    ID_oferty INT IDENTITY(1,1) PRIMARY KEY,

    ID_nieruchomości INT NOT NULL,
    Pracownik_obsługujący VARCHAR(11) DEFAULT NULL,
    Data_wystawienia DATETIME NOT NULL,
    Data_zakończenia DATETIME NOT NULL,

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY (Pracownik_obsługujący) REFERENCES Pracownicy(ID_pracownika),

    CHECK (Data_wystawienia < Data_zakończenia)
)

CREATE TABLE Aktualne (
    ID_aktualne INT REFERENCES Wszystkie_oferty PRIMARY KEY
)

CREATE TABLE Niesprzedane (
    ID_niesprzedane INT REFERENCES Wszystkie_oferty PRIMARY KEY
)

CREATE TABLE Sprzedane (
    ID_sprzedane INT REFERENCES Wszystkie_oferty PRIMARY KEY,

    ID_kupującego VARCHAR(11) NOT NULL,
    Data_sprzedania DATETIME NOT NULL,    
    Mnożnik_ceny FLOAT DEFAULT 1,

    FOREIGN KEY (ID_kupującego) REFERENCES Klienci(ID_klienta),

    CHECK (Mnożnik_ceny > 0)
)

CREATE TABLE Terminy_oglądania (
    ID_terminu INT IDENTITY(1,1) PRIMARY KEY,

    ID_oferty INT NOT NULL,
    ID_oglądającego VARCHAR(11) NOT NULL,
    Data_zwiedzania_początek DATETIME NOT NULL,
    Data_zwiedzania_koniec DATETIME NOT NULL,
    
    FOREIGN KEY (ID_oferty) REFERENCES Aktualne(ID_aktualne) ON DELETE CASCADE,
    FOREIGN KEY (ID_oglądającego) REFERENCES Klienci(ID_klienta),

    CHECK (Data_zwiedzania_początek < Data_zwiedzania_koniec)    
)

CREATE TABLE Trendy_rynkowe (
    ID_trendu INT IDENTITY(1,1) PRIMARY KEY,

    Nazwa_trendu VARCHAR(MAX) NOT NULL,
    Rozpoczęcie DATETIME NOT NULL,
    Zakończenie DATETIME NULL,
    Miejscowość VARCHAR(450) NOT NULL UNIQUE,
    Zmiana_mnożnika FLOAT NOT NULL,

    CHECK (Rozpoczęcie < Zakończenie),
    CHECK (Zmiana_Mnożnika > 0 AND Zmiana_Mnożnika <= 1)
)

CREATE TABLE Rezerwacje (
    ID_rezerwacji INT IDENTITY(1,1) PRIMARY KEY,
    ID_oferty INT NOT NULL,
    ID_klienta VARCHAR(11) NOT NULL,
    Początek DATETIME NOT NULL,
    Koniec DATETIME NOT NULL,

    FOREIGN KEY (ID_oferty) REFERENCES Aktualne(ID_aktualne) ON DELETE CASCADE,
    FOREIGN KEY (ID_klienta) REFERENCES Klienci(ID_klienta),

    CHECK (Początek < Koniec)
)

CREATE TABLE Opinie (
    ID_opinii INT IDENTITY(1,1) PRIMARY KEY,

    ID_oferty INT NOT NULL,
    Data_wystawienia_opinii DATETIME NOT NULL,
    Ocena INT NOT NULL,
    Opis VARCHAR(MAX) NULL,

    FOREIGN KEY (ID_oferty) REFERENCES Sprzedane(ID_sprzedane),

    CHECK (Ocena BETWEEN 0 AND 10)
)

GO

CREATE PROCEDURE Synchronizuj
AS
    SET NOCOUNT ON

    --dodanie do aktualnych oferty tych, które jeszcze się nie przedawniły, nie zostały sprzedana oraz nie są już w aktualnych
    INSERT INTO Aktualne SELECT ID_oferty FROM Wszystkie_oferty WHERE ID_oferty NOT IN (SELECT ID_aktualne FROM Aktualne) AND ID_oferty NOT IN (SELECT ID_sprzedane FROM Sprzedane) AND Data_zakończenia > GETDATE()

    --dodanie do niesprzedanych ofert tych, które przedawniły się i nie są one już w niesprzedanych lub w sprzedancyh
    INSERT INTO Niesprzedane SELECT ID_oferty FROM Wszystkie_oferty WHERE ID_oferty NOT IN (SELECT ID_niesprzedane FROM Niesprzedane) AND ID_oferty NOT IN (SELECT ID_sprzedane FROM Sprzedane) AND Data_zakończenia <= GETDATE()

    --usunięcie przedawnionych ofert z aktualnych
	DELETE FROM Aktualne WHERE ID_aktualne IN (SELECT ID_niesprzedane FROM Niesprzedane)

    --usuniecie przedawnionej rezerwacji
    DELETE FROM Rezerwacje WHERE Koniec <= GETDATE()

    --usuniecie przedawnionego trendu
    DELETE FROM Trendy_rynkowe WHERE Zakończenie IS NOT NULL AND Zakończenie <= GETDATE()

    --usuniecie przedawnionego terminu oglądania
    DELETE FROM Terminy_oglądania WHERE Data_zwiedzania_koniec <= GETDATE()

    PRINT('SUKCES - synchronizacja przebiegła pomyślnie!')
GO

CREATE PROCEDURE DodajDom (@ID INT, @Type VARCHAR(MAX), @Rooms INT, @Floors INT, @Heating VARCHAR(MAX))
AS
    INSERT INTO Domy VALUES (@ID, @Type, @Rooms, @Floors, @Heating)
    PRINT('SUKCES - dodano ogłoszenie domu!')
    EXEC Synchronizuj
GO

CREATE PROCEDURE DodajMieszkanie (@ID INT, @Flat_number INT, @Type VARCHAR(MAX), @Floor INT, @Heating BIT, @Lift BIT)
AS
    INSERT INTO Mieszkania VALUES (@ID, @Flat_number, @Type, @Floor, @Heating, @Lift)
    PRINT('SUKCES - dodano ogłoszenie mieszkania!')
    EXEC Synchronizuj
GO

CREATE PROCEDURE DodajDziałkę (@ID INT, @Type VARCHAR(MAX), @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT)
AS
    INSERT INTO Działki VALUES (@ID, @Type, @Electricty, @Gas, @Water, @Sewers)
    PRINT('SUKCES - dodano ogłoszenie działki!')
    EXEC Synchronizuj
GO

CREATE PROCEDURE DodajNieruchomość (@Type_of_estate VARCHAR(MAX), @Street VARCHAR(MAX), @Number INT, @Place VARCHAR(MAX), @Space INT, @Price INT, @Negotiable BIT, @Type VARCHAR(MAX), @Rooms INT, @Floors INT, @HeatingType VARCHAR(MAX), @Flat_number INT, @Floor INT, @HeatingBit BIT, @Lift BIT, @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT) 
AS
    IF @Type_of_estate IS NOT NULL AND @Street IS NOT NULL AND @Number IS NOT NULL AND @Place IS NOT NULL AND @Space IS NOT NULL AND @Price IS NOT NULL AND @Negotiable IS NOT NULL AND @Type IS NOT NULL BEGIN
        IF NOT EXISTS(SELECT ID_nieruchomości FROM Nieruchomości WHERE Ulica = @Street AND Numer = @Number AND Miejscowość = @Place AND Powierzchnia = @Space) AND (@Type_of_estate LIKE 'dom' OR @Type_of_estate LIKE 'działka') BEGIN
            IF @Type_of_estate = 'dom' BEGIN
                IF @Type IS NOT NULL AND @Rooms IS NOT NULL AND @Floors IS NOT NULL AND @HeatingType IS NOT NULL BEGIN
                    INSERT INTO Nieruchomości(Ulica, Numer, Miejscowość, Powierzchnia, Cena, Możliwość_negocjacji_ceny) VALUES (@Street, @Number, @Place, @Space, @Price, @Negotiable)
                    DECLARE @ID INT = (SELECT TOP 1 ID_nieruchomości FROM Nieruchomości ORDER BY ID_nieruchomości DESC)
                    EXEC DodajDom @ID, @Type, @Rooms, @Floors, @HeatingType
                END
                ELSE BEGIN
                    PRINT('BŁĄD - niepełne dane!')
                END
            END
            ELSE IF @Type_of_estate = 'działka' BEGIN
                IF @Type IS NOT NULL AND @Electricty IS NOT NULL AND @Gas IS NOT NULL AND @Water IS NOT NULL AND @Sewers IS NOT NULL BEGIN
                    INSERT INTO Nieruchomości(Ulica, Numer, Miejscowość, Powierzchnia, Cena, Możliwość_negocjacji_ceny) VALUES (@Street, @Number, @Place, @Space, @Price, @Negotiable)
                    DECLARE @ID_2 INT = (SELECT TOP 1 ID_nieruchomości FROM Nieruchomości ORDER BY ID_nieruchomości DESC)
                    EXEC DodajDziałkę @ID_2, @Type, @Electricty, @Gas, @Water, @Sewers
                END
                ELSE BEGIN
                    PRINT('BŁĄD - niepełne dane!')
                END
            END
        END
        ELSE IF @Type_of_estate = 'mieszkanie' AND NOT EXISTS(SELECT * FROM Mieszkania INNER JOIN Nieruchomości ON Mieszkania.ID_mieszkania = Nieruchomości.ID_nieruchomości WHERE Ulica = @Street AND Numer = @Number AND Miejscowość = @Place AND Powierzchnia = @Space AND @Flat_number IS NOT NULL AND Numer_mieszkania = @Flat_number) BEGIN
            IF @Flat_number IS NOT NULL AND @Type IS NOT NULL AND @Floor IS NOT NULL AND @HeatingBit IS NOT NULL AND @Lift IS NOT NULL BEGIN
                INSERT INTO Nieruchomości(Ulica, Numer, Miejscowość, Powierzchnia, Cena, Możliwość_negocjacji_ceny) VALUES (@Street, @Number, @Place, @Space, @Price, @Negotiable)
                DECLARE @ID_3 INT = (SELECT TOP 1 ID_nieruchomości FROM Nieruchomości ORDER BY ID_nieruchomości DESC)
                EXEC DodajMieszkanie @ID_3, @Flat_number, @Type, @Floor, @HeatingBit, @Lift
            END
            ELSE BEGIN
                PRINT('BŁĄD - niepełne dane!')
            END            
        END
        ELSE BEGIN
            PRINT('BŁĄD - w bazie istnieje już ta nieruchomość lub podałeś zły typ nieruchomości!')
        END
    END
    ELSE BEGIN
        PRINT('BŁĄD - niepełne dane!')
    END   
GO

CREATE PROCEDURE DodajOgłoszenie (@EstateID INT, @End DATETIME)
AS
    IF @EstateID IS NULL OR @End IS NULL BEGIN
        PRINT('BŁĄD - niepełne dane!')
    END
    ELSE IF @EstateID IN (SELECT ID_nieruchomości FROM Nieruchomości) BEGIN
        IF @EstateID NOT IN (SELECT ID_aktualne FROM AKTUALNE) BEGIN
            IF GETDATE() < @End BEGIN
                INSERT INTO Wszystkie_oferty(ID_nieruchomości, Data_wystawienia, Data_zakończenia) VALUES (@EstateID, GETDATE(), @End)
                PRINT('SUKCES - pomyślnie dodano ogłoszenie!')
                EXEC Synchronizuj
            END
            ELSE BEGIN
                PRINT('BŁĄD - niewłaściwy przedział czasowy!')
            END
        END
        ELSE BEGIN
            PRINT('BŁĄD - istnieje już aktualne ogłoszenie dla tej nieruchomości!')
        END
    END
    ELSE BEGIN
        PRINT('BŁĄD - nie istnieje nieruchomość o takim ID!')
    END
GO

CREATE PROCEDURE ZakupNieruchomości (@OfferID INT, @CustomerID VARCHAR(11))
AS
    IF @OfferID IS NULL OR @CustomerID IS NULL BEGIN
        PRINT('BŁĄD - niepełne dane!')
    END
    ELSE IF (@OfferID IN (SELECT ID_aktualne FROM Aktualne) AND ((@OfferID NOT IN (SELECT ID_oferty FROM Rezerwacje) OR (@OfferID IN (SELECT ID_oferty FROM Rezerwacje WHERE ID_klienta LIKE @CustomerID))))) BEGIN
        DECLARE @place VARCHAR(MAX) = (SELECT Miejscowość FROM Wszystkie_oferty INNER JOIN Nieruchomości ON  Wszystkie_oferty.ID_nieruchomości = Nieruchomości.ID_nieruchomości WHERE ID_oferty = @OfferID)

        DECLARE @multiplier FLOAT = (SELECT Zmiana_mnożnika FROM Trendy_rynkowe WHERE Miejscowość LIKE @place AND Rozpoczęcie <= GETDATE() AND Zakończenie > GETDATE())

        IF @multiplier IS NULL BEGIN
            SET @multiplier = 1
        END

        DECLARE @EstateID INT = (SELECT ID_nieruchomości FROM Wszystkie_oferty WHERE ID_nieruchomości = @OfferID)

        INSERT INTO Sprzedane VALUES (@EstateID, @CustomerID, GETDATE(), @multiplier)
        DELETE FROM Aktualne WHERE ID_aktualne = @OfferID

        PRINT('SUKCES - udało Ci się zakupić tą nieruchmość!')

        EXEC Synchronizuj
    END
    ELSE BEGIN
        PRINT('BŁĄD - nieruchomość o podanym ID nie istenieje lub nie jest obecnie dostępna!')
    END  
GO

CREATE PROCEDURE Rezerwacja (@OfferID INT, @CustomerID VARCHAR(11), @End DATETIME)
AS
    IF @OfferID IS NULL OR @CustomerID IS NULL OR @End IS NULL BEGIN
        PRINT('BŁĄD - niepełne dane!')
    END
    ELSE IF @OfferID IN (SELECT ID_oferty FROM Wszystkie_oferty) BEGIN
        DECLARE @EstateID INT = (SELECT ID_nieruchomości FROM Wszystkie_oferty WHERE ID_oferty = @OfferID)

        IF @OfferID IN (SELECT ID_aktualne FROM Aktualne) BEGIN
            IF GETDATE() < @End AND GETDATE() < (SELECT Data_zakończenia FROM Wszystkie_oferty WHERE ID_oferty = @OfferID) AND @End < (SELECT Data_zakończenia FROM Wszystkie_oferty WHERE ID_oferty = @OfferID) BEGIN 
                IF NOT EXISTS(SELECT ID_rezerwacji FROM Rezerwacje WHERE ID_oferty = @OfferID AND Początek <= GETDATE() AND Koniec > GETDATE()) BEGIN
                    INSERT INTO Rezerwacje(ID_oferty, ID_klienta, Początek, Koniec) VALUES (@OfferID, @CustomerID, GETDATE(), @End)
                    PRINT('SUKCES - pomyślnie dodano rezerwację!')
                    EXEC Synchronizuj
                END
                ELSE BEGIN
                    PRINT('BŁĄD - ta nieruchomość jest obecnie zarezerwowana!')
                END
            END
            ELSE BEGIN
                PRINT('BŁĄD - niewłaściwy przedział czasowy!')
            END
        END
        ELSE BEGIN
            PRINT('BŁĄD - to ogłosznie nie jest już aktualne!')
        END
    END
    ELSE BEGIN
        PRINT('BŁĄD - nie istnieje ogłoszenie o takim ID!')
    END
GO

CREATE PROCEDURE DodajOpinię (@CustomerID VARCHAR(11), @OfferID INT, @Grade INT, @Description VARCHAR(MAX))
AS
    IF @CustomerID IS NULL OR @OfferID IS NULL OR @Grade IS NULL OR @Description IS NULL BEGIN
        PRINT('BŁĄD - niepełne dane!')
    END
    ELSE IF @Grade < 1 OR @Grade > 10 BEGIN
    	PRINT('BŁĄD - ocena musi być z przedziału 1 - 10!')
 	END
    ELSE IF @OfferID IN (SELECT ID_sprzedane FROM Sprzedane WHERE ID_kupującego = @CustomerID) BEGIN
        IF (@OfferID NOT IN (SELECT ID_oferty FROM Opinie)) BEGIN
            INSERT INTO Opinie(ID_oferty, Data_wystawienia_opinii, Ocena, Opis) VALUES (@OfferID, GETDATE(), @Grade, @Description)
            PRINT('SUKCES - pomyślnie dodano opinię!')

            EXEC Synchronizuj
        END
        ELSE BEGIN
            PRINT('BŁĄD - zamieściłeś już opinię odnośnie tej nieruchomości!')
        END
    END
    ELSE BEGIN
        PRINT('BŁĄD - klient o podanym ID nie istnieje, nie zakupił żadnej nieruchomości lub tej o podanym ID!')
    END
GO

CREATE PROCEDURE ZarezerwujTerminOglądania (@CustomerID VARCHAR(11), @OfferID INT, @Start DATETIME, @End DATETIME)
AS
    IF @CustomerID IS NULL OR @OfferID IS NULL OR @Start IS NULL OR @End IS NULL BEGIN
        PRINT('BŁĄD - niepełne dane!')
    END
    ELSE IF @OfferID IN (SELECT ID_aktualne FROM Aktualne) BEGIN
        IF @Start < @End AND @Start >= GETDATE() AND @End > GETDATE() AND @Start < (SELECT Data_zakończenia FROM Wszystkie_oferty WHERE ID_oferty = @OfferID) AND @End < (SELECT Data_zakończenia FROM Wszystkie_oferty WHERE ID_oferty = @OfferID) BEGIN
            DECLARE @employee VARCHAR(11) = (SELECT Pracownik_obsługujący FROM Wszystkie_oferty WHERE ID_oferty = @OfferID)

            IF @employee NOT IN (SELECT Pracownik_obsługujący FROM Terminy_oglądania INNER JOIN Wszystkie_oferty ON Terminy_oglądania.ID_oferty = Wszystkie_oferty.ID_oferty WHERE Pracownik_obsługujący LIKE @employee AND (@Start >= Data_zwiedzania_początek OR @End > Data_zwiedzania_początek) AND (@Start < Data_zwiedzania_koniec OR @End <= Data_zwiedzania_koniec)) BEGIN
                IF DATEDIFF(SECOND, @Start, @End) >= 600 AND DATEDIFF(SECOND, @Start, @End) <= 7200 BEGIN
                    INSERT INTO Terminy_oglądania(ID_oferty, ID_oglądającego, Data_zwiedzania_początek, Data_zwiedzania_koniec) VALUES (@OfferID, @CustomerID, @Start, @End)
                    PRINT('SUKCES - zarezerwowano termin oglądania')

                    EXEC Synchronizuj
                END
                ELSE BEGIN
                    PRINT('BŁĄD - wizyta musi trwać minimalnie 10 minut, a maksymalnie 2 godziny!')
                END
            END
            ELSE BEGIN
                PRINT('BŁĄD - pracownik jest zajęty w tym terminie!')
            END
        END
        ELSE BEGIN
            PRINT('BŁĄD - niewłaściwy przedział czasowy lub ogłoszenie w tym czasie może już być nieaktualne!')
        END   
    END
    ELSE BEGIN
        PRINT('BŁĄD - nie istnieje aktualna oferta o podanym ID!')
    END
GO

--W PRZYPADKU UŻYWANIA DANYCH TESTOWYCH PROSZĘ DODAĆ JE TERAZ (BEZ PROCEDUR)

CREATE TRIGGER DodanieTrendu
ON Trendy_rynkowe
AFTER INSERT
AS
BEGIN
    DECLARE @loop_border INT = (SELECT MAX(ID_trendu) FROM INSERTED)
    DECLARE @iterator INT = (SELECT MIN(ID_trendu) FROM INSERTED)

    WHILE(@iterator <= @loop_border) BEGIN
        IF EXISTS(SELECT ID_trendu FROM INSERTED WHERE ID_trendu = @iterator) BEGIN
            DECLARE @multiplier FLOAT = (SELECT Zmiana_Mnożnika FROM INSERTED WHERE ID_trendu = @iterator)
            DECLARE @place VARCHAR(MAX) = (SELECT Miejscowość FROM INSERTED WHERE ID_trendu = @iterator)

            IF ((SELECT Nazwa_trendu FROM INSERTED WHERE ID_trendu = @iterator) = 'wzrost')
            BEGIN
                UPDATE Nieruchomości        
                    SET Nieruchomości.Cena = Nieruchomości.Cena * (1 + @multiplier) 
                    WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
            END

            ELSE IF ((SELECT Nazwa_trendu FROM INSERTED WHERE ID_trendu = @iterator) = 'spadek')
            BEGIN
                UPDATE Nieruchomości
                    SET Nieruchomości.Cena = Nieruchomości.Cena * (1 - @multiplier)
                    WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
            END
        END

        SET @iterator = @iterator + 1           
    END
END
GO

CREATE TRIGGER KoniecTrendu
ON Trendy_rynkowe
AFTER DELETE
AS
BEGIN
    DECLARE @loop_border INT = (SELECT MAX(ID_trendu) FROM DELETED)
    DECLARE @iterator INT = (SELECT MIN(ID_trendu) FROM DELETED)

    WHILE(@iterator <= @loop_border) BEGIN
        IF EXISTS(SELECT ID_trendu FROM DELETED WHERE ID_trendu = @iterator) BEGIN
            DECLARE @multiplier FLOAT = (SELECT Zmiana_Mnożnika FROM DELETED WHERE ID_trendu = @iterator)
            DECLARE @place VARCHAR(MAX) = (SELECT Miejscowość FROM DELETED WHERE ID_trendu = @iterator)

            IF ((SELECT Nazwa_trendu FROM DELETED WHERE ID_trendu = @iterator) = 'wzrost')
            BEGIN
                UPDATE Nieruchomości        
                    SET Nieruchomości.Cena = Nieruchomości.Cena * 100 / (1 + @multiplier) 
                    WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
            END

            ELSE IF ((SELECT Nazwa_trendu FROM DELETED WHERE ID_trendu = @iterator) = 'spadek')
            BEGIN
                UPDATE Nieruchomości
                    SET Nieruchomości.Cena = Nieruchomości.Cena * 100 / (1 - @multiplier)
                    WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
            END
        END

        SET @iterator = @iterator + 1           
    END
END
GO

CREATE TRIGGER PrzydzieleniePracownika
ON Aktualne
AFTER INSERT
AS
BEGIN
    DECLARE @loop_border INT = (SELECT MAX(ID_aktualne) FROM INSERTED)
    DECLARE @iterator INT = (SELECT MIN(ID_aktualne) FROM INSERTED)

    WHILE(@iterator <= @loop_border) BEGIN
        IF EXISTS(SELECT ID_aktualne FROM INSERTED WHERE ID_aktualne = @iterator) BEGIN
            DECLARE @employee VARCHAR(11) = (SELECT TOP 1 ID_pracownika FROM Pracownicy ORDER BY Liczba_aktualnych_zleceń ASC)

            UPDATE Pracownicy
                SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń + 1
                WHERE ID_pracownika = @employee

            UPDATE Wszystkie_oferty
                SET Pracownik_obsługujący = @employee
                WHERE ID_oferty = @iterator
        END

        SET @iterator = @iterator + 1           
    END
END
GO

CREATE TRIGGER ZwolnieniePracownikaSprzedane
ON Sprzedane
AFTER INSERT
AS
BEGIN
    DECLARE @loop_border INT = (SELECT MAX(ID_sprzedane) FROM INSERTED)
    DECLARE @iterator INT = (SELECT MIN(ID_sprzedane) FROM INSERTED)

    WHILE(@iterator <= @loop_border) BEGIN
        IF EXISTS(SELECT ID_sprzedane FROM INSERTED WHERE ID_sprzedane = @iterator) BEGIN
            DECLARE @employee VARCHAR(11) = (SELECT Pracownik_obsługujący FROM INSERTED INNER JOIN Wszystkie_oferty ON INSERTED.ID_sprzedane = Wszystkie_oferty.ID_oferty WHERE INSERTED.ID_sprzedane = @iterator)

            UPDATE Pracownicy
                SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń - 1
                WHERE ID_pracownika = @employee
        END

        SET @iterator = @iterator + 1           
    END
END
GO

CREATE TRIGGER ZwolnieniePracownikaNiesprzedane
ON Niesprzedane
AFTER INSERT
AS
BEGIN
    DECLARE @loop_border INT = (SELECT MAX(ID_niesprzedane) FROM INSERTED)
    DECLARE @iterator INT = (SELECT MIN(ID_niesprzedane) FROM INSERTED)

    WHILE(@iterator <= @loop_border) BEGIN
        IF EXISTS(SELECT ID_niesprzedane FROM INSERTED WHERE ID_niesprzedane = @iterator) BEGIN
            DECLARE @employee VARCHAR(11) = (SELECT Pracownik_obsługujący FROM INSERTED INNER JOIN Wszystkie_oferty ON INSERTED.ID_niesprzedane = Wszystkie_oferty.ID_oferty WHERE INSERTED.ID_niesprzedane = @iterator)

            UPDATE Pracownicy
                SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń - 1
                WHERE ID_pracownika = @employee
        END

        SET @iterator = @iterator + 1           
    END
END
GO

CREATE VIEW Ranking_pracowników AS
	SELECT Os.Imię, Os.Nazwisko, P.ID_pracownika, AVG(O.Ocena) AS Średnia_ocena FROM Opinie O
	INNER JOIN Wszystkie_oferty W ON W.ID_oferty = O.ID_Oferty
	INNER JOIN Pracownicy P ON W.Pracownik_obsługujący = P.ID_pracownika
	INNER JOIN Osoby Os ON Os.Pesel = P.ID_pracownika
	GROUP BY P.ID_pracownika,Os.Imię, Os.Nazwisko
GO

CREATE VIEW Liczba_ofert_w_miesiącu AS
	SELECT MONTH(Data_wystawienia) AS [Numer miesiąca], COUNT(MONTH(Data_wystawienia)) AS [Liczba ofert w miesiącu] FROM Wszystkie_oferty
	GROUP BY MONTH(Data_wystawienia)
GO

CREATE VIEW Suma_wartości AS
	SELECT Miejscowość, SUM(Cena) AS [Suma nieruchmości] FROM Nieruchomości
	GROUP BY Miejscowość
GO

CREATE VIEW Liczba_terminów_pracowników AS
	SELECT O.Imię, O.Nazwisko, O.Numer_telefonu , COUNT(Id_terminu) AS [Liczba zarezerwowanych terminów] FROM Osoby O
	INNER JOIN Pracownicy P ON
	O.Pesel = P.Id_pracownika
	LEFT JOIN Wszystkie_oferty W ON
	W.Pracownik_obsługujący = P.ID_pracownika
	INNER JOIN Terminy_oglądania T ON
	W.ID_oferty = T.ID_oferty
	GROUP BY O.Imię, O.Nazwisko, O.Numer_telefonu
GO
	
CREATE VIEW Obrót_pracowników AS
	SELECT Osoby.Imię, Osoby.Nazwisko, SUM(Nieruchomości.Cena) AS [Suma sprzedanych nieruchomości] FROM Pracownicy 
	LEFT JOIN Osoby ON Pracownicy.ID_pracownika = Osoby.Pesel
	LEFT JOIN Wszystkie_oferty ON Pracownicy.ID_pracownika = Wszystkie_oferty.Pracownik_obsługujący
	LEFT JOIN Nieruchomości ON Wszystkie_oferty.ID_nieruchomości = Nieruchomości.ID_nieruchomości
	LEFT JOIN Sprzedane ON Sprzedane.ID_sprzedane = Wszystkie_oferty.ID_nieruchomości
	GROUP BY Osoby.Imię, Osoby.Nazwisko
GO

CREATE FUNCTION Aktualne_z_miasta(@x VARCHAR(MAX))
RETURNS TABLE
AS
RETURN
    SELECT * FROM Nieruchomości N
	LEFT JOIN Aktualne A ON	N.ID_nieruchomości = A.ID_aktualne
	WHERE N.Miejscowość = @x;
GO

CREATE FUNCTION Oferty_typu(@x VARCHAR(MAX))
RETURNS @result TABLE (ID_nieruchomosci int, Ulica VARCHAR(MAX), Numer int,Miejscowość VARCHAR(MAX),Powierzchnia INT,Cena INT, Możliwość_negocjacji_ceny BIT)
AS
BEGIN
	IF @x = 'Domy' BEGIN
		INSERT INTO @result
		SELECT N.ID_nieruchomości, N.Ulica, N.Numer, N.Miejscowość, N.Powierzchnia, N.Cena, N.Możliwość_negocjacji_ceny FROM Domy
		LEFT JOIN Nieruchomości N ON
		ID_domu = N.ID_nieruchomości
	END
	ELSE IF @x = 'Działki' BEGIN
		INSERT INTO @result
		SELECT N.ID_nieruchomości, N.Ulica, N.Numer, N.Miejscowość, N.Powierzchnia, N.Cena, N.Możliwość_negocjacji_ceny FROM Działki
		LEFT JOIN Nieruchomości N ON
		ID_działki = N.ID_nieruchomości
	END
	ELSE IF @x = 'Mieszkania' BEGIN
		INSERT INTO @result
		SELECT N.ID_nieruchomości, N.Ulica, N.Numer, N.Miejscowość, N.Powierzchnia, N.Cena, N.Możliwość_negocjacji_ceny FROM Mieszkania
		LEFT JOIN Nieruchomości N ON ID_mieszkania = N.ID_nieruchomości
	END
	ELSE BEGIN
		INSERT INTO @result SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL
	END
	RETURN
END
GO

CREATE FUNCTION Oferty_od_do(@a INT, @b INT)
RETURNS TABLE
AS
RETURN
	SELECT * FROM Nieruchomości WHERE Nieruchomości.Cena >= @a AND Nieruchomości.Cena <= @b;
GO

CREATE FUNCTION Info_oferta(@x INT)
RETURNS TABLE
AS
RETURN 
	SELECT 
	W.Pracownik_obsługujący, W.Data_wystawienia, W.Data_zakończenia, N.Ulica, N.Numer,N.Miejscowość,N.Powierzchnia, N.Cena,N.Możliwość_negocjacji_ceny FROM Wszystkie_oferty W INNER JOIN
	Nieruchomości N ON
	W.ID_nieruchomości = N.ID_nieruchomości
	WHERE W.ID_nieruchomości = @x
GO

CREATE VIEW Pracownik_aktualne AS
	SELECT O.Pesel, COUNT(A.ID_aktualne) AS [Ilosc aktualnych] FROM Osoby O
	INNER JOIN Wszystkie_oferty W ON
	W.Pracownik_obsługujący = O.Pesel
	LEFT JOIN
	Aktualne A ON
	W.ID_oferty = A.ID_aktualne
GROUP BY O.Pesel
GO

CREATE VIEW Pracownik_sprzedane AS
	SELECT O.Pesel, COUNT(S.ID_sprzedane) AS [Ilosc sprzedanych] FROM Osoby O
	INNER JOIN Wszystkie_oferty W ON
	W.Pracownik_obsługujący = O.Pesel
	LEFT JOIN
	Sprzedane S ON
	W.ID_oferty = S.ID_sprzedane
GROUP BY O.Pesel
GO

CREATE VIEW Pracownik_niesprzedane AS
	SELECT O.Pesel, COUNT(N.ID_niesprzedane) AS [Ilosc niesprzedanych] FROM Osoby O
	INNER JOIN Wszystkie_oferty W ON
	W.Pracownik_obsługujący = O.Pesel
	LEFT JOIN
	Niesprzedane N ON
	W.ID_oferty = N.ID_niesprzedane
GROUP BY O.Pesel
GO

CREATE VIEW Pracownik_statystyki AS
	SELECT O.Imię, O.Nazwisko, O.Numer_telefonu, Pa.[Ilosc aktualnych], Ps.[Ilosc sprzedanych], Pn.[Ilosc niesprzedanych] FROM Osoby O 
	INNER JOIN Pracownik_aktualne Pa ON
	Pa.Pesel = O.Pesel
	INNER JOIN Pracownik_sprzedane Ps ON
	Ps.Pesel = O.Pesel
	INNER JOIN Pracownik_niesprzedane Pn ON
	Pn.Pesel = O.Pesel
GO

--W PRZYPADKU UŻYWANIA PROCEDUR Z DANYCH TESTOWYCH PROSZĘ WYKONAĆ JE TERAZ