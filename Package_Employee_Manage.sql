create or replace NONEDITIONABLE PACKAGE PAK_EMPLOYEE_MANAGE AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    brak_produktu_except EXCEPTION;
    brak_pracownika_except EXCEPTION;
    brak_kategorii_except EXCEPTION;
    brak_produktu_na_stanie_except EXCEPTION;
    
    FUNCTION czy_istnieje_kategoria(id_kat IN INT) RETURN BOOLEAN;
    
    FUNCTION czy_produkt_na_stanie(id_prod IN INT) RETURN BOOLEAN;
    
    FUNCTION ilosc_produktu_na_stanie(id_prod IN INT) RETURN NUMBER;
    
    
    PROCEDURE zamow_lek(id_prod IN INT, ilosc_zam IN NUMBER, id_prac IN INT);
  
    PROCEDURE zaktualizuj_stan_produktu(id_prod IN INT, nowa_ilosc IN NUMBER);
    
    PROCEDURE usun_produkt_ze_stanu(id_prod IN INT);
    
    PROCEDURE dodaj_klienta(
        imiee IN VARCHAR2 DEFAULT '-',
        nazwiskoo IN VARCHAR2 DEFAULT '-',
        pesell IN VARCHAR2 DEFAULT '-',
        data_urodz IN DATE DEFAULT TO_DATE('04-02-2024','dd-mm-yyyy'),
        wiekk IN INT DEFAULT 0,
        nr_tel IN VARCHAR2 DEFAULT '-',
        emaill IN VARCHAR2 DEFAULT '-'
    );
    
    PROCEDURE wyswietl_wszystkie_leki;
    
    PROCEDURE wyswietl_dostepne_leki;
    
    PROCEDURE wyswietl_leki_z_kategorii(id_kat IN INT);

END PAK_EMPLOYEE_MANAGE;



