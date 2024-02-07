-- wprowadzanie danych do kategoria
BEGIN
    INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Tabletki');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Masc');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Syrop');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Suplementy');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Leki przeciwbólowe');
	INSERT INTO tab_Kategorie VALUES (SEQ_KATEGORIE.NEXTVAL, 'Preparaty dla dzieci');

END;
SELECT * FROM taB_kategorie;

-- Dodawanie klientow
BEGIN
    pak_employee_manage.dodaj_klienta(
        imiee => 'Marianna',
        nazwiskoo => 'Kowalska',
        pesell => '98265473829',
        data_urodz => TO_DATE('02-04-2000','dd-mm-yyyy'),
        wiekk => 23,
        nr_tel => '455345834',
        emaill => 'mar.kow@wp.pl'
    );

END;

BEGIN
    pak_employee_manage.dodaj_klienta(
        imiee => 'Jan',
        nazwiskoo => 'Nowak',
        pesell => '12345678901',
        data_urodz => TO_DATE('01-01-1990','dd-mm-yyyy'),
        wiekk => 32,
        nr_tel => '123456789',
        emaill => 'jan.nowak@example.com'
    );
END;

BEGIN
    pak_employee_manage.dodaj_klienta(
        imiee => 'Anna',
        nazwiskoo => 'Kowalska',
        pesell => '98765432109',
        data_urodz => TO_DATE('15-06-1985','dd-mm-yyyy'),
        wiekk => 37,
        nr_tel => '987654321',
        emaill => 'anna.kowalska@example.com'
    );
END;

BEGIN
    pak_employee_manage.dodaj_klienta(
        imiee => 'Michał',
        nazwiskoo => 'Lis',
        pesell => '76543210987',
        data_urodz => TO_DATE('20-03-1995','dd-mm-yyyy'),
        wiekk => 27,
        nr_tel => '765432109',
        emaill => 'michal.lis@example.com'
    );
END;

SELECT * FROM tab_klienci;

-- Wprowadzanie lekarzy
-- Dodanie przykładowych lekarzy
INSERT INTO tab_lekarze (lekarzID, imie, nazwisko, nrTelefonu)
VALUES (SEQ_lekarze.nextval, 'Jan', 'Kowalski', '123456789');

INSERT INTO tab_lekarze (lekarzID, imie, nazwisko, nrTelefonu)
VALUES (SEQ_lekarze.nextval, 'Anna', 'Nowak', '987654321');

INSERT INTO tab_lekarze (lekarzID, imie, nazwisko, nrTelefonu)
VALUES (SEQ_lekarze.nextval, 'Marek', 'Lis', '555555555');

-- Dodanie kolejnych przykładowych lekarzy
INSERT INTO tab_lekarze (lekarzID, imie, nazwisko, nrTelefonu)
VALUES (SEQ_lekarze.nextval, 'Alicja', 'Kaczor', '111222333');

INSERT INTO tab_lekarze (lekarzID, imie, nazwisko, nrTelefonu)
VALUES (SEQ_lekarze.nextval, 'Piotr', 'Wójcik', '444777888');

INSERT INTO tab_lekarze (lekarzID, imie, nazwisko, nrTelefonu)
VALUES (SEQ_lekarze.nextval, 'Magdalena', 'Nowakowska', '666999000');

SELECT * FROM tab_lekarze;


-- wprowadzanie produktow
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


-- dodawanie przykladowych magazynow wraz z produktami
BEGIN

    INSERT INTO tab_Magazyny (
        magazynID, 
        kraj, 
        miasto, 
        nazwaUlicy, 
        nrBudynku, 
        produkty_w_magazynie
    ) VALUES (
        seq_magazyny.nextval, 
        'Polska', 
        'Warszawa', 
        'ul. Prosta', 
        10, 
        type_zawartosc_magazynu(
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 1), 
                100
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 2), 
                45
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 5), 
                30
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 7), 
                120
            )
        )
    );

    INSERT INTO tab_Magazyny (
        magazynID, 
        kraj, 
        miasto, 
        nazwaUlicy, 
        nrBudynku, 
        produkty_w_magazynie
    ) VALUES (
        seq_magazyny.nextval, 
        'Polska', 
        'Kraków', 
        'ul. Krakowska', 
        20, 
        type_zawartosc_magazynu(
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 2), 
                50
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 3), 
                75
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 6), 
                20
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 5), 
                64
            )
        )
    );


END;


-- wprowadzanie danych do platnosci
BEGIN
    INSERT INTO tab_Platnosci VALUES (1, 'Karta');
    INSERT INTO tab_Platnosci VALUES (2, 'Gotowka');

END;


-- wprowadzanie pracownikow
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

-- wprowdzanie recept
-- Przykładowe recepty
INSERT INTO tab_recepty (receptaID, dataWystawienia, dataWaznosci, kodDostepu, lekarz, klient)
VALUES (SEQ_recepty.nextval, TO_DATE('01-01-2022', 'DD-MM-YYYY'), TO_DATE('01-02-2027', 'DD-MM-YYYY'), 123456, (SELECT REF(l) FROM tab_lekarze l WHERE lekarzID = 1), (SELECT REF(k) FROM tab_klienci k WHERE klientID = 1));

INSERT INTO tab_recepty (receptaID, dataWystawienia, dataWaznosci, kodDostepu, lekarz, klient)
VALUES (SEQ_recepty.nextval, TO_DATE('05-03-2022', 'DD-MM-YYYY'), TO_DATE('05-04-2023', 'DD-MM-YYYY'), 654321, (SELECT REF(l) FROM tab_lekarze l WHERE lekarzID = 2), (SELECT REF(k) FROM tab_klienci k WHERE klientID = 2));

