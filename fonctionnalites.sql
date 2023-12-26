/* FONCTIONNALITÉS */

/* 1 - Retrouver un client */

DROP FUNCTION IF EXISTS recherche_client;
CREATE OR REPLACE FUNCTION recherche_client(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE)
RETURNS TABLE (idpers INTEGER, nomCl VARCHAR, prenomCl VARCHAR, dateNaissanceCl DATE, mailCl VARCHAR, 
campingCl ECamping, statutCl EStatutClient, poidsCl FLOAT, tailleCl FLOAT, preferenceContactCl EPreferenceContact, numTelephoneCl VARCHAR) AS $$

BEGIN
    RETURN QUERY SELECT * FROM client WHERE lower(Nom) = lower($1) AND lower(Prenom) = lower($2) AND DateNaissance = $3;
END;
$$ Language PlpgSQL;

/* 2 - Créer un client */
DROP PROCEDURE IF EXISTS creer_client;
CREATE OR REPLACE PROCEDURE creer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR,
camping ECamping, statut EStatutClient, poids FLOAT, taille FLOAT, preferenceContact EPreferenceContact) AS $BODY$
BEGIN
    INSERT INTO Client(nom, prenom, datenaissance, mail, numtelephone, camping, statut, poids, taille, preferenceContact) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
END;
$BODY$
LANGUAGE PlpgSQL;
