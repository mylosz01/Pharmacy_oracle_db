create or replace NONEDITIONABLE PACKAGE PAK_ADMIN_MANAGE_EMPLOYEE AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    brak_pracownika_except EXCEPTION;
    niepoprawna_wartosc EXCEPTION;
  
    FUNCTION czy_istnieje_pracownik(id_prac IN INT) RETURN BOOLEAN;
  
    PROCEDURE dodaj_pracownika
        (imiee IN VARCHAR2 default '-',
        nazwiskoo IN VARCHAR2 default '-',
        data_urodz IN DATE default TO_DATE('01-01-2024','DD-MM-YY'),
        wiekk IN INT default 1,
        nr_tel IN VARCHAR2 default '000000000',
        pensjaa IN NUMBER default 1000,
        premiaa IN NUMBER default 0);
    
    PROCEDURE usun_pracownika(id_prac IN INT DEFAULT 0);
    
    PROCEDURE modyfikuj_premie(id_prac IN INT DEFAULT 0, wartosc_premii IN NUMBER DEFAULT 0);
    
    PROCEDURE modyfikuj_wyplate(id_prac IN INT DEFAULT 0, wartosc_pensji IN NUMBER DEFAULT 0);
  
END PAK_ADMIN_MANAGE_EMPLOYEE;

create or replace NONEDITIONABLE PACKAGE BODY PAK_ADMIN_MANAGE_EMPLOYEE AS


    FUNCTION czy_istnieje_pracownik(id_prac IN INT) RETURN BOOLEAN IS
        pracownik INT;
    BEGIN
        
        SELECT COUNT(*) INTO pracownik FROM tab_pracownicy WHERE pracownikID = id_prac;
        
        IF pracownik > 0 THEN
            return TRUE;
        else
            raise brak_pracownika_except;
        end if;
        
    EXCEPTION
        WHEN brak_pracownika_except THEN
            dbms_output.put_line('Pracownik o id : ' || id_prac || ' nie istnieje');
            RETURN FALSE;
        
    end czy_istnieje_pracownik;

    PROCEDURE dodaj_pracownika
        (imiee IN VARCHAR2 default '-',
        nazwiskoo IN VARCHAR2 default '-',
        data_urodz IN DATE default TO_DATE('01-01-2024','DD-MM-YY'),
        wiekk IN INT default 1,
        nr_tel IN VARCHAR2 default '000000000',
        pensjaa IN NUMBER default 1000,
        premiaa IN NUMBER default 0) AS
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
    END dodaj_pracownika;
    
    
    PROCEDURE usun_pracownika(id_prac IN INT DEFAULT 0) AS
    BEGIN    
        IF czy_istnieje_pracownik(id_prac) THEN
            DELETE FROM tab_pracownicy WHERE pracownikID = id_prac;
        ELSE
            RAISE brak_pracownika_except;
        end if;
        
        dbms_output.put_line('Usunieto pracownika o id: ' || id_prac);
        
    EXCEPTION
        WHEN brak_pracownika_except THEN
            dbms_output.put_line('Nie udalo sie usunac pracownika o id: ' || id_prac);
        
    END usun_pracownika;
    
    
    
    PROCEDURE modyfikuj_premie(id_prac IN INT DEFAULT 0, wartosc_premii IN NUMBER DEFAULT 0) AS
    BEGIN
    
        IF wartosc_premii < 0 THEN
            RAISE niepoprawna_wartosc;
        end if;
    
        IF czy_istnieje_pracownik(id_prac) THEN
            UPDATE tab_pracownicy SET premia = wartosc_premii WHERE pracownikID = id_prac;
        ELSE
            RAISE brak_pracownika_except;
        end if;
        
        dbms_output.put_line('Zmodyfikowano premie pracownika o id: ' || id_prac || ' na ' || wartosc_premii);
        
    EXCEPTION
        WHEN brak_pracownika_except THEN
            dbms_output.put_line('Nie udalo sie zmodyfikowac premii pracownika o id: ' || id_prac);
        WHEN niepoprawna_wartosc THEN
            dbms_output.put_line('Wprowadzono nie poprawna wartosc premii'); 
    
    END modyfikuj_premie;
    
    
    
    PROCEDURE modyfikuj_wyplate(id_prac IN INT DEFAULT 0, wartosc_pensji IN NUMBER DEFAULT 0) AS
    BEGIN
    
        IF wartosc_pensji < 0 THEN
            RAISE niepoprawna_wartosc;
        end if;
    
        IF czy_istnieje_pracownik(id_prac) THEN
            UPDATE tab_pracownicy SET pensja = wartosc_pensji WHERE pracownikID = id_prac;
        ELSE
            RAISE brak_pracownika_except;
        end if;
        
        dbms_output.put_line('Zmodyfikowano pensje pracownika o id: ' || id_prac || ' na ' || wartosc_pensji);
        
    EXCEPTION
        WHEN brak_pracownika_except THEN
            dbms_output.put_line('Nie udalo sie zmodyfikowac premii pracownika o id: ' || id_prac);
        WHEN niepoprawna_wartosc THEN
            dbms_output.put_line('Wprowadzono nie poprawna wartosc pensji');
    
    END modyfikuj_wyplate;

END PAK_ADMIN_MANAGE_EMPLOYEE;



-- PRZYKLADOWE UZYCIA
SELECT * FROM tab_pracownicy;

-- sprawdzanie czy pracownik istnieje
DECLARE
    res BOOLEAN := FALSE;

BEGIN
    res := pak_admin_manage_employee.czy_istnieje_pracownik(8);
    
    if res = TRUE then
        dbms_output.put_line('istnieje');
    else
        dbms_output.put_line('nie istnieje');
    end if;

END;

--dodanie pracownika
BEGIN
    PAK_ADMIN_MANAGE_EMPLOYEE.dodaj_pracownika(
            imiee => 'Jerzy',
            nazwiskoo => 'Owsiak',
            data_urodz => TO_DATE('03-06-2001', 'DD-MM-YYYY'),
            wiekk => 22,
            nr_tel => '546236235',
            pensjaa => TO_NUMBER('2500'),
            premiaa => TO_NUMBER('0')
        );
END;

--usuniecie pracownika
SELECT * FROM tab_pracownicy;
rollback;
commit;
BEGIN
    
    pak_admin_manage_employee.usun_pracownika(1);

END;

--modyfikacja premii
SELECT * FROM tab_pracownicy;
rollback;
commit;
BEGIN
    
    pak_admin_manage_employee.modyfikuj_premie(1,0);

END;

--modyfikacja pensjii
SELECT * FROM tab_pracownicy;
rollback;
commit;
BEGIN
    
    pak_admin_manage_employee.modyfikuj_wyplate(1,3200);

END;

