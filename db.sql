IF OBJECT_ID('Domy','U') IS NOT NULL
	DROP TABLE Domy

IF OBJECT_ID('Mieszkania','U') IS NOT NULL
	DROP TABLE Mieszkania

IF OBJECT_ID('Działki','U') IS NOT NULL
	DROP TABLE Działki

IF OBJECT_ID('Cechy_nieruchomości','U') IS NOT NULL
	DROP TABLE Cechy_nieruchomości

IF OBJECT_ID('Rezerwacje','U') IS NOT NULL
	DROP TABLE Rezerwacje

IF OBJECT_ID('Terminy_oglądania','U') IS NOT NULL
	DROP TABLE Terminy_oglądania

IF OBJECT_ID('Oferty_kupna', 'U') IS NOT NULL
    DROP TABLE Oferty_kupna

IF OBJECT_ID('Aktualne', 'U') IS NOT NULL
    DROP TABLE Aktualne

IF OBJECT_ID('Niesprzedane', 'U') IS NOT NULL
    DROP TABLE Niesprzedane

IF OBJECT_ID('Opinie','U') IS NOT NULL
	DROP TABLE Opinie

IF OBJECT_ID('Sprzedane', 'U') IS NOT NULL
    DROP TABLE Sprzedane

IF OBJECT_ID('Wszystkie_oferty', 'U') IS NOT NULL
    DROP TABLE Wszystkie_oferty

IF OBJECT_ID('Trendy_rynkowe','U') IS NOT NULL
	DROP TABLE Trendy_rynkowe

IF OBJECT_ID('Klienci','U') IS NOT NULL
	DROP TABLE Klienci

IF OBJECT_ID('Pracownicy','U') IS NOT NULL
	DROP TABLE Pracownicy

IF OBJECT_ID('Osoby', 'U') IS NOT NULL
    DROP TABLE Osoby

IF OBJECT_ID('Nieruchomości','U') IS NOT NULL
	DROP TABLE Nieruchomości

CREATE TABLE Nieruchomości (
	ID_nieruchomości INT IDENTITY(1,1) PRIMARY KEY,

	Ulica VARCHAR(MAX) NULL,
	Numer INT NOT NULL,
	Miejscowość VARCHAR(MAX) NOT NULL,

	Powierzchnia INT NOT NULL,
	Cena INT NOT NULL,
    Możliwość_negocjacji_ceny BIT NOT NULL,

    CHECK (Powierzchnia > 0),
    CHECK (Cena > 0)
)

CREATE TABLE Domy (
    ID_domu INT REFERENCES Nieruchomości PRIMARY KEY,

    Rodzaj_zabudowy VARCHAR(MAX) NOT NULL,
    Liczba_pokoi INT NOT NULL,
    Liczba_pięter INT NOT NULL,
    Rodzaj_ogrzewania VARCHAR(MAX),

    CHECK (Liczba_pokoi > 0),
    CHECK (Liczba_pięter >= 0)
)

CREATE TABLE Mieszkania (
    ID_mieszkania INT REFERENCES Nieruchomości PRIMARY KEY,

    Rodzaj_zabudowy VARCHAR(MAX),
    Piętro INT NOT NULL,
    Ogrzewanie_z_sieci BIT NOT NULL,
    Winda_w_budynku BIT NOT NULL
)

CREATE TABLE Działki (
    ID_działki INT REFERENCES Nieruchomości PRIMARY KEY,

    Rodzaj_dzialki VARCHAR(MAX),
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
)

CREATE TABLE Cechy_nieruchomości (
    ID_nieruchomości INT,
    Nazwa_cechy VARCHAR(450) NOT NULL,

    CONSTRAINT ID_cechy PRIMARY KEY (ID_nieruchomości, Nazwa_cechy),

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości)
)

CREATE TABLE Terminy_oglądania (
    ID_terminu INT PRIMARY KEY,

    ID_oglądającego VARCHAR(11) NOT NULL,
    ID_pracownika VARCHAR(11) NOT NULL,
    Data_zwiedzania DATETIME NOT NULL,
    Miejsce_zwiedzania INT NOT NULL,

    FOREIGN KEY (ID_oglądającego) REFERENCES Klienci(ID_klienta),    
    FOREIGN KEY (Miejsce_zwiedzania) REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika)
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

    FOREIGN KEY (ID_kupującego) REFERENCES Klienci(ID_klienta)
)

CREATE TABLE Trendy_rynkowe (
    ID_trendu INT IDENTITY(1,1) PRIMARY KEY,

    Nazwa_trendu VARCHAR(MAX) NOT NULL,
    Rozpoczęcie DATETIME NOT NULL,
    Zakończenie DATETIME NULL,
    Miejscowość VARCHAR(450) NOT NULL UNIQUE,
    Zmiana_mnożnika FLOAT NOT NULL,

    CHECK (Rozpoczęcie < Zakończenie)
)

CREATE TABLE Rezerwacje (
    ID_rezerwacji INT IDENTITY(1,1) PRIMARY KEY,
    ID_oferty INT NOT NULL,
    ID_klienta VARCHAR(11),
    Początek DATETIME NOT NULL,
    Koniec DATETIME NOT NULL,

    FOREIGN KEY (ID_oferty) REFERENCES Aktualne(ID_aktualne),
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