CREATE TABLE Nieruchomości (
	ID_nieruchomości INT PRIMARY KEY,
    Rodzaj_nieurchomości INT,
	Ulica VARCHAR(200) NULL,
	Numer INT NOT NULL,
	Miejscowość VARCHAR(200) NOT NULL,
    Nazwa_regionu VARCHAR(200),
	Powierzchnia INT,
	Liczba_pokoi INT,
	Cena INT,
    FOREIGN KEY Rodzaj_nieurchomości REFERENCES Rodzaje(ID_rodzaju)
)

CREATE TABLE Klienci (
	ID_klienta INT PRIMARY KEY,
	Imię VARCHAR(200),
    Nazwisko VARCHAR(200),
    Numer_telefonu VARCHAR(12),
    Adres_email VARCHAR(200)
)

CREATE TABLE Pracownicy (
	ID_pracownika INT PRIMARY KEY,
	Imię VARCHAR(200),
    Nazwisko VARCHAR(200),
    Numer_telefonu VARCHAR(12),
    Stanowisko VARCHAR(200),
)

CREATE TABLE Cechy_nieruchomości (
    ID_nieruchomości INT,
    Nazwa_cechy VARCHAR(200) NOT NULL,
    FOREIGN KEY ID_nieruchomości REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY ID_cechy REFERENCES Cechy(ID_cechy)
)

CREATE TABLE Terminy_oglądania (
    ID_terminu INT PRIMARY KEY,
    Id_zwiedzającego INT,
    Data_zwiedzania DATETIME,
    Miejsce_zwiedzania INT,
    FOREIGN KEY Id_zwiedzającego REFERENCES ID_klienta,    
    FOREIGN KEY Miejsce_zwiedzania REFERENCES Nieruchomości(ID_nieruchomości)
)

CREATE TABLE Oferty_kupna (
    ID_oferty INT PRIMARY KEY,
    ID_nieruchomości INT,
    Pracownik_obsługujący INT,
    Data_wystawienia DATETIME,
    Data_zakończenia DATETIME,
    FOREIGN KEY ID_nieruchomości REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY Pracownik_obsługujący REFERENCES Pracownicy(ID_pracownika)
)

CREATE TABLE Sprzedane_nieruchomości (
    ID_sprzedanej INT PRIMARY KEY,
    ID_nieruchomości INT,
    Pracownik_obsługujący INT,
    ID_kupującego INT,
    Data_sprzedania DATETIME,    
    Mnożnik_ceny FLOAT DEFAULT 1,
    FOREIGN KEY ID_nieruchomości REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY Pracownik_obsługujący REFERENCES Pracownicy(ID_pracownika),
    FOREIGN KEY ID_kupującego REFERENCES Pracownicy(ID_pracownika)
)

CREATE TABLE Trendy_rynkowe (
    ID_trendu INT PRIMARY KEY,
    Rozpoczęcie DATETIME,
    Zakończenie DATETIME,
    Region VARCHAR(200),
    Zmiana_mnożnika FLOAT,
    FOREIGN KEY Region REFERENCES Nieruchomości(Nazwa_regionu)
)

CREATE TABLE Rezerwacje (
    ID_nieruchomości INT,
    ID_klienta INT,
    Początek DATETIME,
    Koniec DATETIME,
    FOREIGN KEY ID_nieruchomości REFERENCES Nieruchomości(ID_nieruchomości),
    FOREIGN KEY ID_klienta REFERENCES Klienci(ID_klienta)
)

CREATE TABLE Umowy (
    ID_klienta INT,
    ID_pracownika INT,
    ID_nieruchomości INT,
    Początek_najmu DATETIME,
    Koniec_najmu DATETIME,
    FOREIGN KEY ID_klienta REFERENCES Klienci(ID_klienta),
    FOREIGN KEY ID_pracownika REFERENCES Pracownicy(ID_pracownika),
    FOREIGN KEY ID_nieruchomości REFERENCES Nieruchomości(ID_nieruchomości)
)