--Tworzenie tabeli dla lekarz
DROP TABLE tab_Lekarze;

CREATE TABLE tab_Lekarze OF type_LEKARZE(
    LekarzID PRIMARY KEY
);


--Tworzenie tabeli dla Pracownicy
DROP TABLE tab_Pracownicy;

CREATE TABLE tab_Pracownicy OF type_pracownicy(
   pracownikID PRIMARY KEY
);


--Tworzenie tabeli dla klienci
DROP TABLE tab_Klienci;

CREATE TABLE tab_Klienci OF type_KLIENCI(
   KLIENTID PRIMARY KEY
);


--Tworzenie tabeli dla kategoria
DROP TABLE tab_Kategorie;

CREATE TABLE tab_Kategorie OF type_kategorie(
    kategoriaID PRIMARY KEY
);


--Tworzenie tabeli dla Produkty
DROP TABLE tab_Produkty;

CREATE TABLE tab_Produkty OF type_produkty(
    produktID PRIMARY KEY,
    SCOPE FOR(kategoria) IS tab_kategorie
);


--Tworzenie tabeli dla platnosci
DROP TABLE tab_Platnosci;

CREATE TABLE tab_Platnosci OF type_platnosci(
    platnoscID PRIMARY KEY
);


--Tworzenie tabeli dla transakcje
DROP TABLE tab_TRANSAKCJE;

CREATE TABLE tab_TRANSAKCJE OF type_TRANSAKCJE(
    TRANSAKCJAID PRIMARY KEY,
    SCOPE FOR(pracownik) IS tab_Pracownicy,
    SCOPE FOR(platnosc) IS tab_Platnosci
);


--Tworzenie tabeli dla Zamowienia
DROP TABLE tab_Zamowienia;

CREATE TABLE tab_Zamowienia OF type_Zamowienia(
    zamowienieID PRIMARY KEY,
    SCOPE FOR(produkt) IS tab_Produkty,
    SCOPE FOR(pracownik) IS tab_Pracownicy
);


--Tworzenie tabeli dla recepta
DROP TABLE tab_Recepty;

CREATE TABLE tab_Recepty OF type_recepty(
	RECEPTAID PRIMARY KEY,
    SCOPE FOR(lekarz) IS tab_lekarze,
	SCOPE FOR(klient) IS tab_klienci
);


--Tworzenie tabeli dla szczegoly_transakcji
DROP TABLE tab_szczegolyTRANSAKcji;

CREATE TABLE tab_szczegolyTRANSAKcji OF type_szczegolytransakcji(
    SCOPE FOR(transakcja) IS tab_Transakcje,
    SCOPE FOR(recepta) IS tab_Recepty,
    SCOPE FOR(produkt) IS tab_Produkty
);



--Tworzenie tabeli dla recepty
DROP TABLE tab_Recepty;

CREATE TABLE tab_Recepty OF type_recepty(
    receptaID PRIMARY KEY,
    SCOPE FOR(lekarz) IS tab_Lekarze,
	SCOPE FOR(klient) IS tab_Klienci
);


--Tworzenie tabeli dla szczegoly_transakcji
DROP TABLE tab_szczegolyRecept;

CREATE TABLE tab_szczegolyRecept OF type_SZCZEGOLYRECEPT(
    SCOPE FOR(recepta) IS tab_Recepty,
    SCOPE FOR(produkt) IS tab_Produkty
);


--Tworzenie tabeli dla magazyn
DROP TABLE tab_Magazyn;

CREATE TABLE tab_Magazyn OF type_magazyn(
    MAGAZYNID PRIMARY KEY,
    SCOPE FOR(produkt) IS tab_Produkty
);


--Tworzenie tabeli dla magazyn
DROP TABLE tab_StanMagazynowy;

CREATE TABLE tab_StanMagazynowy OF type_StanMagazynowy(
    SCOPE FOR(produkt) IS tab_Produkty
);