--trigger do aktualizacji daty w stanie magazynowym
CREATE OR REPLACE TRIGGER TRIG_AKTUALIZUJ_STAN_MAGAZYNOWY 
BEFORE INSERT OR UPDATE ON TAB_STANMAGAZYNOWY FOR EACH ROW
BEGIN
  :NEW.dataAktualizacji := SYSDATE;
END;


-- trigger informujacy o malej ilosci lekarstwa na stanie
CREATE OR REPLACE TRIGGER TRIG_MALA_ILOSC_NA_STANIE 
BEFORE INSERT OR UPDATE ON TAB_STANMAGAZYNOWY 
FOR EACH ROW
DECLARE
    ref_produkt type_produkty;
BEGIN
    SELECT DEREF(:NEW.produkt) INTO ref_produkt FROM DUAL;
    
    IF :NEW.iloscnastanie <= 8 THEN
        dbms_output.put_line('Mala ilosc produktu : ' || ref_produkt.produktID || ' ' || ref_produkt.nazwaProduktu);
    END IF;
END;


-- trigger ustawiajacy status zrealizowany gdy wydano nalezne leki
CREATE OR REPLACE TRIGGER TRIG_REALIZACJA_RECEPT 
BEFORE UPDATE ON TAB_SZCZEGOLYRECEPT 
FOR EACH ROW
BEGIN
    IF :NEW.ilosc_wydana = :NEW.ilosc_do_wydania THEN
        :NEW.status := 'Zrealizowany';
    ELSE
        :NEW.status := 'W trakcie';
    END IF;
END;