IF OBJECT_ID('Cechy_nieruchomości','U') IS NOT NULL
	DROP TABLE Cechy_nieruchomości

IF OBJECT_ID('Terminy_oglądania','U') IS NOT NULL
	DROP TABLE Terminy_oglądania

IF OBJECT_ID('Oferty_kupna', 'U') IS NOT NULL
    DROP TABLE Oferty_kupna

IF OBJECT_ID('Sprzedane_nieruchomości') IS NOT NULL
    DROP TABLE Sprzedane_nieruchomości

IF OBJECT_ID('Trendy_rynkowe','U') IS NOT NULL
	DROP TABLE Trendy_rynkowe

IF OBJECT_ID('Rezerwacje','U') IS NOT NULL
	DROP TABLE Rezerwacje

IF OBJECT_ID('Umowy','U') IS NOT NULL
	DROP TABLE Umowy

IF OBJECT_ID('Nieruchomości','U') IS NOT NULL
	DROP TABLE Nieruchomości

IF OBJECT_ID('Klienci','U') IS NOT NULL
	DROP TABLE Klienci

IF OBJECT_ID('Pracownicy','U') IS NOT NULL
	DROP TABLE Pracownicy

CREATE TABLE Nieruchomości (
	ID_nieruchomości INT PRIMARY KEY,
    Rynek VARCHAR(9),
    Rodzaj_umowy VARCHAR(8),
	Ulica VARCHAR(200) NULL,
	Numer INT NOT NULL,
	Miejscowość VARCHAR(200) NOT NULL,
    Nazwa_regionu VARCHAR(200) NULL,
	Powierzchnia INT NULL,
	Liczba_pokoi INT NULL,
	Cena INT NOT NULL,

    CHECK (Rynek LIKE 'Pierwotny' OR Rynek LIKE 'Wtórny'),
    CHECK (Rodzaj_umowy LIKE 'Wynajem' OR Rodzaj_umowy LIKE 'Kupno'),
    CHECK (Cena > 0)
)

CREATE TABLE Klienci (
	ID_klienta INT PRIMARY KEY,
	Imię VARCHAR(200) NOT NULL,
    Nazwisko VARCHAR(200) NOT NULL,
    Numer_telefonu VARCHAR(12) NOT NULL,
    Adres_email VARCHAR(200) NULL
)

CREATE TABLE Pracownicy (
	ID_pracownika INT PRIMARY KEY,
	Imię VARCHAR(200) NOT NULL,
    Nazwisko VARCHAR(200) NOT NULL,
    Numer_telefonu VARCHAR(12) NOT NULL,
    Stanowisko VARCHAR(200) NOT NULL,
)

CREATE TABLE Cechy_nieruchomości (
    ID_nieruchomości INT,
    Nazwa_cechy VARCHAR(200) NOT NULL,

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości)
)

CREATE TABLE Terminy_oglądania (
    ID_terminu INT PRIMARY KEY,
    Id_zwiedzającego INT,
    Data_zwiedzania DATETIME NOT NULL,
    Miejsce_zwiedzania INT,

    FOREIGN KEY (Id_zwiedzającego) REFERENCES Klienci(ID_klienta),    
    FOREIGN KEY (Miejsce_zwiedzania) REFERENCES Nieruchomości(ID_nieruchomości)
)

CREATE TABLE Oferty_kupna (
    ID_oferty INT PRIMARY KEY,
    ID_nieruchomości INT,
    Pracownik_obsługujący INT,
    Data_wystawienia DATETIME NOT NULL,
    Data_zakończenia DATETIME NOT NULL,

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY (Pracownik_obsługujący) REFERENCES Pracownicy(ID_pracownika),

    CHECK (Data_wystawienia < Data_zakończenia)
)

CREATE TABLE Sprzedane_nieruchomości (
    ID_sprzedanej INT PRIMARY KEY,
    ID_nieruchomości INT,
    Pracownik_obsługujący INT,
    ID_kupującego INT,
    Data_sprzedania DATETIME NOT NULL,    
    Mnożnik_ceny FLOAT DEFAULT 1,

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY (Pracownik_obsługujący) REFERENCES Pracownicy(ID_pracownika),
    FOREIGN KEY (ID_kupującego) REFERENCES Pracownicy(ID_pracownika)
)

CREATE TABLE Trendy_rynkowe (
    ID_trendu INT PRIMARY KEY,
    Rozpoczęcie DATETIME NOT NULL,
    Zakończenie DATETIME,
    Region VARCHAR(200),
    Zmiana_mnożnika FLOAT NOT NULL,

    CHECK (Rozpoczęcie < Zakończenie)
)

CREATE TABLE Rezerwacje (
    ID_nieruchomości INT,
    ID_klienta INT,
    Początek DATETIME NOT NULL,
    Koniec DATETIME NOT NULL,

    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY (ID_klienta) REFERENCES Klienci(ID_klienta),

    CHECK (Początek < Koniec)
)

CREATE TABLE Umowy (
    ID_klienta INT,
    ID_pracownika INT,
    ID_nieruchomości INT,
    Początek_najmu DATETIME NOT NULL,
    Koniec_najmu DATETIME NOT NULL,

    FOREIGN KEY (ID_klienta) REFERENCES Klienci(ID_klienta),
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika),
    FOREIGN KEY (ID_nieruchomości) REFERENCES Nieruchomości(ID_nieruchomości),

    CHECK (Początek_najmu < Koniec_najmu)
)