create or replace NONEDITIONABLE PACKAGE BODY PAK_EMPLOYEE_MANAGE AS

    FUNCTION czy_istnieje_kategoria(id_kat IN INT) RETURN BOOLEAN IS
            kategoria INT;
    BEGIN
        
        SELECT COUNT(*) INTO kategoria FROM tab_kategorie WHERE kategoriaID = id_kat;
        
        IF kategoria  > 0 THEN
            return TRUE;
        else
            raise brak_kategorii_except;
        end if;
        
    EXCEPTION
        WHEN brak_kategorii_except THEN
            dbms_output.put_line('Kategoria o id : ' || id_kat || ' nie istnieje');
            RETURN FALSE;
        
    END czy_istnieje_kategoria;



    FUNCTION czy_produkt_na_stanie(id_prod IN INT) RETURN BOOLEAN IS
            produkt INT;
    BEGIN
        
        SELECT COUNT(*) INTO produkt FROM tab_stanmagazynowy stan WHERE stan.produkt.produktID = id_prod;
        
        IF produkt > 0 THEN
            return TRUE;
        else
            raise brak_produktu_na_stanie_except;
        end if;
        
    EXCEPTION
        WHEN brak_produktu_na_stanie_except THEN
            dbms_output.put_line('Produktu o id : ' || id_prod || ' nie ma na stanie.');
            RETURN FALSE;
        
    END czy_produkt_na_stanie;
    
    
    
    FUNCTION ilosc_produktu_na_stanie(id_prod IN INT) RETURN NUMBER IS
        ilosc_na_stanie NUMBER;
    BEGIN
    
        SELECT iloscnastanie INTO ilosc_na_stanie FROM tab_stanmagazynowy stan WHERE stan.produkt.produktID = id_prod;
        
        return ilosc_na_stanie;
    END;


    PROCEDURE zamow_lek(id_prod IN INT, ilosc_zam IN NUMBER, id_prac IN INT) AS
    BEGIN
        DECLARE
            ref_produkt ref type_produkty;
            ref_pracownik ref type_pracownicy;
            aktualna_data DATE;
        BEGIN
            SELECT sysdate INTO aktualna_data FROM dual;
    
        --sprawdzenie czy produkt istnieje
        IF PAK_ADMIN_MANAGE_STORE.czy_produkt_istnieje(id_prod) = FALSE THEN
            raise brak_produktu_except;
        end if;
        
        --sprawdzenie czy pracownik istnieje
        IF PAK_ADMIN_MANAGE_EMPLOYEE.czy_istnieje_pracownik(id_prac) = FALSE THEN
            raise brak_pracownika_except;
        end if;
    
        SELECT ref(prod) INTO ref_produkt
        FROM tab_Produkty prod
        WHERE prod.produktID = id_prod;
        
        
        SELECT ref(prac) INTO ref_pracownik
        FROM tab_Pracownicy prac
        WHERE prac.pracownikID = id_prac;
        
    
        INSERT INTO tab_Zamowienia(zamowienieID,
            ilosc,
            status,
            data_zamowienia,
            produkt,
            pracownik) 
            VALUES (
        SEQ_Zamowienia.NEXTVAL,
        ilosc_zam,
        'Oczekujace',
        TO_DATE(aktualna_data,'DD-MM-YYYY'),
        ref_produkt,
        ref_pracownik
        );
        
        dbms_output.put_line('Zamowienie zostalo zlozone poprawnie');
        
    EXCEPTION
        WHEN brak_produktu_except THEN
            dbms_output.put_line('Brak produktu o id : ' || id_prod);
        WHEN brak_pracownika_except THEN
            dbms_output.put_line('Brak pracownika o id : ' || id_prac);
    
    END;
    END zamow_lek;



    PROCEDURE zaktualizuj_stan_produktu(id_prod IN INT, nowa_ilosc IN NUMBER) AS
        aktualna_data DATE;
        reF_prod REF type_produkty;
    BEGIN
        SELECT sysdate INTO aktualna_data FROM dual;
        
        --sprawdzanie czy produkt istnieje
        IF pak_admin_manage_store.czy_produkt_istnieje(id_prod) = FALSE THEN
            raise brak_produktu_except;
        END IF;
    
        --sprawdzanie produktu na stanie
        IF czy_produkt_na_stanie(id_prod) = TRUE THEN
            --produkt na stanie
            UPDATE tab_stanmagazynowy stan SET iloscNaStanie = iloscNaStanie + nowa_ilosc WHERE stan.produkt.produktID = id_prod;
            
            dbms_output.put_line('Stan produktu o id: ' || id_prod || ' zostal zaktualizowany');
        ELSE
            --brak produktu na stanie
            dbms_output.put_line('Brak produkt o id: ' || id_prod || ' na stanie.');
            dbms_output.put_line('Dodawanie produktu...');
            
            SELECT REF(prod) INTO ref_prod FROM tab_produkty prod WHERE prod.produktID = id_prod;
            
            INSERT INTO tab_stanmagazynowy(
                produkt,
                iloscNaStanie,
                DataAktualizacji) 
            VALUES(
                ref_prod,
                nowa_ilosc,
                TO_DATE(aktualna_data,'DD-MM-YYYY')
            );
            
            dbms_output.put_line('Produkt o id: ' || id_prod || ' zostal dodany do stanu w ilosc: ' || nowa_ilosc );
            
        END IF;
        
    EXCEPTION
        WHEN brak_produktu_except THEN
            dbms_output.put_line('Produkt o id: ' || id_prod || ' nie istnieje..');
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Brak produktow');
            
    END zaktualizuj_stan_produktu;


    PROCEDURE usun_produkt_ze_stanu(id_prod IN INT) AS
    BEGIN
        DELETE FROM tab_stanmagazynowy WHERE deref(produkt).produktID = id_prod;
        dbms_output.put_line('Produkt o id: ' || id_prod || ' zostal usuniety ze stanu magazynowego');
    END usun_produkt_ze_stanu;


    PROCEDURE dodaj_klienta(
        imiee IN VARCHAR2 DEFAULT '-',
        nazwiskoo IN VARCHAR2 DEFAULT '-',
        pesell IN VARCHAR2 DEFAULT '-',
        data_urodz IN DATE DEFAULT TO_DATE('04-02-2024','dd-mm-yyyy'),
        wiekk IN INT DEFAULT 0,
        nr_tel IN VARCHAR2 DEFAULT '-',
        emaill IN VARCHAR2 DEFAULT '-'
        ) AS
    BEGIN
        INSERT INTO tab_klienci(klientID,
            imie,
            nazwisko,
            pesel,
            dataUrodzenia,
            wiek,
            nrTelefonu,
            email) 
            VALUES (
                SEQ_Klienci.NEXTVAL,
                imiee,
                nazwiskoo,
                pesell,
                data_urodz,
                wiekk,
                nr_tel,
                emaill);
        
        dbms_output.put_line('Klient: ' || imiee || ' ' || nazwiskoo || ' zostal dodany');
    END dodaj_klienta;



    PROCEDURE wyswietl_wszystkie_leki AS
        kat type_kategorie;
    BEGIN
        FOR p_produkt IN (SELECT * FROM tab_produkty) LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('ProduktID: ' || p_produkt.produktID);
            DBMS_OUTPUT.PUT_LINE('Nazwa Produktu: ' || p_produkt.nazwaProduktu);
            DBMS_OUTPUT.PUT_LINE('Cena Produktu: ' || p_produkt.cenaProduktu);
            DBMS_OUTPUT.PUT_LINE('Data Produkcji: ' || TO_CHAR(p_produkt.dataProdukcji, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Data Waznosci: ' || TO_CHAR(p_produkt.dataWaznosci, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Dostepnoscć: ' || p_produkt.dostepnosc);
            DBMS_OUTPUT.PUT_LINE('Opis: ' || p_produkt.opis);
            SELECT DEREF(p_produkt.kategoria) INTO kat FROM tab_produkty p WHERE p.produktID = p_produkt.produktID; 
            DBMS_OUTPUT.PUT_LINE('KategoriaID: ' || kat.kategoriaID);
            DBMS_OUTPUT.PUT_LINE('Nazwa Kategorii: ' || kat.nazwaKategorii);
        
        END LOOP;
      END wyswietl_wszystkie_leki;



    PROCEDURE wyswietl_dostepne_leki AS
        ref_prod type_produkty;
    BEGIN
        FOR p_produkt IN (SELECT * FROM tab_stanmagazynowy prod) LOOP
            SELECT DEREF(p_produkt.produkt) INTO ref_prod FROM dual;
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('ProduktID: ' || ref_prod.produktID);
            DBMS_OUTPUT.PUT_LINE('Nazwa Produktu: ' || ref_prod.nazwaProduktu);
            DBMS_OUTPUT.PUT_LINE('Cena Produktu: ' || ref_prod.cenaProduktu);
            DBMS_OUTPUT.PUT_LINE('Dostepnosc: ' || ref_prod.dostepnosc);
            DBMS_OUTPUT.PUT_LINE('ILOSC NA STANIE: ' || p_produkt.iloscnastanie);
        
        END LOOP;
    END wyswietl_dostepne_leki;
    
    
    
    PROCEDURE wyswietl_leki_z_kategorii(id_kat IN INT) AS
        kat type_kategorie;
        TYPE ref_cursor IS REF CURSOR;
        c_prod ref_cursor;
        ref_prod ref type_produkty;
        pr type_produkty;
        
    BEGIN
    
        IF czy_istnieje_kategoria(id_kat) = FALSE THEN
            RAISE brak_kategorii_except;
        END if;
    
        SELECT DEREF(prod.kategoria) INTO kat FROM tab_produkty prod WHERE prod.kategoria.kategoriaID = id_kat AND ROWNUM=1;
    
        DBMS_OUTPUT.PUT_LINE('KATEGORIA: ' || kat.nazwaKategorii);
        
        OPEN c_prod FOR SELECT ref(prod) FROM tab_produkty prod WHERE prod.kategoria.kategoriaID = id_kat;
        
        LOOP
            FETCH c_prod INTO ref_prod;
            EXIT WHEN c_prod%NOTFOUND;
            
            SELECT deref(ref_prod) INTO pr FROM dual;
            
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('ProduktID: ' || pr.produktID);
            DBMS_OUTPUT.PUT_LINE('Nazwa Produktu: ' || pr.nazwaProduktu);
            DBMS_OUTPUT.PUT_LINE('Cena Produktu: ' || pr.cenaProduktu);
            DBMS_OUTPUT.PUT_LINE('Data Produkcji: ' || TO_CHAR(pr.dataProdukcji, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Data Waznosci: ' || TO_CHAR(pr.dataWaznosci, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Dostepnoscć: ' || pr.dostepnosc);
            DBMS_OUTPUT.PUT_LINE('Opis: ' || pr.opis);
        
        END LOOP;
        
        CLOSE c_prod;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Brak produktow z kategorii o id: ' || id_kat);
        WHEN brak_kategorii_except THEN
            dbms_output.put_line('Brak kategorii o id : ' || id_kat);
        
    END wyswietl_leki_z_kategorii;

END PAK_EMPLOYEE_MANAGE;



-- PRZYKLADY UZYCIA

-- zamawianie lekarstwa

SELECT * FROM tab_zamowienia;
SELECT * FROM tab_produkty;
SELECT * FROM tab_pracownicy;

BEGIN    
    pak_employee_manage.zamow_lek(1,TO_NUMBER(100),2);

END;
rollback;
commit;

-- wyswietlenie wszystkich lekow
BEGIN
    pak_employee_manage.wyswietl_wszystkie_leki;
END;


-- dodawanie klienta
SELECT * FROM tab_klienci;

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


-- wyswietlanie lekarstw z danej kategorii
SELECT * FROM tab_kategorie;

BEGIN 
    pak_employee_manage.wyswietl_leki_z_kategorii(3);
END;


--zaktualizuj leki na stanie magazynowym
SELECT * FROM tab_stanmagazynowy;
SELECT * FROM tab_produkty;

ROLLBACK;
commit;

BEGIN
    pak_employee_manage.zaktualizuj_stan_produktu(2,8);
END;

-- wyswietl dostepne leki
SELECT * FROM tab_stanmagazynowy;

BEGIN
    pak_employee_manage.wyswietl_dostepne_leki;
END;



