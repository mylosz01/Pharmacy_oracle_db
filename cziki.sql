
-- KATEGORIE

-- Tworzenie obiektu kategoria
CREATE OR REPLACE TYPE type_kategorie AS OBJECT ( 
    kategoriaID NUMBER,
    nazwaKategorii VARCHAR2(50)
); 

--Tworzenie tabeli dla kategoria
DROP TABLE tab_Kategorie;

CREATE TABLE tab_Kategorie OF type_kategorie(
    kategoriaID PRIMARY KEY
);

--Tworzenie sekwencji dla kategoria
DROP SEQUENCE SEQ_KATEGORIA;

CREATE SEQUENCE SEQ_KATEGORIA INCREMENT BY 1 START WITH 1;


-- Dodawanie obiektu kategoria
CREATE OR REPLACE PROCEDURE dodaj_kategorie(nazwa IN VARCHAR2) AS
BEGIN
    INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIA.NEXTVAL, nazwa);
    dbms_output.put_line('Kategoria: ' || nazwa || ' zostal dodany');
END;

BEGIN
    dodaj_kategorie('Tabletki');
    dodaj_kategorie('Masc');
    dodaj_kategorie('Syrop');
    dodaj_kategorie('Suplementy');
    dodaj_kategorie('Leki przeciwbólowe');
    dodaj_kategorie('Preparaty dla dzieci');


END;

-- Wyswietlenie tabeli kategorie

SELECT * FROM tab_Kategorie;

commit;




-- PRODUKTY

-- Tworzenie obiektu produkty
CREATE OR REPLACE TYPE type_produkty AS OBJECT ( 
    produktID INT, 
    nazwaProduktu VARCHAR2(200), 
    cenaProduktu NUMBER(10,2), 
    dataProdukcji DATE, 
    dataWaznosci DATE, 
    dostepnosc VARCHAR2(40), 
    opis VARCHAR2(500),
    kategoria ref type_kategorie
);

--Tworzenie tabeli dla Produkty
DROP TABLE tab_Produkty;

CREATE TABLE tab_Produkty OF type_produkty(
    produktID PRIMARY KEY,
    SCOPE FOR(kategoria) IS tab_kategorie
);

--Tworzenie sekwencji dla Produkty
DROP SEQUENCE SEQ_PRODUKTY;
CREATE SEQUENCE SEQ_PRODUKTY INCREMENT BY 1 START WITH 1;


-- Dodawanie obiektu produkt
create or replace PROCEDURE dodaj_produkt
(nazwa_produktu IN VARCHAR2 default '-',
cena_prod IN NUMBER default 1.1,
data_prod IN DATE default TO_DATE('15-01-2024','DD-MM-YY'),
data_waz IN DATE default TO_DATE('15-01-2024','DD-MM-YY'),
dostep IN VARCHAR2 default 'malo',
opis IN VARCHAR2 default '-',
id_kategorii IN INT default 1) IS
    ref_kategoria ref type_kategorie;
BEGIN

    SELECT ref(kat) INTO ref_kategoria
    FROM tab_Kategorie kat
    WHERE kat.kategoriaID = id_kategorii;

    INSERT INTO tab_Produkty(produktID,
        nazwaProduktu,
        cenaProduktu,
        dataProdukcji,
        dataWaznosci,
        dostepnosc,
        opis,
        kategoria) 
        VALUES (
    SEQ_PRODUKTY.NEXTVAL,
    nazwa_produktu,
    cena_prod,
    data_prod,
    data_waz,
    dostep,
    opis,
    ref_kategoria);
    
    dbms_output.put_line('Produkt: ' || nazwa_produktu || ' zostal dodany');
END;

