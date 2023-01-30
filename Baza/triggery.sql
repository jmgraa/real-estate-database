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