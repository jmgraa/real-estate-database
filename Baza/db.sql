IF OBJECT_ID('Domy','U') IS NOT NULL
	DROP TABLE Domy
GO
IF OBJECT_ID('Mieszkania','U') IS NOT NULL
	DROP TABLE Mieszkania
GO
IF OBJECT_ID('Działki','U') IS NOT NULL
	DROP TABLE Działki
GO
IF OBJECT_ID('Cechy_nieruchomości','U') IS NOT NULL
	DROP TABLE Cechy_nieruchomości
GO
IF OBJECT_ID('Rezerwacje','U') IS NOT NULL
	DROP TABLE Rezerwacje
GO
IF OBJECT_ID('Terminy_oglądania','U') IS NOT NULL
	DROP TABLE Terminy_oglądania
GO
IF OBJECT_ID('Oferty_kupna', 'U') IS NOT NULL
    DROP TABLE Oferty_kupna
GO
IF OBJECT_ID('Aktualne', 'U') IS NOT NULL
    DROP TABLE Aktualne
GO
IF OBJECT_ID('Niesprzedane', 'U') IS NOT NULL
    DROP TABLE Niesprzedane
GO
IF OBJECT_ID('Opinie','U') IS NOT NULL
	DROP TABLE Opinie
GO
IF OBJECT_ID('Sprzedane', 'U') IS NOT NULL
    DROP TABLE Sprzedane
GO
IF OBJECT_ID('Wszystkie_oferty', 'U') IS NOT NULL
    DROP TABLE Wszystkie_oferty
GO
IF OBJECT_ID('Trendy_rynkowe','U') IS NOT NULL
	DROP TABLE Trendy_rynkowe
GO
IF OBJECT_ID('Klienci','U') IS NOT NULL
	DROP TABLE Klienci
GO
IF OBJECT_ID('Pracownicy','U') IS NOT NULL
	DROP TABLE Pracownicy
GO
IF OBJECT_ID('Osoby', 'U') IS NOT NULL
    DROP TABLE Osoby
GO
IF OBJECT_ID('Nieruchomości','U') IS NOT NULL
	DROP TABLE Nieruchomości
GO

CREATE TABLE Nieruchomości (
	ID_nieruchomości INT IDENTITY(1,1) PRIMARY KEY,

	Ulica VARCHAR(MAX) NULL,
	Numer INT NOT NULL,
	Miejscowość VARCHAR(MAX) NOT NULL,

	Powierzchnia INT NOT NULL,
	Cena INT NOT NULL,
    Możliwość_negocjacji_ceny BIT NOT NULL,

    CHECK (Numer >= 0),
    CHECK (Powierzchnia > 0),
    CHECK (Cena > 0)
)

CREATE TABLE Domy (
    ID_domu INT REFERENCES Nieruchomości PRIMARY KEY,

    Rodzaj_zabudowy VARCHAR(MAX) NOT NULL,
    Liczba_pokoi INT NOT NULL,
    Liczba_pięter INT NOT NULL,
    Rodzaj_ogrzewania VARCHAR(MAX) NOT NULL,

    CHECK (Liczba_pokoi > 0),
    CHECK (Liczba_pięter >= 0)
)

CREATE TABLE Mieszkania (
    ID_mieszkania INT REFERENCES Nieruchomości PRIMARY KEY,

    Numer_mieszkania INT NOT NULL,
    Rodzaj_zabudowy VARCHAR(MAX) NOT NULL,
    Piętro INT NOT NULL,
    Ogrzewanie_z_sieci BIT NOT NULL,
    Winda_w_budynku BIT NOT NULL,

    CHECK (Numer_mieszkania >= 0)
)

CREATE TABLE Działki (
    ID_działki INT REFERENCES Nieruchomości PRIMARY KEY,

    Rodzaj_dzialki VARCHAR(MAX) NOT NULL,
    Dostep_do_pradu BIT NOT NULL,
    Dostep_do_gazu BIT NOT NULL,
    Dostep_do_wody BIT NOT NULL,
    Dostep_do_kanalizacji BIT NOT NULL,
)

CREATE TABLE Osoby (
    Pesel VARCHAR(11) PRIMARY KEY,

    Imię VARCHAR(MAX) NOT NULL,
    Nazwisko VARCHAR(MAX) NOT NULL,
    Numer_telefonu VARCHAR(12) NOT NULL
)

