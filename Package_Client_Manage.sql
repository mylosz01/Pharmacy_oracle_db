CREATE OR REPLACE 
PACKAGE PAK_CLIENT_MANAGE AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  brak_kategorii_except EXCEPTION;

  FUNCTION czy_istnieje_kategoria(id_kat IN INT) RETURN BOOLEAN;

  FUNCTION czy_produkt_na_stanie(id_prod IN INT) RETURN BOOLEAN;

  PROCEDURE zakup_lekarstwo(id_prod IN INT,id_plat IN INT, ilosc_prod IN NUMBER);
  
  PROCEDURE wyswietl_wszystkie_leki;
  
  PROCEDURE wyswietl_leki_z_kategorii(id_kat IN INT);
  
  PROCEDURE zamow_lek(id_prod IN INT);
  
  PROCEDURE wyswietl_recepry_klientaa(p_klient_id IN INT);

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

  PROCEDURE zakup_lekarstwo(
        id_prod IN INT,
        id_plat IN INT,
        ilosc_prod IN NUMBER
    ) AS
        ref_pracownik ref type_pracownicy;
        ref_platnosci ref type_platnosci;
        ref_produkt ref type_produkty;
        ref_trans ref type_transakcje;
        ilosc_na_st NUMBER;
        trans_id INT;
    BEGIN
        --przeprowadz transakcje
        
        -- czy produkt jest na stanie magazynowym
        IF czy_produkt_na_stanie(id_prod) = FALSE THEN
            raise brak_produktu_na_stanie_except;
        END IF;
        
        -- czy jest wystarczajaca ilosc produktu na stanie magazynowym
        ilosc_na_st := pak_employee_manage.ilosc_produktu_na_stanie(id_prod);
        
        IF ilosc_na_st < ilosc_prod THEN
            raise brak_wystarczajacej_ilosci_except;
        END IF;
        
        
        SELECT ref(prac) INTO ref_pracownik FROM tab_pracownicy prac WHERE pracownikID = 8007;
        
        SELECT ref(pl) INTO ref_platnosci FROM tab_platnosci pl WHERE platnoscid = id_plat;
        
        SELECT ref(prod) INTO ref_produkt FROM tab_produkty prod WHERE produktID = id_prod;
        
        trans_id := SEQ_transakcje.NEXTVAL;
        
        --wprowadzenie transkacji
        INSERT INTO tab_transakcje(transakcjaID,dataWykonania,pracownik,platnosc)
            VALUES(trans_id, TO_DATE(sysdate,'DD-MM-YYYY'), ref_pracownik, ref_platnosci);
            
            
        SELECT REF(tr) INTO ref_trans FROM tab_transakcje tr WHERE transakcjaid = trans_id;
            
        -- wprowadzenie szczegolow_transakcji
        INSERT INTO tab_szczegolytransakcji(transakcja,recepta,produkt,ilosc)
            VALUES(ref_trans,NULL,ref_produkt,ilosc_prod);
            
            
        --aktualizacja stanu magazynowego
        
        pak_employee_manage.zaktualizuj_stan_produktu(id_prod, -ilosc_prod);
        
        DBMS_output.put_line('Transakcja przebiegla pomyslnie!');
        DBMS_output.put_line('Sprzedaz leku o ID: ' || id_prod ||' w ilosci: ' || ilosc_prod);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_output.put_line('Wprowadzono nie poprawne dane!');
        WHEN brak_produktu_na_stanie_except THEN
            DBMS_output.put_line('Brak produktu na stanie magazynowym!');
        WHEN brak_wystarczajacej_ilosci_except THEN
            DBMS_output.put_line('Brak wystarczajacej ilosci produktu na stanie magazynowym!');
    
    END zakup_lekarstwo;
  
  PROCEDURE wyswietl_wszystkie_leki AS
    Begin
    FOR lek IN (SELECT * FROM tab_Produkty) LOOP
        DBMS_OUTPUT.PUT_LINE('Produkt ID: ' || lek.produktID);
        DBMS_OUTPUT.PUT_LINE('Nazwa Produktu: ' || lek.nazwaProduktu);
        DBMS_OUTPUT.PUT_LINE('Cena Produktu: ' || lek.cenaProduktu);
        DBMS_OUTPUT.PUT_LINE('Data Produkcji: ' || TO_CHAR(lek.dataProdukcji, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Data Ważności: ' || TO_CHAR(lek.dataWaznosci, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Dostępność: ' || lek.dostepnosc);
        DBMS_OUTPUT.PUT_LINE('Opis: ' || lek.opis);
        IF lek.kategoria IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Kategoria: ' || lek.kategoria.nazwaKategorii);
        END IF;
    END LOOP;
END;

    
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
    END zamow_lek;
  
  
  PROCEDURE wyswietl_recepry_klienta(
    p_klient_id IN INT
) AS
BEGIN
    FOR r IN (
        SELECT r.RECEPTAID, r.DATAWYSTAWIENIA, r.DATAWAZNOSCI, r.KODDOSTEPU,
               l.IMIE AS IMIE_LEKARZA, l.NAZWISKO AS NAZWISKO_LEKARZA,
               k.IMIE AS IMIE_KLIENTA, k.NAZWISKO AS NAZWISKO_KLIENTA
        FROM tab_Recepty r
        JOIN tab_Lekarze l ON r.lekarz.lekarzID = l.lekarzID
        JOIN tab_Klienci k ON r.klient.klientID = k.klientID
        WHERE k.KLIENTID = p_klient_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID recepty: ' || r.RECEPTAID);
        DBMS_OUTPUT.PUT_LINE('Data wystawienia: ' || TO_CHAR(r.DATAWYSTAWIENIA, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Data ważności: ' || TO_CHAR(r.DATAWAZNOSCI, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Kod dostępu: ' || r.KODDOSTEPU);
        DBMS_OUTPUT.PUT_LINE('Lekarz: ' || r.IMIE_LEKARZA || ' ' || r.NAZWISKO_LEKARZA);
        DBMS_OUTPUT.PUT_LINE('Klient: ' || r.IMIE_KLIENTA || ' ' || r.NAZWISKO_KLIENTA);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
    END LOOP;
END wyswietl_recepry_klienta;

END PAK_CLIENT_MANAGE;
