-- Tworzenie obiektu lekarze
CREATE OR REPLACE TYPE type_LEKARZE AS OBJECT (
	LEKARZID INT, 
	IMIE VARCHAR2(50), 
    NAZWISKO VARCHAR2(50), 
	NRTELEFONU VARCHAR2(15) 
);

-- Tworzenie obiektu pracownicy
CREATE OR REPLACE TYPE type_pracownicy AS OBJECT ( 
    pracownikID INT, 
    imie VARCHAR2(50), 
    nazwisko VARCHAR2(50), 
    dataUrodzenia DATE, 
    wiek INTEGER, 
    nrTelefonu VARCHAR2(12), 
    pensja NUMBER(6,2), 
    premia NUMBER(6,2) 
);

-- Tworzenie obiektu klienci
CREATE OR REPLACE TYPE type_KLIENCI AS OBJECT ( 
	KLIENTID INT, 
	IMIE VARCHAR2(50), 
	NAZWISKO VARCHAR2(50), 
	PESEL VARCHAR2(11), 
	DATAURODZENIA DATE, 
	WIEK NUMBER,
	NRTELEFONU VARCHAR2(15), 
	EMAIL VARCHAR2(50) 
);

-- Tworzenie obiektu kategoria
CREATE OR REPLACE TYPE type_kategorie AS OBJECT ( 
    kategoriaID INT,
    nazwaKategorii VARCHAR2(50)
);  

-- Tworzenie obiektu produkty
CREATE OR REPLACE TYPE type_produkty AS OBJECT ( 
    produktID INT, 
    nazwaProduktu VARCHAR2(200), 
    cenaProduktu NUMBER(10,2), 
    dataProdukcji DATE, 
    dataWaznosci DATE, 
    dostepnosc VARCHAR2(40), 
    opis VARCHAR2(500),
    kategoria ref type_kategorie,
	
	MEMBER PROCEDURE wyswietl_,
    MEMBER PROCEDURE zmien_cene(nowa_cena NUMBER)
);
	
create or replace NONEDITIONABLE TYPE BODY TYPE_PRODUKTY AS
    MEMBER PROCEDURE wyswietl_ IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('ProduktID: ' || self.produktID);
        DBMS_OUTPUT.PUT_LINE('Nazwa Produktu: ' || self.nazwaProduktu);
        DBMS_OUTPUT.PUT_LINE('Cena Produktu: ' || self.cenaProduktu);
        DBMS_OUTPUT.PUT_LINE('Data Produkcji: ' || TO_CHAR(self.dataProdukcji, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Data Waznosci: ' || TO_CHAR(self.dataWaznosci, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Dostepnoscć: ' || self.dostepnosc);
        DBMS_OUTPUT.PUT_LINE('Opis: ' || self.opis);
    
    END;
    
    MEMBER PROCEDURE zmien_cene(nowa_cena NUMBER) IS
    BEGIN 
        SELF.cenaProduktu :=nowa_cena;
    END;
    
END;

-- Tworzenie obiektu platnosci
CREATE OR REPLACE TYPE type_platnosci AS OBJECT ( 
    platnoscID INT,
    nazwaPlatnosci VARCHAR2(50)
); 

-- Tworzenie obiektu TRANSAKCJA
CREATE OR REPLACE TYPE TYPE_TRANSAKCJE AS OBJECT ( 
    TRANSAKCJAID INT, 
    DATAWYKONANIA DATE, 
    PRACOWNIK REF type_Pracownicy, 
    PLATNOSC REF type_Platnosci
);

-- Tworzenie obiektu Zamowienia
CREATE OR REPLACE TYPE type_zamowienia AS OBJECT ( 
    zamowienieID INT, 
    ilosc NUMBER(6,2), 
    status VARCHAR2(40),
    data_zamowienia date,
    produkt REF type_Produkty, 
    pracownik REF type_pracownicy
);

-- Tworzenie obiektu Recepta
CREATE OR REPLACE TYPE type_recepty AS OBJECT ( 
    RECEPTAID INT, 
    DATAWYSTAWIENIA DATE, 
    DATAWAZNOSCI DATE, 
    KODDOSTEPU NUMBER(6), 
    LEKARZ REF type_Lekarze,
    Klient ref type_Klienci
);

-- Tworzenie obiektu szczegoly_transakcji
CREATE OR REPLACE TYPE type_SZCZEGOLYTRANSAKCJI AS OBJECT ( 
    TRANSAKCJA REF TYPE_TRANSAKCJE, 
    RECEPTA REF type_RECEPTY, 
    PRODUKT REF TYPE_PRODUKTY, 
    ILOSC NUMBER
);


-- Tworzenie obiektu SZCZEGOLYRECEPT
CREATE OR REPLACE TYPE type_SZCZEGOLYRECEPT AS OBJECT ( 
    RECEPTA REF type_Recepty, 
    PRODUKT REF type_Produkty,
    STATUS VARCHAR2(40), 
    ILOSC_WYDANA NUMBER(10,2), 
    ILOSC_do_WYDANIA NUMBER(10,2) 
);


-- Tworzenie obiektu stan_magazynowy
CREATE TYPE type_StanMagazynowy AS OBJECT ( 
    Produkt ref type_produkty, 
    IloscNaStanie NUMBER, 
    DataAktualizacji DATE 
);
