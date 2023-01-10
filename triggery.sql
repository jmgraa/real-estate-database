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
IF OBJECT_ID('KoniecRezerwacji', 'TR') IS NOT NULL
    DROP TRIGGER KoniecRezerwacji
GO

CREATE TRIGGER DodanieTrendu
ON Trendy_rynkowe
AFTER INSERT
AS
BEGIN
    DECLARE @multiplier FLOAT = (SELECT Zmiana_Mnożnika FROM INSERTED)
    DECLARE @place VARCHAR(MAX) = (SELECT Miejscowość FROM INSERTED)

    IF ((SELECT Nazwa_trendu FROM INSERTED) = 'wzrost')
    BEGIN
        UPDATE Nieruchomości        
            SET Nieruchomości.Cena = Nieruchomości.Cena * (1 + @multiplier) 
            WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
    END

    ELSE IF ((SELECT Nazwa_trendu FROM INSERTED) = 'spadek')
    BEGIN
        UPDATE Nieruchomości
            SET Nieruchomości.Cena = Nieruchomości.Cena * (1 - @multiplier) 
            WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
    END
END
GO

CREATE TRIGGER KoniecTrendu
ON Trendy_rynkowe
AFTER DELETE
AS
BEGIN
    DECLARE @multiplier FLOAT = (SELECT Zmiana_Mnożnika FROM DELETED)
    DECLARE @place VARCHAR(MAX) = (SELECT Miejscowość FROM DELETED)

    IF ((SELECT Nazwa_trendu FROM DELETED) = 'wzrost')
    BEGIN
        UPDATE Nieruchomości        
            SET Nieruchomości.Cena = Nieruchomości.Cena * 100 / (1 + @multiplier) 
            WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
    END

    ELSE IF ((SELECT Nazwa_trendu FROM DELETED) = 'spadek')
    BEGIN
        UPDATE Nieruchomości
            SET Nieruchomości.Cena = Nieruchomości.Cena * 100 / (1 - @multiplier)
            WHERE Nieruchomości.Miejscowość = @place AND Nieruchomości.ID_nieruchomości IN (SELECT ID_aktualne FROM Aktualne)
    END
END
GO

CREATE TRIGGER PrzydzieleniePracownika
ON Wszystkie_oferty
AFTER INSERT
AS
BEGIN
    DECLARE @employee INT = (SELECT TOP 1 ID_pracownika FROM Pracownicy ORDER BY Liczba_aktualnych_zleceń ASC)

    UPDATE Pracownicy
        SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń + 1
        WHERE ID_pracownika = @employee

    UPDATE Wszystkie_oferty
        SET Pracownik_obsługujący = @employee
        WHERE ID_oferty = (SELECT TOP 1 ID_oferty FROM Wszystkie_oferty ORDER BY ID_oferty DESC)
END
GO

CREATE TRIGGER ZwolnieniePracownikaSprzedane
ON Sprzedane
AFTER INSERT
AS
BEGIN
    DECLARE @employee INT = (SELECT Pracownik_obsługujący FROM INSERTED INNER JOIN Wszystkie_oferty ON INSERTED.ID_sprzedane = Wszystkie_oferty.ID_oferty)

    UPDATE Pracownicy
        SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń - 1
        WHERE ID_pracownika = @employee
END
GO

CREATE TRIGGER ZwolnieniePracownikaNiesprzedane
ON Niesprzedane
AFTER INSERT
AS
BEGIN
    DECLARE @employee INT = (SELECT Pracownik_obsługujący FROM INSERTED INNER JOIN Wszystkie_oferty ON INSERTED.ID_niesprzedane = Wszystkie_oferty.ID_oferty)

    UPDATE Pracownicy
        SET Liczba_aktualnych_zleceń = Liczba_aktualnych_zleceń - 1
        WHERE ID_pracownika = @employee
END
GO

CREATE TRIGGER KoniecRezerwacji
ON Rezerwacje
AFTER DELETE
AS
BEGIN
    INSERT INTO Aktualne SELECT ID_oferty FROM DELETED 
END
GO