-- zamawianie lekarstwa

SELECT * FROM tab_zamowienia;
SELECT * FROM tab_produkty;
SELECT * FROM tab_pracownicy;

BEGIN    
    pak_employee_manage.zamow_lek(1,TO_NUMBER(100),2);

END;
rollback;
commit;