CREATE TABLE Klienci (
	ID_klienta VARCHAR(11) REFERENCES Osoby PRIMARY KEY,

    Adres_email VARCHAR(MAX) NULL
)

CREATE TABLE Pracownicy (
	ID_pracownika VARCHAR(11) REFERENCES Osoby PRIMARY KEY,

    Liczba_aktualnych_zleceń INT DEFAULT 0,
    Stanowisko VARCHAR(MAX) NOT NULL,

    CHECK (Liczba_aktualnych_zleceń >= 0)
)

CREATE TABLE Cechy_nieruchomości (
    ID_nieruchomości INT NOT NULL,
    Nazwa_cechy VARCHAR(450) NOT NULL,

    CONSTRAINT ID_cechy PRIMARY KEY (ID_nieruchomości, Nazwa_cechy),

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości)
)

CREATE TABLE Wszystkie_oferty (
    ID_oferty INT IDENTITY(1,1) PRIMARY KEY,

    ID_nieruchomości INT NOT NULL,
    Pracownik_obsługujący VARCHAR(11) DEFAULT NULL,
    Data_wystawienia DATETIME NOT NULL,
    Data_zakończenia DATETIME NOT NULL,

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY (Pracownik_obsługujący) REFERENCES Pracownicy(ID_pracownika),

    CHECK (Data_wystawienia < Data_zakończenia)
)

CREATE TABLE Aktualne (
    ID_aktualne INT REFERENCES Wszystkie_oferty PRIMARY KEY
)

CREATE TABLE Niesprzedane (
    ID_niesprzedane INT REFERENCES Wszystkie_oferty PRIMARY KEY
)

CREATE TABLE Sprzedane (
    ID_sprzedane INT REFERENCES Wszystkie_oferty PRIMARY KEY,

    ID_kupującego VARCHAR(11) NOT NULL,
    Data_sprzedania DATETIME NOT NULL,    
    Mnożnik_ceny FLOAT DEFAULT 1,

    FOREIGN KEY (ID_kupującego) REFERENCES Klienci(ID_klienta),

    CHECK (Mnożnik_ceny > 0)
)

CREATE TABLE Terminy_oglądania (
    ID_terminu INT IDENTITY(1,1) PRIMARY KEY,

    ID_oferty INT NOT NULL,
    ID_oglądającego VARCHAR(11) NOT NULL,
    Data_zwiedzania_początek DATETIME NOT NULL,
    Data_zwiedzania_koniec DATETIME NOT NULL,
    
    FOREIGN KEY (ID_oferty) REFERENCES Aktualne(ID_aktualne) ON DELETE CASCADE,
    FOREIGN KEY (ID_oglądającego) REFERENCES Klienci(ID_klienta),

    CHECK (Data_zwiedzania_początek < Data_zwiedzania_koniec)    
)

CREATE TABLE Trendy_rynkowe (
    ID_trendu INT IDENTITY(1,1) PRIMARY KEY,

    Nazwa_trendu VARCHAR(MAX) NOT NULL,
    Rozpoczęcie DATETIME NOT NULL,
    Zakończenie DATETIME NULL,
    Miejscowość VARCHAR(450) NOT NULL UNIQUE,
    Zmiana_mnożnika FLOAT NOT NULL,

    CHECK (Rozpoczęcie < Zakończenie),
    CHECK (Zmiana_Mnożnika > 0 AND Zmiana_Mnożnika <= 1)
)

CREATE TABLE Rezerwacje (
    ID_rezerwacji INT IDENTITY(1,1) PRIMARY KEY,
    ID_oferty INT NOT NULL,
    ID_klienta VARCHAR(11) NOT NULL,
    Początek DATETIME NOT NULL,
    Koniec DATETIME NOT NULL,

    FOREIGN KEY (ID_oferty) REFERENCES Aktualne(ID_aktualne) ON DELETE CASCADE,
    FOREIGN KEY (ID_klienta) REFERENCES Klienci(ID_klienta),

    CHECK (Początek < Koniec)
)

CREATE TABLE Opinie (
    ID_opinii INT IDENTITY(1,1) PRIMARY KEY,

    ID_oferty INT NOT NULL,
    Data_wystawienia_opinii DATETIME NOT NULL,
    Ocena INT NOT NULL,
    Opis VARCHAR(MAX) NULL,

    FOREIGN KEY (ID_oferty) REFERENCES Sprzedane(ID_sprzedane),

    CHECK (Ocena BETWEEN 0 AND 10)
)