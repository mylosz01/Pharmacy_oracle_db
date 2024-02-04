CREATE OR REPLACE 
PACKAGE PAK_CLIENT_MANAGE AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  PROCEDURE zakup_lekarstwo(id_prod IN INT);
  
  PROCEDURE wyswietl_wszystkie_leki;
  
  PROCEDURE wyswietl_leki_z_kategorii(id_kat IN INT);
  
  PROCEDURE zamow_lek(id_prod IN INT);
  
  PROCEDURE wyswietl_historie_zakupow;

END PAK_CLIENT_MANAGE;