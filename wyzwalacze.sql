CREATE TRIGGER Dodaj_do_aktualne
ON Wszystkie_oferty
AFTER INSERT
AS
BEGIN
    IF (EXISTS(SELECT 1 FROM inserted WHERE Data_wystawienia < GETDATE()))
	BEGIN
        INSERT INTO Aktualne_oferty(ID_aktualne)
		SELECT ID_oferty
		FROM inserted;
    END;
END;



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


CREATE TRIGGER Aktualizuj_ceny
ON Trendy_rynkowe
AFTER INSERT
AS
BEGIN
  UPDATE nieruchomości
  SET nieruchomości.Cena = nieruchomości.Cena + nieruchomości.Cena * i.Zmiana_Mnożnika
  FROM nieruchomości
  INNER JOIN inserted i
    ON nieruchomości.Miejscowość = i.Miejscowość
  WHERE i.Nazwa_trendu = 'wzrost'

  UPDATE nieruchomości
  SET nieruchomości.Cena = nieruchomości.Cena - nieruchomości.Cena * i.Zmiana_Mnożnika
  FROM nieruchomości
  INNER JOIN inserted i
    ON nieruchomości.Miejscowość = i.Miejscowość
  WHERE i.Nazwa_trendu = 'spadek'
END
