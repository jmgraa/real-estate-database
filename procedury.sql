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

CREATE PROCEDURE DodajDom (@Id INT, @Type VARCHAR(200), @Rooms INT, @Floors INT, @Heating VARCHAR(200))
AS
INSERT INTO Domy VALUES (@Id, @Type, @Rooms, @Floors, @Heating)
GO

CREATE PROCEDURE DodajMieszkanie @Id INT, @Type VARCHAR(200), @Floor INT, @Heating BIT, @Lift BIT
AS
INSERT INTO Mieszkania VALUES
(@Id, @Type, @Floor, @Heating, @Lift)
GO

CREATE PROCEDURE DodajDziałkę @Id INT, @Type VARCHAR(200), @Electricty BIT, @Gas BIT, @Water BIT, @Sewers BIT
AS
INSERT INTO Działki VALUES
(@Id, @Type, @Electricty, @Gas, @Water, @Sewers)
GO

CREATE PROCEDURE DodajNieruchomość (@Id INT, @Type_of_estate VARCHAR(200), @Street VARCHAR(20), @Number INT, @Place VARCHAR(200), @Space INT, @Price INT, @Negotiable BIT) 
AS
INSERT INTO Nieruchomości VALUES
(@Id, @Street, @Number, @Place, @Space, @Price, @Negotiable)

IF @Type_of_estate = 'dom' BEGIN
    EXEC DodajDom @Id, 'pies', 2, 3, 'kot'
    PRINT('Dodano ogłoszenie domu!')
END
ELSE IF @Type_of_estate = 'mieszkanie' BEGIN
    EXEC DodajMieszkanie @Id, 'słoń', 1, 0, 1
    PRINT('Dodano ogłoszenie mieszkania!')
END
ELSE IF @Type_of_estate = 'działka' BEGIN
    EXEC DodajDziałkę @Id, 'kura', 1, 0, 0, 1
    PRINT('Dodano ogłoszenie działki!')
END
ELSE BEGIN
    PRINT('ERROR')
END
GO