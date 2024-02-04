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
    
    pak_admin_manage_employee.modyfikuj_premie(1,100);

END;

--modyfikacja pensjii
SELECT * FROM tab_pracownicy;
rollback;
commit;
BEGIN
    
    pak_admin_manage_employee.modyfikuj_wyplate(1,3000);

END;