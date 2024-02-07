create or replace NONEDITIONABLE PACKAGE PAK_ADMIN_MANAGE_STORE AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    brak_produktu_except EXCEPTION;
  
    FUNCTION czy_produkt_istnieje(id_prod IN INT) RETURN BOOLEAN;
    
    FUNCTION czy_produkt_w_magazynie(id_prod IN INT, id_mag IN INT) RETURN BOOLEAN;
    
  
    PROCEDURE dodaj_produkt
        (nazwa_produktu IN VARCHAR2 default '-',
        cena_prod IN NUMBER default 1.1,
        data_prod IN DATE default TO_DATE('15-01-2024','DD-MM-YY'),
        data_waz IN DATE default TO_DATE('15-01-2024','DD-MM-YY'),
        dostep IN VARCHAR2 default 'maly',
        opis IN VARCHAR2 default '-',
        id_kategorii IN INT default 0);
    
    PROCEDURE usun_produkt(id_produktu IN INT);
        
    PROCEDURE wyswietl_produkty_z_magazynu(id_magazynu IN INT);

    PROCEDURE zaktualizuj_stan_produktu_w_magazynie(id_magazynu IN INT, id_prod IN INT,ilosc_dodania IN NUMBER);
    
    PROCEDURE usun_produkt_z_magazynu(id_magazynu IN INT, id_produktu IN INT);


END PAK_ADMIN_MANAGE_STORE;


create or replace NONEDITIONABLE PACKAGE BODY PAK_ADMIN_MANAGE_STORE AS

    FUNCTION czy_produkt_istnieje(id_prod IN INT) RETURN BOOLEAN IS
        produkt INT;
    BEGIN
        
        SELECT COUNT(*) INTO produkt FROM tab_produkty WHERE produktID = id_prod;
        
        IF produkt > 0 THEN
            return TRUE;
        else
            raise brak_produktu_except;
        end if;
        
    EXCEPTION
        WHEN brak_produktu_except THEN
            dbms_output.put_line('Produkt o id : ' || id_prod || ' nie istnieje');
            RETURN FALSE;
        
    end czy_produkt_istnieje;
    

    FUNCTION czy_produkt_w_magazynie(id_prod IN INT, id_mag IN INT) RETURN BOOLEAN IS
            produkt INT;
    BEGIN
        
        SELECT Count(prod_mag.produkt) INTO produkt FROM tab_magazyny mag, TABLE(produkty_w_magazynie) prod_mag WHERE mag.magazynID = id_mag AND prod_mag.produkt.produktID = id_prod;

        IF produkt > 0 THEN
            return TRUE;
        else
            raise brak_produktu_except;
        end if;
        
    EXCEPTION
        WHEN brak_produktu_except THEN
            dbms_output.put_line('Produktu o id : ' || id_prod || ' w magazynie.');
            RETURN FALSE;
        
    END czy_produkt_w_magazynie;
    
    

    PROCEDURE dodaj_produkt
        (nazwa_produktu IN VARCHAR2 default '-',
        cena_prod IN NUMBER default 1.1,
        data_prod IN DATE default TO_DATE('15-01-2024','DD-MM-YY'),
        data_waz IN DATE default TO_DATE('15-01-2024','DD-MM-YY'),
        dostep IN VARCHAR2 default 'maly',
        opis IN VARCHAR2 default '-',
        id_kategorii IN INT default 0) IS
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
            TO_number(cena_prod),
            data_prod,
            data_waz,
            dostep,
            opis,
            ref_kategoria);
            
            dbms_output.put_line('Produkt: ' || nazwa_produktu || ' zostal dodany');
    END dodaj_produkt;
        
        
    PROCEDURE usun_produkt
        (id_produktu IN INT) IS
        BEGIN
        
        IF czy_produkt_istnieje(id_produktu) = FALSE THEN
            raise brak_produktu_except;
        end if;
            
            DELETE FROM tab_produkty WHERE produktID = id_produktu;
            
            dbms_output.put_line('Produkt zostal usuniety');
        EXCEPTION
            WHEN brak_produktu_except THEN
                dbms_output.put_line('Produkt nie zostal usuniety');
    END usun_produkt;
    
    
    PROCEDURE wyswietl_produkty_z_magazynu(id_magazynu IN INT) AS
        type ref_cursor IS REF CURSOR;
        c_zawartosc ref_cursor;
        
        type ref_cur2 IS REF CURSOR;
        c_prod ref_cur2;
        
        id_mag tab_magazyny.magazynID%TYPE;
        krajj tab_magazyny.kraj%TYPE;
        miastoo tab_magazyny.miasto%TYPE;
        ulica tab_magazyny.nazwaUlicy%TYPE;
        nr_bud tab_magazyny.nrBudynku%TYPE;
        content_mag tab_magazyny.produkty_w_magazynie%TYPE;
        
        produkt_w_mag type_produkty;
        ilosc_w_mag NUMBER;

    BEGIN

        OPEN c_zawartosc FOR SELECT * FROM tab_magazyny WHERE magazynID = id_magazynu;
        
        LOOP
            FETCH c_zawartosc INTO id_mag, krajj, miastoo, ulica, nr_bud, content_mag;
            EXIT WHEN c_zawartosc%NOTFOUND;
            
            dbms_output.put_line('Magazyn id: ' || id_mag);
            dbms_output.put_line('Kraj: ' || krajj);
            dbms_output.put_line('Miasto: ' || miastoo);
            dbms_output.put_line('Ulica: ' || ulica);
            dbms_output.put_line('Numer budynku: ' || nr_bud);
            dbms_output.put_line('');
            dbms_output.put_line('Zawartosc magazynu: ');
            
            OPEN c_prod FOR SELECT deref(prod_mag.produkt), ilosc_w_magazynie FROM tab_magazyny mag, TABLE(produkty_w_magazynie) prod_mag WHERE mag.magazynID = id_magazynu;
            
            LOOP
                FETCH c_prod INTO produkt_w_mag, ilosc_w_mag;
                EXIT WHEN c_prod%NOTFOUND;
                
                dbms_output.put_line('');
                produkt_w_mag.wyswietl_;
            
            END LOOP;
            
            CLOSE c_prod;
            
        
        END LOOP;
    
        CLOSE c_zawartosc;
    
    END wyswietl_produkty_z_magazynu;
    
    
    
    PROCEDURE zaktualizuj_stan_produktu_w_magazynie(id_magazynu IN INT, id_prod IN INT,ilosc_dodania IN NUMBER) AS
        ref_produkt ref type_produkty;
    BEGIN
    
        SELECT ref(prod) INTO ref_produkt FROM tab_produkty prod WHERE produktId = id_prod;
        
        --sprawdzanie czy produkt istnieje
        IF pak_admin_manage_store.czy_produkt_istnieje(id_prod) = FALSE THEN
            raise brak_produktu_except;
        END IF;
    
        --sprawdzanie produktu na stanie
        IF czy_produkt_w_magazynie(id_prod, id_magazynu) = TRUE THEN
            --produkt na stanie
            UPDATE TABLE(SELECT mag.produkty_w_magazynie FROM tab_magazyny mag WHERE mag.magazynID = id_magazynu) pr 
                SET pr.ilosc_w_magazynie = pr.ilosc_w_magazynie + ilosc_dodania
                WHERE pr.produkt.produktID = id_prod;
            dbms_output.put_line('Stan produktu o id: ' || id_prod || ' zostal zaktualizowany');
        ELSE
            --brak produktu na stanie
            dbms_output.put_line('Brak produkt o id: ' || id_prod || ' w magazynie.');
            dbms_output.put_line('Dodawanie produktu...');
            
            SELECT REF(prod) INTO ref_produkt FROM tab_produkty prod WHERE prod.produktID = id_prod;
            
            INSERT INTO TABLE(SELECT produkty_w_magazynie FROM tab_magazyny WHERE magazynId = id_magazynu) VALUES(ref_produkt,ilosc_dodania);
            
            dbms_output.put_line('Produkt o id: ' || id_prod || ' zostal dodany do magazynu ' || ilosc_dodania || ' w ilosc: ' || ilosc_dodania );
            
        END IF;
        
    EXCEPTION
        WHEN brak_produktu_except THEN
            dbms_output.put_line('Produkt o id: ' || id_prod || ' nie istnieje..');
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Brak produktow');
            
    
    END zaktualizuj_stan_produktu_w_magazynie;
    
    PROCEDURE usun_produkt_z_magazynu(id_magazynu IN INT, id_produktu IN INT) AS
    BEGIN
        DELETE FROM TABLE(SELECT produkty_w_magazynie FROM tab_magazyny WHERE magazynId = id_magazynu) pr WHERE pr.produkt.produktId = id_produktu;
        dbms_output.put_line('Produkt o id : ' || id_produktu || ' zostal usuniety z magazynu ' || id_magazynu ||' !');
    END usun_produkt_z_magazynu;
    

