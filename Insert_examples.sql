-- wprowadzanie danych do kategoria
BEGIN
    INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Tabletki');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Masc');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Syrop');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Suplementy');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Leki przeciwbólowe');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Preparaty dla dzieci');

END;

-- wprowadzanie danych do platnosci
BEGIN
    INSERT INTO tab_Platnosci VALUES (1, 'Karta');
    INSERT INTO tab_Platnosci VALUES (2, 'Gotowka');

END;

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
    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Calpol',
        cena_prod => TO_NUMBER('15,75'),
        data_prod => TO_DATE('05-12-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('05-12-2025', 'DD-MM-YYYY'),
        dostep => 'Duza',
        opis => 'Dla łagodzenia goroczki u dzieci',
        id_kategorii => 1
    );
    
    
    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Aspiryna',
        cena_prod => TO_NUMBER('10,50'),
        data_prod => TO_DATE('10-02-2024', 'DD-MM-YYYY'),
        data_waz => TO_DATE('10-02-2026', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Preparat przeciwbólowy',
        id_kategorii => 5
    );
    
    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Vitamin C',
        cena_prod => TO_NUMBER('5,99'),
        data_prod => TO_DATE('15-05-2024', 'DD-MM-YYYY'),
        data_waz => TO_DATE('15-05-2026', 'DD-MM-YYYY'),
        dostep => 'Mała',
        opis => 'Suplement diety z witaminą C',
        id_kategorii => 4
    );
    
    
    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Ibuprofen 200 mg',
        cena_prod => TO_NUMBER('25,50'),
        data_prod => TO_DATE('01-03-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('01-03-2025', 'DD-MM-YYYY'),
        dostep => 'Duza',
        opis => 'Przeciwbólowy i przeciwzapalny',
        id_kategorii => 5
    );

    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Paracetamol 500 mg',
        cena_prod => TO_NUMBER('12,75'),
        data_prod => TO_DATE('08-12-2022', 'DD-MM-YYYY'),
        data_waz => TO_DATE('08-12-2024', 'DD-MM-YYYY'),
        dostep => 'Mała',
        opis => 'Przeciwbólowy i przeciwgorączkowy',
        id_kategorii => 5
    );

    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Magnez 400 mg',
        cena_prod => TO_NUMBER('14,50'),
        data_prod => TO_DATE('10-09-2022', 'DD-MM-YYYY'),
        data_waz => TO_DATE('10-09-2024', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Dla prawidłowego funkcjonowania miesni',
        id_kategorii => 4
    );

    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Preparat Witaminowy dla Dzieci',
        cena_prod => TO_NUMBER('29,99'),
        data_prod => TO_DATE('15-12-2022', 'DD-MM-YYYY'),
        data_waz => TO_DATE('15-12-2024', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Zestaw witamin i minerałów dla prawidłowego rozwoju dzieci',
        id_kategorii => 6
    );
    
    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Syrop na Kaszel dla Dzieci',
        cena_prod => TO_NUMBER('14,99'),
        data_prod => TO_DATE('22-09-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('22-09-2025', 'DD-MM-YYYY'),
        dostep => 'Duza',
        opis => 'Przeciwbólowy i przeciwkaszlowy, dla dzieci powyżej 2 lat',
        id_kategorii => 6
    );

    PAK_ADMIN_MANAGE_STORE.dodaj_produkt(
        nazwa_produktu => 'Masc rozgrzewajaca',
        cena_prod => TO_NUMBER('18,50'),
        data_prod => TO_DATE('10-06-2023', 'DD-MM-YYYY'),
        data_waz => TO_DATE('10-06-2024', 'DD-MM-YYYY'),
        dostep => 'srednia',
        opis => 'Do miejscowego zastosowania przy bólach mięśniowych',
        id_kategorii => 2
    );


END;

