
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