-- Dodanie kolejnych przykładowych recept
INSERT INTO tab_recepty (receptaID, dataWystawienia, dataWaznosci, kodDostepu, lekarz, klient)
VALUES (SEQ_recepty.nextval, TO_DATE('10-05-2022', 'DD-MM-YYYY'), TO_DATE('10-06-2024', 'DD-MM-YYYY'), 987654, (SELECT REF(l) FROM tab_lekarze l WHERE lekarzID = 3), (SELECT REF(k) FROM tab_klienci k WHERE klientID = 1));

INSERT INTO tab_recepty (receptaID, dataWystawienia, dataWaznosci, kodDostepu, lekarz, klient)
VALUES (SEQ_recepty.nextval, TO_DATE('15-08-2022', 'DD-MM-YYYY'), TO_DATE('15-09-2026', 'DD-MM-YYYY'), 789012, (SELECT REF(l) FROM tab_lekarze l WHERE lekarzID = 1), (SELECT REF(k) FROM tab_klienci k WHERE klientID = 2));

INSERT INTO tab_recepty (receptaID, dataWystawienia, dataWaznosci, kodDostepu, lekarz, klient)
VALUES (SEQ_recepty.nextval, TO_DATE('20-11-2022', 'DD-MM-YYYY'), TO_DATE('20-12-2025', 'DD-MM-YYYY'), 345678, (SELECT REF(l) FROM tab_lekarze l WHERE lekarzID = 2), (SELECT REF(k) FROM tab_klienci k WHERE klientID = 3));

SELECT * FROM tab_recepty;





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
    
-- wprowadzanie do stanu magazynowego
BEGIN
    pak_employee_manage.zaktualizuj_stan_produktu(id_prod => 1, nowa_ilosc => 19);
	pak_employee_manage.zaktualizuj_stan_produktu(id_prod => 2, nowa_ilosc => 9);
	pak_employee_manage.zaktualizuj_stan_produktu(id_prod => 3, nowa_ilosc => 23);
	pak_employee_manage.zaktualizuj_stan_produktu(id_prod => 4, nowa_ilosc => 25);
	pak_employee_manage.zaktualizuj_stan_produktu(id_prod => 5, nowa_ilosc => 16);
	pak_employee_manage.zaktualizuj_stan_produktu(id_prod => 6, nowa_ilosc => 46);
END;


-- wprowadzanie szczegolow recept
-- Przykładowe referencje do recept, produkt

-- Przykładowe referencje do recept, produkt
DECLARE
    ref_recepta ref type_Recepty;
    ref_produkt ref type_Produkty;
BEGIN
    SELECT REF(r) INTO ref_recepta FROM tab_recepty r WHERE receptaID = 1;
    SELECT REF(p) INTO ref_produkt FROM tab_produkty p WHERE produktID = 1;

    -- Dodanie przykładowego szczegółu recepty
    INSERT INTO tab_szczegolyrecept (recepta, produkt, status, ilosc_Wydana,ilosc_do_wydania)
    VALUES (ref_recepta, ref_produkt, 'W trakcie', 2.0, 5.0);

    -- Dodanie kolejnego przykładowego szczegółu recepty
    SELECT REF(r) INTO ref_recepta FROM tab_recepty r WHERE receptaID = 2;
    SELECT REF(p) INTO ref_produkt FROM tab_produkty p WHERE produktID = 3;

    INSERT INTO tab_szczegolyrecept (recepta, produkt, status, ilosc_Wydana, ilosc_do_Wydania)
    VALUES (ref_recepta, ref_produkt, 'Zrealizowano', 5.0, 8.0);
END;
/

-- Przykładowe referencje do recept, produkt
DECLARE
    ref_recepta ref type_Recepty;
    ref_produkt ref type_Produkty;
BEGIN
    SELECT REF(r) INTO ref_recepta FROM tab_recepty r WHERE receptaID = 3;
    SELECT REF(p) INTO ref_produkt FROM tab_produkty p WHERE produktID = 2;

    -- Dodanie kolejnego przykładowego szczegółu recepty
    INSERT INTO tab_szczegolyrecept (recepta, produkt, status, ilosc_Wydana, ilosc_do_Wydania)
    VALUES (ref_recepta, ref_produkt, 'W trakcie', 3.0, 12.0);

    -- Dodanie jeszcze jednego przykładowego szczegółu recepty
    SELECT REF(r) INTO ref_recepta FROM tab_recepty r WHERE receptaID = 4;
    SELECT REF(p) INTO ref_produkt FROM tab_produkty p WHERE produktID = 1;

    INSERT INTO tab_szczegolyrecept (recepta, produkt, status, ilosc_wydana, ilosc_do_Wydania)
    VALUES (ref_recepta, ref_produkt, 'Zrealizowano', 10.0, 10.0);
END;
/

SELECT * FROM tab_szczegolyrecept;


--wprowadzanie Zamowienia

BEGIN 

    pak_employee_manage.zamow_lek(id_prod => 1, ilosc_zam => 17, id_prac => 2);
	pak_employee_manage.zamow_lek(id_prod => 2, ilosc_zam => 15, id_prac => 1);
	pak_employee_manage.zamow_lek(id_prod => 2, ilosc_zam => 9, id_prac => 3);
	pak_employee_manage.zamow_lek(id_prod => 3, ilosc_zam => 5, id_prac => 4);
	pak_employee_manage.zamow_lek(id_prod => 5, ilosc_zam => 12, id_prac => 1);
	pak_employee_manage.zamow_lek(id_prod => 6, ilosc_zam => 24, id_prac => 2);

END;


