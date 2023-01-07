IF OBJECT_ID('Dodaj_do_aktualne', 'TR') IS NOT NULL
    DROP TRIGGER Dodaj_do_aktualne
GO

IF OBJECT_ID('Dodaj_do_niesprzedane', 'TR') IS NOT NULL
    DROP TRIGGER Dodaj_do_niesprzedane
GO

IF OBJECT_ID('Aktualizuj_ceny2', 'TR') IS NOT NULL
    DROP TRIGGER Aktualizuj_ceny2
GO

IF OBJECT_ID('Usun_z_aktualne', 'TR') IS NOT NULL
    DROP TRIGGER Usun_z_aktualne
GO

CREATE TRIGGER Dodaj_do_aktualne
ON Wszystkie_oferty
AFTER INSERT
AS
BEGIN
  IF (EXISTS(SELECT * FROM inserted WHERE Data_zakończenia > GETDATE()))
	BEGIN
    INSERT INTO Aktualne_oferty(ID_aktualne) VALUES
		SELECT ID_oferty FROM INSERTED;
  END;
END;
GO

CREATE TRIGGER Dodaj_do_niesprzedane
ON Wszystkie_oferty
AFTER INSERT
AS
BEGIN
    IF (EXISTS(SELECT 1 FROM inserted WHERE Data_zakończenia > GETDATE()))
	BEGIN
        INSERT INTO Niesprzedane(ID_niesprzedane)
		SELECT ID_oferty
		FROM inserted;
    END;
END;
GO

CREATE TRIGGER Aktualizuj_ceny2
ON Trendy_rynkowe
AFTER INSERT
AS
BEGIN
UPDATE nieruchomości
SET nieruchomości.Cena = nieruchomości.Cena + nieruchomości.Cena * i.Zmiana_Mnożnika
FROM nieruchomości
INNER JOIN inserted i
  ON nieruchomości.Miejscowość = i.Miejscowość
WHERE i.Nazwa_trendu = 'wzrost' AND i.Rozpoczęcie < GETDATE() AND i.Zakończenie > GETDATE()

UPDATE nieruchomości
SET nieruchomości.Cena = nieruchomości.Cena - nieruchomości.Cena * i.Zmiana_Mnożnika
FROM nieruchomości
INNER JOIN inserted i
  ON nieruchomości.Miejscowość = i.Miejscowość
WHERE i.Nazwa_trendu = 'spadek' AND i.Rozpoczęcie < GETDATE() AND i.Zakończenie > GETDATE()
END
GO

CREATE TRIGGER Usun_z_aktualne
ON Rezerwacje
AFTER INSERT
AS
DELETE FROM Aktualne_oferty
WHERE Aktualne_oferty.ID_aktualne = (SELECT Rezerwacje.ID_nieruchomości FROM inserted i JOIN Rezerwacje ON i.ID_nieruchomości = Rezerwacje.ID_nieruchomości)
GO