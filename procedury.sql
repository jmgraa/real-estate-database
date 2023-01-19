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

CREATE PROCEDURE DodajDom (@ID INT, @Type VARCHAR(MAX), @Rooms INT, @Floors INT, @Heating VARCHAR(MAX))
AS
    INSERT INTO Domy
    VALUES (@ID, @Type, @Rooms, @Floors, @Heating)
GO

CREATE PROCEDURE DodajMieszkanie (@ID INT, @Flat_number INT, @Type VARCHAR(MAX), @Floor INT, @Heating BIT, @Lift BIT)
AS
    INSERT INTO Mieszkania
    VALUES (@ID, @Flat_number, @Type, @Floor, @Heating, @Lift)
GO

CREATE PROCEDURE DodajDziałkę (@ID INT, @Type VARCHAR(MAX), @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT)
AS
    INSERT INTO Działki
    VALUES (@ID, @Type, @Electricty, @Gas, @Water, @Sewers)
GO

CREATE PROCEDURE DodajNieruchomość (@Type_of_estate VARCHAR(MAX), @Street VARCHAR(20), @Number INT, @Place VARCHAR(MAX), @Space INT, @Price INT, @Negotiable BIT, @Type VARCHAR(MAX), @Rooms INT, @Floors INT, @HeatingType VARCHAR(MAX), @Flat_number INT, @Floor INT, @HeatingBit BIT, @Lift BIT, @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT) 
AS
    IF NOT EXISTS(SELECT * FROM Nieruchomości WHERE Ulica = @Street AND Numer = @Number AND Miejscowość = @Place AND Powierzchnia = @Space) BEGIN
        INSERT INTO Nieruchomości(Ulica, Numer, Miejscowość, Powierzchnia, Cena, Możliwość_negocjacji_ceny) VALUES (@Street, @Number, @Place, @Space, @Price, @Negotiable)

        DECLARE @ID INT = (SELECT TOP 1 ID_nieruchomości FROM Nieruchomości ORDER BY ID_nieruchomości DESC)

        IF @Type_of_estate = 'dom' BEGIN
            EXEC DodajDom @ID, @Type, @Rooms, @Floors, @HeatingType
            PRINT('Dodano ogłoszenie domu!')
        END
        ELSE IF @Type_of_estate = 'mieszkanie' BEGIN
            EXEC DodajMieszkanie @ID, @Flat_number, @Type, @Floor, @HeatingBit, @Lift
            PRINT('Dodano ogłoszenie mieszkania!')
        END
        ELSE IF @Type_of_estate = 'działka' BEGIN
            EXEC DodajDziałkę @ID, @Type, @Electricty, @Gas, @Water, @Sewers
            PRINT('Dodano ogłoszenie działki!')
        END
        ELSE BEGIN
            PRINT('BŁĄD - zły typ nieruchomości!')
        END
    END
    ELSE IF @Type_of_estate = 'mieszkanie' AND NOT EXISTS(SELECT * FROM Mieszkania INNER JOIN Nieruchomości ON Mieszkania.ID_mieszkania = Nieruchomości.ID_nieruchomości WHERE Ulica = @Street AND Numer = @Number AND Miejscowość = @Place AND Powierzchnia = @Space AND Numer_mieszkania = @Flat_number) BEGIN
        INSERT INTO Nieruchomości(Ulica, Numer, Miejscowość, Powierzchnia, Cena, Możliwość_negocjacji_ceny) VALUES (@Street, @Number, @Place, @Space, @Price, @Negotiable)
        EXEC DodajDziałkę @ID, @Type, @Electricty, @Gas, @Water, @Sewers
        PRINT('Dodano ogłoszenie mieszkania!')
    END
    ELSE BEGIN
        PRINT('BŁĄD - w bazie istnieje już ta nieruchomość!')
    END
GO

CREATE PROCEDURE Synchronizuj
AS
    INSERT INTO Aktualne SELECT ID_oferty FROM Wszystkie_oferty WHERE ID_oferty NOT IN (SELECT ID_aktualne FROM Aktualne) AND ID_oferty NOT IN (SELECT ID_sprzedane FROM Sprzedane) AND Data_zakończenia > GETDATE()

    INSERT INTO Niesprzedane SELECT ID_oferty FROM Wszystkie_oferty WHERE ID_oferty NOT IN (SELECT ID_niesprzedane FROM Niesprzedane) AND ID_oferty NOT IN (SELECT ID_sprzedane FROM Sprzedane) AND Data_zakończenia <= GETDATE()

	DELETE FROM Aktualne WHERE ID_aktualne IN (SELECT ID_niesprzedane FROM Niesprzedane)

    DELETE FROM Aktualne WHERE ID_aktualne IN (SELECT ID_oferty FROM Rezerwacje WHERE Początek <= GETDATE() AND Koniec > GETDATE()) 

    INSERT INTO Aktualne SELECT ID_oferty FROM Rezerwacje WHERE Koniec <= GETDATE() AND (ID_oferty NOT IN (SELECT ID_oferty FROM Aktualne))

    DELETE FROM Trendy_rynkowe WHERE Zakończenie IS NOT NULL AND Zakończenie <= GETDATE()

    PRINT('SUKCES - synchronizacja przebiegła pomyślnie!')
