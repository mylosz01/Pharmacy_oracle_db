--Tworzenie sekwencji dla lekarze
DROP SEQUENCE seq_lekarze;

CREATE SEQUENCE seq_lekarze START WITH 1 INCREMENT BY 1;


--Tworzenie sekwencji dla lekarze
DROP SEQUENCE seq_pracownicy;

CREATE SEQUENCE seq_pracownicy START WITH 1 INCREMENT BY 1;


--Tworzenie sekwencji dla Klienci
DROP SEQUENCE seq_klienci;

CREATE SEQUENCE seq_klienci START WITH 1 INCREMENT BY 1;


--Tworzenie sekwencji dla kategoria
DROP SEQUENCE seq_kategorie;

CREATE SEQUENCE seq_kategorie START WITH 1 INCREMENT BY 1;  

	
--Tworzenie sekwencji dla produkty
DROP SEQUENCE seq_produkty;

CREATE SEQUENCE seq_produkty START WITH 1 INCREMENT BY 1;


--Tworzenie sekwencji dla transakcji
DROP SEQUENCE seq_transakcje;

CREATE SEQUENCE seq_transakcje START WITH 1 INCREMENT BY 1;


--Tworzenie sekwencji dla Zamowienia
DROP SEQUENCE seq_zamowienia;

CREATE SEQUENCE seq_zamowienia START WITH 1 INCREMENT BY 1;


--Tworzenie sekwencji dla recepty
DROP SEQUENCE seq_recepty;

CREATE SEQUENCE seq_recepty START WITH 1 INCREMENT BY 1;


--Tworzenie sekwencji dla magazyny
DROP SEQUENCE seq_magazyny;

CREATE SEQUENCE seq_magazyny START WITH 1 INCREMENT BY 1;
