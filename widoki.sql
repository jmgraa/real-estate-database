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