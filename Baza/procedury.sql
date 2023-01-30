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