create or replace NONEDITIONABLE PACKAGE PAK_EMPLOYEE_TRANSACTION AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    brak_produktu_na_stanie_except EXCEPTION;
    brak_wystarczajacej_ilosci_except EXCEPTION;
  
  
    PROCEDURE zrealizuj_recepte(
    id_recepta IN INT,
    id_prac IN INT,
    id_plat IN INT);
    
    PROCEDURE sprzedaj_lek(
        id_prod IN INT,
        id_prac IN INT,
        id_plat IN INT,
        ilosc_prod IN NUMBER
        );
    
    PROCEDURE wyswietl_recepte(id_recepta IN INT);

END PAK_EMPLOYEE_TRANSACTION;


create or replace NONEDITIONABLE PACKAGE BODY PAK_EMPLOYEE_TRANSACTION AS

    PROCEDURE zrealizuj_recepte(
        id_recepta IN INT,
        id_prac IN INT,
        id_plat IN INT
    ) AS
        TYPE ref_cursor IS REF CURSOR;
        cur_produkt ref_cursor;
        
        stat VARCHAR2(50);
        ilo_wyd NUMBER;
        ilo_do_wyd NUMBER;
        
        ref_produkt type_produkty;
        ref_pracownik ref type_pracownicy;
        ref_platnosci ref type_platnosci;
        ref_trans ref type_transakcje;
        ref_recepta ref type_recepty;
        
        ilosc_prod_na_sta NUMBER;
        
        trans_id INT;
        nalezy_wydac NUMBER;
        ile_mozna_wydac NUMBER;
        
    BEGIN
        --sprawdzanie dostepnosci produktow z recepty
        dbms_output.put_line('RECEPTA ID : ' || id_recepta);
        
        OPEN cur_produkt FOR SELECT deref(szcz.produkt), status, ilosc_wydana, ilosc_do_wydania FROM tab_szczegolyrecept szcz WHERE deref(recepta).receptaID = id_recepta;
        
        LOOP
            FETCH cur_produkt INTO ref_produkt, stat, ilo_wyd, ilo_do_wyd;
            
            EXIT WHEN cur_produkt%NOTFOUND;
            dbms_output.put_line('');
            dbms_output.put_line('Produkt id: ' || ref_produkt.produktID || ' => ' || ref_produkt.nazwaProduktu); 
            dbms_output.put_line('Ilosc wydana: ' || ilo_wyd || ' / Ilosc do wydania: ' || ilo_do_wyd);
            dbms_output.put_line('Status: ' || stat);
            
            -- gdy produkt nie jest do konca zrealizowany
            IF stat != 'Zrealizowany' THEN
            
                --sprawdzanie stanu produktu na stanie magazynowym
                ilosc_prod_na_sta := pak_employee_manage.ilosc_produktu_na_stanie(ref_produkt.produktID);
                
                nalezy_wydac := ilo_do_wyd - ilo_wyd;
                dbms_output.put_line('nalezy wydac : ' || nalezy_wydac);
            
                --czy mozna wydac produkt
                IF ilosc_prod_na_sta >= nalezy_wydac THEN 
                
                    dbms_output.put_line('Wystarczajaca ilosc produktu ' || ref_produkt.nazwaProduktu || ' na stanie');
                    
                    -- wydawanie produktu ktorego ilosc jest wystarczajaca
                    
                    UPDATE tab_szczegolyrecept SET ilosc_wydana = ilosc_do_wydania WHERE deref(produkt).produktID = ref_produkt.produktID;
                    
                    pak_employee_manage.zaktualizuj_stan_produktu(ref_produkt.produktID, -nalezy_wydac);
                    
                    dbms_output.put_line('Wydanie produktu : ' || ref_produkt.nazwaProduktu || ' w ilosci ' || nalezy_wydac);
                
                ELSIF ilosc_prod_na_sta = 0 THEN
                    dbms_output.put_line('Zupelny brak produktu o id: ' || ref_produkt.produktID);
                
                ELSE
                    dbms_output.put_line('Brak wystarczajacej ilosc produktu o id: ' || ref_produkt.produktID ||' na stanie (' || ilosc_prod_na_sta ||')');
                    
                    
                    ile_mozna_wydac := ilosc_prod_na_sta;
                    
                    -- wydanie produktu zgodnie z mozliwoscia
                    dbms_output.put_line('Mozliwosc wydadania: ' || ile_mozna_wydac);
                    
                    UPDATE tab_szczegolyrecept SET ilosc_wydana = ilosc_wydana + ile_mozna_wydac WHERE deref(produkt).produktID = ref_produkt.produktID;
                    
                    pak_employee_manage.zaktualizuj_stan_produktu(ref_produkt.produktID, -ile_mozna_wydac);
                    
                    dbms_output.put_line('Wydanie produktu : ' || ref_produkt.nazwaProduktu || ' w ilosci ' || ile_mozna_wydac);
                    
                END IF;
            
            END IF;
            
        END LOOP;
        
        --przeprowadzenie transakcji
        SELECT ref(prac) INTO ref_pracownik FROM tab_pracownicy prac WHERE pracownikID = id_prac;
        
        SELECT ref(pl) INTO ref_platnosci FROM tab_platnosci pl WHERE platnoscid = id_plat;
        
        SELECT ref(rec) INTO ref_recepta FROM tab_recepty rec WHERE receptaID = id_recepta; 
        
        trans_id := SEQ_transakcje.NEXTVAL;
        
        --wprowadzenie transkacji
        INSERT INTO tab_transakcje(transakcjaID,dataWykonania,pracownik,platnosc)
            VALUES(trans_id, TO_DATE(sysdate,'DD-MM-YYYY'), ref_pracownik, ref_platnosci);
            
            
        SELECT REF(tr) INTO ref_trans FROM tab_transakcje tr WHERE transakcjaid = trans_id;
            
        -- wprowadzenie szczegolow_transakcji
        INSERT INTO tab_szczegolytransakcji(transakcja,recepta,produkt,ilosc)
            VALUES(ref_trans,ref_recepta,NULL,0);
    
        
    END zrealizuj_recepte;
    
    
    
    PROCEDURE sprzedaj_lek(
        id_prod IN INT,
        id_prac IN INT,
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
        IF pak_employee_manage.czy_produkt_na_stanie(id_prod) = FALSE THEN
            raise brak_produktu_na_stanie_except;
        END IF;
        
        -- czy jest wystarczajaca ilosc produktu na stanie magazynowym
        ilosc_na_st := pak_employee_manage.ilosc_produktu_na_stanie(id_prod);
        
        IF ilosc_na_st < ilosc_prod THEN
            raise brak_wystarczajacej_ilosci_except;
        END IF;
        
        
        SELECT ref(prac) INTO ref_pracownik FROM tab_pracownicy prac WHERE pracownikID = id_prac;
        
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
    
    END sprzedaj_lek;
    
    
    
    PROCEDURE wyswietl_recepte(id_recepta IN INT) AS
        ref_recepta ref type_recepty;
        recepta type_recepty;
        lekarz type_lekarze;
        pacjent type_klienci;

    BEGIN
        SELECT ref(rece) INTO ref_recepta FROM tab_recepty rece WHERE rece.receptaID = id_recepta;
        
        SELECT deref(ref_recepta) INTO recepta FROM dual;
        
        -- Wyświetlenie danych recepty
        DBMS_OUTPUT.PUT_LINE('ReceptaID: ' || recepta.receptaID);
        DBMS_OUTPUT.PUT_LINE('Data Wystawienia: ' || TO_CHAR(recepta.dataWystawienia, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Data Ważności: ' || TO_CHAR(recepta.dataWaznosci, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Kod Dostępu: ' || recepta.kodDostepu);
        
        DBMS_OUTPUT.PUT_LINE('');
        
        SELECT deref(recepta.lekarz) INTO lekarz FROM dual;
        DBMS_OUTPUT.PUT_LINE('LEKARZ : ' || lekarz.imie || ' ' || lekarz.nazwisko);
        DBMS_OUTPUT.PUT_LINE('');
        
        SELECT deref(recepta.klient) INTO pacjent from dual;
        DBMS_OUTPUT.PUT_LINE('KLIENT : ' || pacjent.imie || ' ' || pacjent.nazwisko);
        DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || TO_CHAR(pacjent.dataurodzenia, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Pesel: ' || pacjent.pesel);
        
        DBMS_OUTPUT.PUT_LINE('');
        
        DBMS_OUTPUT.PUT_LINE('Produkty w recepcie:');
        
        --wyswietlanie produktow w recepcie
        DECLARE
            CURSOR cur_produkty IS
                SELECT deref(produkt), status, ilosc_wydana, ilosc_do_wydania FROM tab_szczegolyrecept WHERE deref(recepta).receptaID = id_recepta;
            prod type_produkty;
            stat VARCHAR2(50);
            ilo_w NUMBER;
            ilo_do NUMBER;
            
        BEGIN
            
            OPEN cur_produkty;
            
            LOOP
                FETCH cur_produkty INTO prod, stat, ilo_w, ilo_do;
                
                EXIT WHEN
                    cur_produkty%NOTFOUND OR cur_produkty%NOTFOUND IS NULL;
                    
                DBMS_OUTPUT.PUT_LINE('');
                
                DBMS_OUTPUT.PUT_LINE('Nazwa produktu: ' || prod.nazwaProduktu);
                DBMS_OUTPUT.PUT_LINE('Status: ' || stat);
                DBMS_OUTPUT.PUT_LINE('Ilosc wydana: ' || ilo_w);
                DBMS_OUTPUT.PUT_LINE('Ilosc do wydania: ' || ilo_do);
                
            END LOOP;
        
            CLOSE cur_produkty;
        END;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Brak danej recepty o id: ' || id_recepta);
        
    END wyswietl_recepte;

END PAK_EMPLOYEE_TRANSACTION;



-- PRZYKLADY UZYCIA

SELECT * FROM tab_recepty;

SELECT * FROm tab_klienci;

SELECT * FROM tab_szczegolyrecept;

commit;

SELECT deref(recepta).receptaID, deref(produkt).produktID, status FROM tab_szczegolyrecept WHERE deref(recepta).receptaID = 2; 

--Wyswietl informacje o recepcie o podanym id

BEGIN 
    pak_employee_transaction.wyswietl_recepte(2);
END;


--sprzedaj lek

SELECT * FROM tab_transakcje;

SELECT * FROM tab_szczegolytransakcji;

SELECT deref(produkt).produktID, iloscnastanie, dataaktualizacji FROM tab_stanmagazynowy;

BEGIN
    pak_employee_transaction.sprzedaj_lek(
        id_prod => 2,
        id_prac => 4,
        id_plat => 2,
        ilosc_prod => 1
    );

END;

-- realizacja recepty

SELECT * FROM tab_szczegolytransakcji;

SELECT * FROM tab_transakcje;

--szczegoly recepty
SELECT deref(recepta).receptaID, deref(produkt).produktID, status, ilosc_wydana, ilosc_do_wydania FROM tab_szczegolyrecept WHERE deref(recepta).receptaID = 1; 

--ilosc na stanie
SELECT deref(produkt).produktID, iloscnastanie  FROM tab_stanmagazynowy;

commit;
rollback;

BEGIN 
    pak_employee_transaction.zrealizuj_recepte(id_recepta => 1, id_prac => 1, id_plat => 2);
END;

--dodanie produktu na stan
BEGIN
    pak_employee_manage.zaktualizuj_stan_produktu(2,5);
END;

UPDATE tab_szczegolyrecept SET status = 'W trakcie' , ilosc_wydana = 0 WHERE deref(recepta).receptaID = 1;


