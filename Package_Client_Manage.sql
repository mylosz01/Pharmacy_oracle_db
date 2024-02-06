CREATE OR REPLACE 
PACKAGE PAK_CLIENT_MANAGE AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  brak_kategorii_except EXCEPTION;

  FUNCTION czy_istnieje_kategoria(id_kat IN INT) RETURN BOOLEAN;

  FUNCTION czy_produkt_na_stanie(id_prod IN INT) RETURN BOOLEAN;

  PROCEDURE zakup_lekarstwo(id_prod IN INT);
  
  PROCEDURE wyswietl_wszystkie_leki;
  
  PROCEDURE wyswietl_leki_z_kategorii(id_kat IN INT);
  
  PROCEDURE zamow_lek(id_prod IN INT);
  
  PROCEDURE wyswietl_historie_zakupow;

END PAK_CLIENT_MANAGE;

CREATE OR REPLACE 
PACKAGE PAK_CLIENT_MANAGE AS 

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

  PROCEDURE zakup_lekarstwo(id_prod IN INT);
  
  PROCEDURE wyswietl_wszystkie_leki AS
    
        SELECT DEREF(prod.kategoria) INTO kat FROM tab_produkty prod WHERE prod.kategoria.kategoriaID = id_kat;

        FOR p_produkt IN (SELECT * FROM tab_produkty prod WHERE prod.kategoria.kategoriaID = id_kat) LOOP
           DBMS_OUTPUT.PUT_LINE('KATEGORIA: ' || kat.nazwaKategorii);
            DBMS_OUTPUT.PUT_LINE('ProduktID: ' || p_produkt.produktID);
            DBMS_OUTPUT.PUT_LINE('Nazwa Produktu: ' || p_produkt.nazwaProduktu);
            DBMS_OUTPUT.PUT_LINE('Cena Produktu: ' || p_produkt.cenaProduktu);
            DBMS_OUTPUT.PUT_LINE('Data Produkcji: ' || TO_CHAR(p_produkt.dataProdukcji, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Data Waznosci: ' || TO_CHAR(p_produkt.dataWaznosci, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Dostepnoscć: ' || p_produkt.dostepnosc);
            DBMS_OUTPUT.PUT_LINE('Opis: ' || p_produkt.opis);
        
        END LOOP;
    END wyswietl_wszystkie_leki;
    
  PROCEDURE wyswietl_leki_z_kategorii(id_kat IN INT) AS
    kat type_kategorie;
    BEGIN
    
        IF czy_istnieje_kategoria(id_kat) = FALSE THEN
            RAISE brak_kategorii_except;
        END if;
    
        SELECT DEREF(prod.kategoria) INTO kat FROM tab_produkty prod WHERE prod.kategoria.kategoriaID = id_kat;
    
        DBMS_OUTPUT.PUT_LINE('KATEGORIA: ' || kat.nazwaKategorii);
        
        FOR p_produkt IN (SELECT * FROM tab_produkty prod WHERE prod.kategoria.kategoriaID = id_kat) LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('ProduktID: ' || p_produkt.produktID);
            DBMS_OUTPUT.PUT_LINE('Nazwa Produktu: ' || p_produkt.nazwaProduktu);
            DBMS_OUTPUT.PUT_LINE('Cena Produktu: ' || p_produkt.cenaProduktu);
            DBMS_OUTPUT.PUT_LINE('Data Produkcji: ' || TO_CHAR(p_produkt.dataProdukcji, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Data Waznosci: ' || TO_CHAR(p_produkt.dataWaznosci, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Dostepnoscć: ' || p_produkt.dostepnosc);
            DBMS_OUTPUT.PUT_LINE('Opis: ' || p_produkt.opis);
        
        END LOOP;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Brak produktow z kategorii o id: ' || id_kat);
        WHEN brak_kategorii_except THEN
            dbms_output.put_line('Brak kategorii o id : ' || id_kat);
        
    END wyswietl_leki_z_kategorii;
            
  
  PROCEDURE zamow_lek(id_prod IN INT, ilosc_zam IN NUMBER) AS
    BEGIN
        DECLARE
            ref_produkt ref type_produkty;
            aktualna_data DATE;
        BEGIN
            SELECT sysdate INTO aktualna_data FROM dual;
    
        --sprawdzenie czy produkt istnieje
        IF PAK_ADMIN_MANAGE_STORE.czy_produkt_istnieje(id_prod) = FALSE THEN
            raise brak_produktu_except;
        end if;

        SELECT ref(prod) INTO ref_produkt
        FROM tab_Produkty prod
        WHERE prod.produktID = id_prod;      
    
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
        8007 /*Jako rze klient będzie sam kupował tylko przy kiosku samoobsługowym to ID_pracowanika możemy dać na stałe*/
        );
        
        dbms_output.put_line('Zamowienie zostalo zlozone poprawnie');
        
    EXCEPTION
        WHEN brak_produktu_except THEN
            dbms_output.put_line('Brak produktu o id : ' || id_prod);
    
    END;
    END zamow_lek;
  
  
  PROCEDURE wyswietl_historie_zakupow;

END PAK_CLIENT_MANAGE;