END PAK_ADMIN_MANAGE_STORE;


-- PRZYKLADOWE UZYCIA
-- sprawdzenie czy produkt istnieje
DECLARE
    res BOOLEAN := FALSE;
BEGIN
    IF pak_admin_manage_store.czy_produkt_istnieje(id_prod => 2) THEN
        dbms_output.put_line('istnieje');
    ELSE
        dbms_output.put_line('nie istnieje');
    END IF;
END;

-- sprawdzenie czy produkt znajduje sie w danym magazynie
DECLARE
    res BOOLEAN := FALSE;
BEGIN
    IF pak_admin_manage_store.czy_produkt_w_magazynie(id_prod => 2, id_mag => 1) THEN
        dbms_output.put_line('jest');
    ELSE
        dbms_output.put_line('nie ma');
    END IF;
END;


-- dodawanie produktu
SELECT * From tab_produkty;
commit;

rollback;

BEGIN
    pak_admin_manage_store.dodaj_produkt
        (nazwa_produktu => 'Cholinex',
        cena_prod => to_number('17,99'),
        data_prod => TO_DATE('01-01-2024','DD-MM-YYYY'),
        data_waz => TO_DATE('12-07-2026','DD-MM-YYYY'),
        dostep => 'duzy',
        opis => 'Na bol gardla',
        id_kategorii => 1);
END;

-- usuniecie produktu
BEGIN
    pak_admin_manage_store.usun_produkt(id_produktu => 10);
END;

--wyswietlenie produktow z magazynu
BEGIN
    pak_admin_manage_store.wyswietl_produkty_z_magazynu(id_magazynu=> 1);
END;

-- aktualizacja stanu w magazynie
BEGIN
    pak_admin_manage_store.zaktualizuj_stan_produktu_w_magazynie(id_magazynu => 1, id_prod => 4,ilosc_dodania => 40);
END;

-- usuwanie produktu z magazynu
BEGIN
    pak_admin_manage_store.usun_produkt_z_magazynu(id_magazynu => 1, id_produktu => 4);
END;