SELECT * FROM tab_produkty;
	
	
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
    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
        imiee => 'Kamil',
        nazwiskoo => 'Olszewski',
        data_urodz => TO_DATE('05-04-1997', 'DD-MM-YYYY'),
        wiekk => 25,
        nr_tel => '555555555',
        pensjaa => TO_NUMBER('3000'),
        premiaa => TO_NUMBER('0')
    );
    
    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
        imiee => 'Anna',
        nazwiskoo => 'Nowak',
        data_urodz => TO_DATE('20-08-1990', 'DD-MM-YYYY'),
        wiekk => 31,
        nr_tel => '123456789',
        pensjaa => TO_NUMBER('3500'),
        premiaa => TO_NUMBER('0')
    );

    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
        imiee => 'Tomasz',
        nazwiskoo => 'Kowalski',
        data_urodz => TO_DATE('15-05-1985', 'DD-MM-YYYY'),
        wiekk => 36,
        nr_tel => '987654321',
        pensjaa => TO_NUMBER('4000'),
        premiaa => TO_NUMBER('300')
    );

    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
        imiee => 'Ewa',
        nazwiskoo => 'Wójcik',
        data_urodz => TO_DATE('10-12-1995', 'DD-MM-YYYY'),
        wiekk => 26,
        nr_tel => '111222333',
        pensjaa => TO_NUMBER('3200'),
        premiaa => TO_NUMBER('0')
    );

    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
        imiee => 'Marta',
        nazwiskoo => 'Dąbrowska',
        data_urodz => TO_DATE('03-06-1988', 'DD-MM-YYYY'),
        wiekk => 33,
        nr_tel => '555111222',
        pensjaa => TO_NUMBER('3800'),
        premiaa => TO_NUMBER('200')
    );

    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
        imiee => 'Piotr',
        nazwiskoo => 'Mazurek',
        data_urodz => TO_DATE('18-11-1992', 'DD-MM-YYYY'),
        wiekk => 29,
        nr_tel => '999888777',
        pensjaa => TO_NUMBER('4200'),
        premiaa => TO_NUMBER('0')
    );

    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
        imiee => 'Alicja',
        nazwiskoo => 'Czarnecka',
        data_urodz => TO_DATE('22-04-1993', 'DD-MM-YYYY'),
        wiekk => 28,
        nr_tel => '333444555',
        pensjaa => TO_NUMBER('3600'),
        premiaa => TO_NUMBER('150')
    );

END;


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
    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(5),
        statuss => 'W trakcie',
        data_zam => TO_DATE('20-02-2024', 'DD-MM-YYYY'),
        id_produktu => 3,
        id_pracownika => 1
    );
    
    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(5),
        statuss => 'W trakcie',
        data_zam => TO_DATE('20-02-2024', 'DD-MM-YYYY'),
        id_produktu => 3,
        id_pracownika => 1
    );

    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(3),
        statuss => 'Oczekujace',
        data_zam => TO_DATE('25-02-2024', 'DD-MM-YYYY'),
        id_produktu => 1,
        id_pracownika => 2
    );

    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(2),
        statuss => 'Zrealizowane',
        data_zam => TO_DATE('28-02-2024', 'DD-MM-YYYY'),
        id_produktu => 2,
        id_pracownika => 3
    );

    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(7),
        statuss => 'Oczekujace',
        data_zam => TO_DATE('10-03-2024', 'DD-MM-YYYY'),
        id_produktu => 4,
        id_pracownika => 4
    );

    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(4),
        statuss => 'W trakcie',
        data_zam => TO_DATE('15-03-2024', 'DD-MM-YYYY'),
        id_produktu => 5,
        id_pracownika => 5
    );

    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(10),
        statuss => 'Zrealizowane',
        data_zam => TO_DATE('20-03-2024', 'DD-MM-YYYY'),
        id_produktu => 6,
        id_pracownika => 6
    );

END;

BEGIN

    PAK_EMPLOYEE_TRANSACTION.dodaj_zamowienie(
        iloscc => TO_NUMBER(4),
        statuss => 'Oczekujace',
        data_zam => TO_DATE('20-03-2024', 'DD-MM-YYYY'),
        id_produktu => 4,
        id_pracownika => 1
    );

END;

-- Dodawanie obiektu transakcja
CREATE OR REPLACE PROCEDURE przeprowadz_TRANSAKCJE(id_prac IN INT, id_plat IN INT) AS
BEGIN
    DECLARE
        aktualna_data DATE;
        ref_prac REF type_Pracownicy;
        ref_plat REF type_Platnosci;
    BEGIN 
        SELECT sysdate INTO aktualna_data FROM DUAL;
        
        SELECT ref(prac) INTO ref_prac
        FROM tab_Pracownicy prac
        WHERE prac.pracownikID = id_prac;
        
        SELECT ref(plat) INTO ref_plat
        FROM tab_Platnosci plat
        WHERE plat.platnoscID = id_plat;
    

        INSERT INTO tab_Transakcje
        VALUES (SEQ_TRANSAKCJA.NEXTVAL, 
        TO_DATE(aktualna_data,'dd-mm-yyyy'),
        ref_prac,
        ref_plat);
        
        
        dbms_output.put_line('Transakcja została wykonana');
    
    END;
    
END;


BEGIN
    przeprowadz_TRANSAKCJE(id_prac => 3, id_plat => 2);
    przeprowadz_TRANSAKCJE(id_prac => 4, id_plat => 1);
    przeprowadz_TRANSAKCJE(id_prac => 5, id_plat => 2);
    przeprowadz_TRANSAKCJE(id_prac => 3, id_plat => 1);
    przeprowadz_TRANSAKCJE(id_prac => 2, id_plat => 2);
    przeprowadz_TRANSAKCJE(id_prac => 6, id_plat => 1);
    przeprowadz_TRANSAKCJE(id_prac => 1, id_plat => 2);
    przeprowadz_TRANSAKCJE(id_prac => 3, id_plat => 1);
    przeprowadz_TRANSAKCJE(id_prac => 2, id_plat => 1);
    przeprowadz_TRANSAKCJE(id_prac => 4, id_plat => 2);
END;


