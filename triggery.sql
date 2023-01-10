IF OBJECT_ID('Dodanie_trendu', 'TR') IS NOT NULL
    DROP TRIGGER Dodanie_trendu
GO

IF OBJECT_ID('Przydzielenie_pracownika', 'TR') IS NOT NULL
    DROP TRIGGER Przydzielenie_pracownika
GO

IF OBJECT_ID('Zwolnienie_pracownika_sprzedane', 'TR') IS NOT NULL
    DROP TRIGGER Zwolnienie_pracownika_sprzedane
GO

IF OBJECT_ID('Zwolnienie_pracownika_niesprzedane', 'TR') IS NOT NULL
    DROP TRIGGER Zwolnienie_pracownika_niesprzedane
GO

IF OBJECT_ID('Zarezerwowanie', 'TR') IS NOT NULL
    DROP TRIGGER Zarezerwowanie
GO

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

CREATE TRIGGER Koniec_rezerwacji
ON Rezerwacje
AFTER DELETE
AS
BEGIN
    INSERT INTO Aktualne SELECT ID_oferty FROM DELETED 
END
GO