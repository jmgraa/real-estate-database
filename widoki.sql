
CREATE VIEW Ranking_pracowników AS
SELECT Os.Imię, Os.Nazwisko, P.ID_pracownika, AVG(O.Ocena) AS Średnia_ocena FROM Opinie O
INNER JOIN Wszystkie_oferty W ON
W.ID_oferty = O.ID_Oferty
INNER JOIN Pracownicy P ON
W.Pracownik_obsługujący = P.ID_pracownika
INNER JOIN Osoby Os ON
Os.Pesel = P.ID_pracownika
GROUP BY P.ID_pracownika,Os.Imię, Os.Nazwisko
ORDER BY Średnia_ocena DESC


CREATE VIEW Liczba_ofert_w_miesiacu AS
SELECT MONTH(Data_wystawienia) AS [Numer Miesiaca], COUNT(MONTH(Data_wystawienia)) AS [Liczba ofert w miesiacu] FROM Wszystkie_oferty
GROUP BY MONTH(Data_wystawienia)

CREATE VIEW Suma_wartosci AS
SELECT Miejscowość, SUM(Cena) AS [Suma nieruchomosci] FROM Nieruchomości
GROUP BY Miejscowość


CREATE FUNCTION (@x VARCHAR(200))
RETURNS TABLE
AS
RETURN
    SELECT * FROM Nieruchomości N
	LEFT JOIN Aktualne_oferty A ON
	N.ID_nieruchomości = A.ID_aktualne
	WHERE N.Miejscowość = @x;
  
  
 
 
CREATE FUNCTION Aktualne_oferty_z_miasta(@x VARCHAR(200))
RETURNS TABLE
AS
RETURN
    SELECT * FROM Nieruchomości N
	LEFT JOIN Aktualne_oferty A ON
	N.ID_nieruchomości = A.ID_aktualne
	WHERE N.Miejscowość = @x;
	



CREATE FUNCTION Oferty_typu(@x VARCHAR(200))
RETURNS @result TABLE (ID_nieruchomosci int, Ulica VARCHAR(200), Numer int,Miejscowość VARCHAR(200),Powierzchnia INT,Cena INT, Możliwość_negocjacji_ceny BIT)
AS
BEGIN

	IF @x = 'Domy'
	BEGIN
		INSERT INTO @result
		SELECT N.ID_nieruchomości, N.Ulica, N.Numer, N.Miejscowość, N.Powierzchnia, N.Cena, N.Możliwość_negocjacji_ceny FROM Domy
		LEFT JOIN Nieruchomości N ON
		ID_domu = N.ID_nieruchomości
	END
	ELSE IF @x = 'Działki'
	BEGIN
		INSERT INTO @result
		SELECT N.ID_nieruchomości, N.Ulica, N.Numer, N.Miejscowość, N.Powierzchnia, N.Cena, N.Możliwość_negocjacji_ceny FROM Działki
		LEFT JOIN Nieruchomości N ON
		ID_działki = N.ID_nieruchomości
	END
	ELSE IF @x = 'Mieszkania'
	BEGIN
		INSERT INTO @result
		SELECT N.ID_nieruchomości, N.Ulica, N.Numer, N.Miejscowość, N.Powierzchnia, N.Cena, N.Możliwość_negocjacji_ceny FROM Mieszkania
		LEFT JOIN Nieruchomości N ON
		ID_mieszkania = N.ID_nieruchomości
	END
	ELSE
	BEGIN
		INSERT INTO @result
		SELECT NULL, NULL, NULL, NULL, NULL,NULL,NULL
		END
	RETURN
END





CREATE VIEW Ilosc_terminow_pracownikow AS
SELECT O.Imię, O.Nazwisko, O.Numer_telefonu, COUNT(Id_terminu) AS [Ilość zarezerwowanych terminów] FROM Osoby O
INNER JOIN Pracownicy P ON
O.Pesel = P.ID_pracownika
LEFT JOIN Terminy_oglądania T ON
O.Pesel = T.ID_pracownika
GROUP BY O.Imię, O.Nazwisko, O.Numer_telefonu
