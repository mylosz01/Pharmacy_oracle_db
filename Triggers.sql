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