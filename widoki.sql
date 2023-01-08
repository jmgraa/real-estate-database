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
GO

CREATE VIEW Liczba_ofert_w_miesiacu AS
	SELECT MONTH(Data_wystawienia) AS [Numer Miesiaca], COUNT(MONTH(Data_wystawienia)) AS [Liczba ofert w miesiacu] FROM Wszystkie_oferty
	GROUP BY MONTH(Data_wystawienia)
GO


CREATE VIEW Suma_wartosci AS
	SELECT Miejscowość, SUM(Cena) AS [Suma nieruchomosci] FROM Nieruchomości
	GROUP BY Miejscowość
GO
 
CREATE FUNCTION Aktualne_z_miasta(@x VARCHAR(MAX))
RETURNS TABLE
AS
RETURN
    SELECT * FROM Nieruchomości N
	LEFT JOIN Aktualne A ON
	N.ID_nieruchomości = A.ID_aktualne
	WHERE N.Miejscowość = @x;

CREATE FUNCTION Oferty_typu(@x VARCHAR(MAX))
RETURNS @result TABLE (ID_nieruchomosci int, Ulica VARCHAR(MAX), Numer int,Miejscowość VARCHAR(MAX),Powierzchnia INT,Cena INT, Możliwość_negocjacji_ceny BIT)
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
GO
	
	
CREATE VIEW Obrót_pracowników AS
	SELECT Osoby.Imię, Osoby.Nazwisko, SUM(Nieruchomości.Cena) AS [Suma sprzedanych nieruchomości] FROM Pracownicy 
	LEFT JOIN Osoby ON
	Pracownicy.ID_pracownika = Osoby.Pesel
	LEFT JOIN Wszystkie_oferty ON
	Pracownicy.ID_pracownika = Wszystkie_oferty.Pracownik_obsługujący
	LEFT JOIN Nieruchomości ON
		Wszystkie_oferty.ID_nieruchomości = Nieruchomości.ID_nieruchomości
	LEFT JOIN Sprzedane ON
	Sprzedane.ID_sprzedane = Wszystkie_oferty.ID_nieruchomości
	GROUP BY Osoby.Imię, Osoby.Nazwisko
GO
