-- tworzenie obiektu produkt w magazynie
CREATE TYPE type_produkt_w_magazynie AS OBJECT (
    produkt REF type_produkty,
    ilosc_w_magazynie NUMBER(10,2)
);


-- tworzenie obiektu tabelarycznego
CREATE TYPE type_zawartosc_magazynu AS TABLE OF type_produkt_w_magazynie;

-- tworzenie tabeli zagniezdzonej
CREATE TABLE tab_Magazyny (
    magazynID INTEGER,
    kraj VARCHAR(30),
    miasto VARCHAR(40),
    nazwaUlicy VARCHAR(50),
    nrBudynku INT,
    produkty_w_magazynie type_zawartosc_magazynu
) NESTED TABLE produkty_w_magazynie STORE AS store_product_warehouse;


SELECT * FROM tab_Magazyny;

-- dodawanie przykladowych magazynow wraz z produktami
BEGIN

    INSERT INTO tab_Magazyny (
        magazynID, 
        kraj, 
        miasto, 
        nazwaUlicy, 
        nrBudynku, 
        produkty_w_magazynie
    ) VALUES (
        seq_magazyny.nextval, 
        'Polska', 
        'Warszawa', 
        'ul. Prosta', 
        10, 
        type_zawartosc_magazynu(
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 1), 
                100
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 2), 
                45
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 5), 
                30
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 7), 
                120
            )
        )
    );

    INSERT INTO tab_Magazyny (
        magazynID, 
        kraj, 
        miasto, 
        nazwaUlicy, 
        nrBudynku, 
        produkty_w_magazynie
    ) VALUES (
        seq_magazyny.nextval, 
        'Polska', 
        'Kraków', 
        'ul. Krakowska', 
        20, 
        type_zawartosc_magazynu(
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 2), 
                50
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 3), 
                75
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 6), 
                20
            ),
            type_produkt_w_magazynie(
                (SELECT REF(p) FROM tab_produkty p WHERE produktID = 5), 
                64
            )
        )
    );


END;

SELECT * FROM tab_magazyny;

--aktualizacja stanu produktow
UPDATE TABLE(SELECT mag.produkty_w_magazynie FROM tab_magazyny mag WHERE mag.magazynID = 1) pr 
SET pr.ilosc_w_magazynie = pr.ilosc_w_magazynie + 10 
WHERE pr.produkt.produktID = 1;


-- wyswietlanie stanu magazynu
SELECT prod_mag.produkt.produktId, prod_mag.ilosc_w_magazynie FROM tab_magazyny mag, TABLE(produkty_w_magazynie) prod_mag WHERE mag.magazynID = 1;

--Aktualizacja produktu w magazynu
BEGIN   
    pak_admin_manage_store.zaktualizuj_stan_produktu_w_magazynie(id_magazynu=> 1, id_prod=> 5,ilosc_dodania => 10);
END;

commit;
rollback;
-- wyswietlanie zawartosci magazynu o podanym id
BEGIN   
    pak_admin_manage_store.wyswietl_produkty_z_magazynu(id_magazynu=> 1);
END;

-- usuwanie produktu z magazynu
BEGIN 
    pak_admin_manage_store.usun_produkt_z_magazynu(id_magazynu=>1, id_produktu => 5); 
END;