BEGIN
    dodaj_produkt(
        nazwa_produktu => 'Calpol',
        cena_prod => TO_NUMBER('15,75'),
        data_prod => TO_DATE('05-12-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('05-12-2025', 'DD-MM-YYYY'),
        dostep => 'Duza',
        opis => 'Dla łagodzenia goroczki u dzieci',
        id_kategorii => 1
    );
    
    
    dodaj_produkt(
        nazwa_produktu => 'Aspiryna',
        cena_prod => TO_NUMBER('10,50'),
        data_prod => TO_DATE('10-02-2024', 'DD-MM-YYYY'),
        data_waz => TO_DATE('10-02-2026', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Preparat przeciwbólowy',
        id_kategorii => 5
    );
    
    dodaj_produkt(
        nazwa_produktu => 'Vitamin C',
        cena_prod => TO_NUMBER('5,99'),
        data_prod => TO_DATE('15-05-2024', 'DD-MM-YYYY'),
        data_waz => TO_DATE('15-05-2026', 'DD-MM-YYYY'),
        dostep => 'Mała',
        opis => 'Suplement diety z witaminą C',
        id_kategorii => 4
    );
    
    
    dodaj_produkt(
        nazwa_produktu => 'Ibuprofen 200 mg',
        cena_prod => TO_NUMBER('25,50'),
        data_prod => TO_DATE('01-03-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('01-03-2025', 'DD-MM-YYYY'),
        dostep => 'Duza',
        opis => 'Przeciwbólowy i przeciwzapalny',
        id_kategorii => 5
    );

    dodaj_produkt(
        nazwa_produktu => 'Paracetamol 500 mg',
        cena_prod => TO_NUMBER('12,75'),
        data_prod => TO_DATE('08-12-2022', 'DD-MM-YYYY'),
        data_waz => TO_DATE('08-12-2024', 'DD-MM-YYYY'),
        dostep => 'Mała',
        opis => 'Przeciwbólowy i przeciwgorączkowy',
        id_kategorii => 5
    );

    dodaj_produkt(
        nazwa_produktu => 'Magnez 400 mg',
        cena_prod => TO_NUMBER('14,50'),
        data_prod => TO_DATE('10-09-2022', 'DD-MM-YYYY'),
        data_waz => TO_DATE('10-09-2024', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Dla prawidłowego funkcjonowania miesni',
        id_kategorii => 4
    );

    dodaj_produkt(
        nazwa_produktu => 'Preparat Witaminowy dla Dzieci',
        cena_prod => TO_NUMBER('29,99'),
        data_prod => TO_DATE('15-12-2022', 'DD-MM-YYYY'),
        data_waz => TO_DATE('15-12-2024', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Zestaw witamin i minerałów dla prawidłowego rozwoju dzieci',
        id_kategorii => 6
    );
    
    dodaj_produkt(
        nazwa_produktu => 'Syrop na Kaszel dla Dzieci',
        cena_prod => TO_NUMBER('14,99'),
        data_prod => TO_DATE('22-09-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('22-09-2025', 'DD-MM-YYYY'),
        dostep => 'Duza',
        opis => 'Przeciwbólowy i przeciwkaszlowy, dla dzieci powyżej 2 lat',
        id_kategorii => 6
    );

    dodaj_produkt(
        nazwa_produktu => 'Masc rozgrzewajaca',
        cena_prod => TO_NUMBER('18,50'),
        data_prod => TO_DATE('10-06-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('10-06-2024', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Do miejscowego zastosowania przy bólach mięśniowych',
        id_kategorii => 2
    );



END;


-- Wyswietlenie tabeli produkty

SELECT * FROM tab_Produkty;

-- Wyswietlanie produktow z danej kategorii

SELECT 
 prod.*,
 DEREF(prod.kategoria).kategoriaID "ID_kategorii"
FROM tab_Produkty prod
WHERE DEREF(prod.kategoria).kategoriaID = 5;

commit;



-- PRACOWNICY

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


--Tworzenie tabeli dla Pracownicy
DROP TABLE tab_Pracownicy;

CREATE TABLE tab_Pracownicy OF type_pracownicy(
   pracownikID PRIMARY KEY
);

--Tworzenie sekwencji dla Pracownicy
DROP SEQUENCE SEQ_PRACOWNICY;

CREATE SEQUENCE SEQ_PRACOWNICY INCREMENT BY 1 START WITH 1;


-- Dodawanie obiektu Pracownik
create or replace PROCEDURE dodaj_pracownika
(imiee IN VARCHAR2 default '-',
nazwiskoo IN VARCHAR2 default '-',
data_urodz IN DATE default TO_DATE('15-01-2024','DD-MM-YY'),
wiekk IN INT default 1,
nr_tel IN VARCHAR2 default '000000000',
pensjaa IN NUMBER default 1000,
premiaa IN NUMBER default 0) IS
BEGIN

    INSERT INTO tab_Pracownicy(pracownikID,
        imie,
        nazwisko,
        dataUrodzenia,
        wiek,
        nrTelefonu,
        pensja,
        premia) 
        VALUES (
    SEQ_PRACOWNICY.NEXTVAL,
    imiee,
    nazwiskoo,
    data_urodz,
    wiekk,
    nr_tel,
    pensjaa,
    premiaa);
    
    dbms_output.put_line('Pracownik: ' || imiee || ' ' || nazwiskoo || ' zostal dodany');
END;

BEGIN
    dodaj_pracownika(
        imiee => 'Kamil',
        nazwiskoo => 'Olszewski',
        data_urodz => TO_DATE('05-04-1997', 'DD-MM-YYYY'),
        wiekk => 25,
        nr_tel => '555555555',
        pensjaa => TO_NUMBER('3000'),
        premiaa => TO_NUMBER('0')
    );
    
    dodaj_pracownika(
        imiee => 'Anna',
        nazwiskoo => 'Nowak',
        data_urodz => TO_DATE('20-08-1990', 'DD-MM-YYYY'),
        wiekk => 31,
        nr_tel => '123456789',
        pensjaa => TO_NUMBER('3500'),
        premiaa => TO_NUMBER('0')
    );

    dodaj_pracownika(
        imiee => 'Tomasz',
        nazwiskoo => 'Kowalski',
        data_urodz => TO_DATE('15-05-1985', 'DD-MM-YYYY'),
        wiekk => 36,
        nr_tel => '987654321',
        pensjaa => TO_NUMBER('4000'),
        premiaa => TO_NUMBER('300')
    );

    dodaj_pracownika(
        imiee => 'Ewa',
        nazwiskoo => 'Wójcik',
        data_urodz => TO_DATE('10-12-1995', 'DD-MM-YYYY'),
        wiekk => 26,
        nr_tel => '111222333',
        pensjaa => TO_NUMBER('3200'),
        premiaa => TO_NUMBER('0')
    );

    dodaj_pracownika(
        imiee => 'Marta',
        nazwiskoo => 'Dąbrowska',
        data_urodz => TO_DATE('03-06-1988', 'DD-MM-YYYY'),
        wiekk => 33,
        nr_tel => '555111222',
        pensjaa => TO_NUMBER('3800'),
        premiaa => TO_NUMBER('200')
    );

    dodaj_pracownika(
        imiee => 'Piotr',
        nazwiskoo => 'Mazurek',
        data_urodz => TO_DATE('18-11-1992', 'DD-MM-YYYY'),
        wiekk => 29,
        nr_tel => '999888777',
        pensjaa => TO_NUMBER('4200'),
        premiaa => TO_NUMBER('0')
    );

    dodaj_pracownika(
        imiee => 'Alicja',
        nazwiskoo => 'Czarnecka',
        data_urodz => TO_DATE('22-04-1993', 'DD-MM-YYYY'),
        wiekk => 28,
        nr_tel => '333444555',
        pensjaa => TO_NUMBER('3600'),
        premiaa => TO_NUMBER('150')
    );

END;


-- Wyswietlenie tabeli Pracownicy

SELECT * FROM tab_Pracownicy;

commit;



-- ZAMOWIENIA

-- Tworzenie obiektu Zamowienia
CREATE OR REPLACE TYPE type_zamowienia AS OBJECT ( 
    zamowienieID INT, 
    ilosc NUMBER(6,2), 
    status VARCHAR2(40),
    data_zamowienia date,
    produkt REF type_Produkty, 
    pracownik REF type_pracownicy
);

--Tworzenie tabeli dla Zamowienia
DROP TABLE tab_Zamowienia;

CREATE TABLE tab_Zamowienia OF type_Zamowienia(
    zamowienieID PRIMARY KEY,
    SCOPE FOR(produkt) IS tab_Produkty,
    SCOPE FOR(pracownik) IS tab_Pracownicy
);

--Tworzenie sekwencji dla Zamowienia
DROP SEQUENCE SEQ_Zamowienia;

CREATE SEQUENCE SEQ_Zamowienia INCREMENT BY 1 START WITH 1;


-- Dodawanie obiektu Zamowienia
create or replace PROCEDURE dodaj_zamowienie
(iloscc IN NUMBER default 1,
statuss IN VARCHAR2 default 'w trakcie',
data_zam IN DATE default TO_DATE('02-02-2024','DD-MM-YY'),
id_produktu IN INT default 1,
id_pracownika IN INT default 1) AS
BEGIN

    DECLARE
        ref_produkt ref type_produkty;
        ref_pracownik ref type_pracownicy;
    BEGIN
    
        SELECT ref(prod) INTO ref_produkt
        FROM tab_Produkty prod
        WHERE prod.produktID = id_produktu;
        
        
        SELECT ref(prac) INTO ref_pracownik
        FROM tab_Pracownicy prac
        WHERE prac.pracownikID = id_pracownika;
        
    
        INSERT INTO tab_Zamowienia(zamowienieID,
            ilosc,
            status,
            data_zamowienia,
            produkt,
            pracownik) 
            VALUES (
        SEQ_Zamowienia.NEXTVAL,
        iloscc,
        statuss,
        data_zam,
        ref_produkt,
        ref_pracownik
        );
        
        dbms_output.put_line('Zamowienie zostalo zlozone');
    END;

END;
    

BEGIN
    dodaj_zamowienie(
        iloscc => TO_NUMBER(5),
        statuss => 'W trakcie',
        data_zam => TO_DATE('20-02-2024', 'DD-MM-YYYY'),
        id_produktu => 3,
        id_pracownika => 1
    );
    
    dodaj_zamowienie(
        iloscc => TO_NUMBER(5),
        statuss => 'W trakcie',
        data_zam => TO_DATE('20-02-2024', 'DD-MM-YYYY'),
        id_produktu => 3,
        id_pracownika => 1
    );

    dodaj_zamowienie(
        iloscc => TO_NUMBER(3),
        statuss => 'Oczekujace',
        data_zam => TO_DATE('25-02-2024', 'DD-MM-YYYY'),
        id_produktu => 1,
        id_pracownika => 2
    );

    dodaj_zamowienie(
        iloscc => TO_NUMBER(2),
        statuss => 'Zrealizowane',
        data_zam => TO_DATE('28-02-2024', 'DD-MM-YYYY'),
        id_produktu => 2,
        id_pracownika => 3
    );

    dodaj_zamowienie(
        iloscc => TO_NUMBER(7),
        statuss => 'Oczekujace',
        data_zam => TO_DATE('10-03-2024', 'DD-MM-YYYY'),
        id_produktu => 4,
        id_pracownika => 4
    );

    dodaj_zamowienie(
        iloscc => TO_NUMBER(4),
        statuss => 'W trakcie',
        data_zam => TO_DATE('15-03-2024', 'DD-MM-YYYY'),
        id_produktu => 5,
        id_pracownika => 5
    );

    dodaj_zamowienie(
        iloscc => TO_NUMBER(10),
        statuss => 'Zrealizowane',
        data_zam => TO_DATE('20-03-2024', 'DD-MM-YYYY'),
        id_produktu => 6,
        id_pracownika => 6
    );

END;

BEGIN

    dodaj_zamowienie(
        iloscc => TO_NUMBER(4),
        statuss => 'Oczekujace',
        data_zam => TO_DATE('20-03-2024', 'DD-MM-YYYY'),
        id_produktu => 4,
        id_pracownika => 1
    );

END;


-- Wyswietlenie tabeli Zamowienia

SELECT * FROM tab_Zamowienia;

--Wyswietl zamowienia danego pracownika

SELECT zam.*, DEREF(zam.produkt).nazwaProduktu, DEREF(zam.pracownik).imie, DEREF(zam.pracownik).nazwisko
FROM tab_Zamowienia zam
WHERE DEREF(zam.pracownik).pracownikID = 1;


commit;

-- PLATNOSCI

-- Tworzenie obiektu platnosci
CREATE OR REPLACE TYPE type_platnosci AS OBJECT ( 
    platnoscID INT,
    nazwaPlatnosci VARCHAR2(50)
); 

--Tworzenie tabeli dla platnosci
DROP TABLE tab_Platnosci;

CREATE TABLE tab_Platnosci OF type_platnosci(
    platnoscID PRIMARY KEY
);

BEGIN
    INSERT INTO tab_Platnosci VALUES (1, 'Karta');
    INSERT INTO tab_Platnosci VALUES (2, 'Gotowka');

END;

-- Wyswietlenie tabeli platnosci

SELECT * FROM tab_Platnosci;

commit;


-- TRANSAKCJE

-- Tworzenie obiektu TRANSAKCJA
CREATE OR REPLACE TYPE TYPE_TRANSAKCJE AS OBJECT ( 
    TRANSAKCJAID INT, 
    DATAWYKONANIA DATE, 
    PRACOWNIKID NUMBER, 
    PLATNOSCID NUMBER
);

--Tworzenie tabeli dla kategoria
DROP TABLE tab_TRANSAKCJE

CREATE TABLE tab_TRANSAKCJE OF type_TRANSAKCJE(
    TRANSAKCJAID PRIMARY KEY
);

--Tworzenie sekwencji dla kategoria
DROP SEQUENCE SEQ_TRANSAKCJA;

CREATE SEQUENCE SEQ_TRANSAKCJA INCREMENT BY 1 START WITH 1;


-- Dodawanie obiektu kategoria
CREATE OR REPLACE PROCEDURE przeprowadz_TRANSAKCJE(nazwa IN VARCHAR2) AS
BEGIN
    INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIA.NEXTVAL, nazwa);
    dbms_output.put_line('Kategoria: ' || nazwa || ' zostal dodany');
END;

BEGIN
    dodaj_kategorie('Tabletki');
    dodaj_kategorie('Masc');
    dodaj_kategorie('Syrop');
    dodaj_kategorie('Suplementy');
    dodaj_kategorie('Leki przeciwbólowe');
    dodaj_kategorie('Preparaty dla dzieci');


END;

-- Wyswietlenie tabeli transackje

SELECT * FROM tab_Transakcje;

commit;