GO

CREATE PROCEDURE DodajOgłoszenie (@EstateID INT, @Start DATETIME, @End DATETIME)
AS
    IF @EstateID IN (SELECT ID_nieruchomości FROM Nieruchomości) BEGIN
        IF @EstateID NOT IN (SELECT ID_aktualne FROM AKTUALNE) BEGIN
            IF @Start < @End BEGIN
                INSERT INTO Wszystkie_oferty(ID_nieruchomości, Data_wystawienia, Data_zakończenia) VALUES (@EstateID, @Start, @End)
                PRINT('SUKCES - pomyślnie dodano ogłoszenie!')
            END
            ELSE BEGIN
                PRINT('BŁĄD - niewłaściwy przedział czasowy!')
            END
        END
        ELSE BEGIN
            PRINT('BŁĄD - istnieje już  aktualne ogłoszenie dla tej nieruchomości!')
        END
    END
    ELSE BEGIN
        PRINT('BŁĄD - nie istnieje nieruchomość o takim ID!')
    END
GO

CREATE PROCEDURE ZakupNieruchomości (@OfferID INT, @ClientID INT)
AS
    IF @OfferID IN (SELECT ID_nieruchomości FROM Aktualne INNER JOIN Wszystkie_oferty ON Aktualne.ID_aktualne = Wszystkie_oferty.ID_oferty) BEGIN
        DECLARE @place INT = (SELECT Miejscowość FROM Wszystkie_oferty INNER JOIN Nieruchomości ON  Wszystkie_oferty.ID_nieruchomości = Nieruchomości.ID_nieruchomości WHERE ID_oferty = @OfferID)

        DECLARE @mutlplier INT = (SELECT Zmiana_mnożnika FROM Trendy_rynkowe WHERE Miejscowość LIKE @place AND Rozpoczęcie <= GETDATE() AND Zakończenie > GETDATE())

        DECLARE @EstateID INT = (SELECT ID_nieruchomości FROM Wszystkie_oferty WHERE ID_nieruchomości = @OfferID)

        INSERT INTO Sprzedane VALUES (@EstateID, @ClientID, GETDATE(), @mutlplier)
        DELETE FROM Aktualne WHERE ID_aktualne = @OfferID

        PRINT('SUKCES - udało Ci się zakupić tą nieruchmość!')
    END
    ELSE BEGIN
        PRINT('BŁĄD - nieruchomość o podanym ID nie istenieje lub nie jest obecnie dostępna!')
    END
GO

CREATE PROCEDURE Rezerwacja (@OfferID INT, @CustomerID INT, @Start DATETIME, @End DATETIME)
AS
    IF @OfferID IN (SELECT ID_oferty FROM Wszystkie_oferty) BEGIN
        DECLARE @EstateID INT = (SELECT ID_nieruchomości FROM Wszystkie_oferty WHERE ID_oferty = @OfferID)

        IF @OfferID IN (SELECT ID_aktualne FROM Aktualne) BEGIN
            IF @Start < @End BEGIN                    
                DECLARE @employee INT = (SELECT Pracownik_obsługujący FROM Wszystkie_oferty WHERE ID_oferty = @OfferID)
                IF @employee IN (SELECT Pracownik_obsługujący FROM Rezerwacje INNER JOIN Wszystkie_oferty ON Rezerwacje.ID_oferty = Wszystkie_oferty.ID_oferty WHERE (@Start < Początek AND @End < Początek) OR (@Start > Początek AND @End > Koniec)) BEGIN
                    INSERT INTO Rezerwacje(ID_oferty, ID_klienta, Początek, Koniec) VALUES (@OfferID, @CustomerID, @Start, @End)
                    PRINT('SUKCES - pomyślnie dodano rezerwację!')
                END
                ELSE BEGIN
                    PRINT('BŁĄD - pracownik obsługujący ogłosznie jest w danym terminie zajęty!')
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

CREATE PROCEDURE DodajOpinię (@CustomerID INT, @OfferID INT, @Grade INT, @Description VARCHAR(MAX))
AS
    IF @OfferID IN (SELECT ID_sprzedane FROM Sprzedane WHERE ID_kupującego = @CustomerID) BEGIN
        IF (@OfferID NOT IN (SELECT ID_oferty FROM Opinie)) BEGIN
            INSERT INTO Opinie(ID_oferty, Data_wystawienia_opinii, Ocena, Opis) VALUES (@OfferID, GETDATE(), @Grade, @Description)
            PRINT('SUKCES - pomyślnie dodano opinię!')
        END
        ELSE BEGIN
            PRINT('BŁĄD - zamieściłeś już opinię odnośnie tej nieruchomości!')
        END
    END
    ELSE BEGIN
        PRINT('BŁĄD - klient o podanym ID nie istnieje, nie zakupił żadnej nieruchomości lub tej o podanym ID!')
    END
GO