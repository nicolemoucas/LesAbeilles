/* FONCTIONNALITÉS */

/* 1 - Retrouver un client */
DROP FUNCTION IF EXISTS recherche_client;
CREATE OR REPLACE FUNCTION recherche_client(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE)
RETURNS TABLE (idpers INTEGER, nomCl VARCHAR, prenomCl VARCHAR, dateNaissanceCl DATE, mailCl VARCHAR, numTelephoneCl VARCHAR,
campingCl ECamping, statutCl EStatutClient, poidsCl FLOAT, tailleCl FLOAT, preferenceContactCl EPreferenceContact, idCertificatCl INTEGER) AS $$

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

/* 3 - Supprimer un client */
DROP PROCEDURE IF EXISTS supprimer_client;
CREATE OR REPLACE PROCEDURE supprimer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE) AS $BODY$
DECLARE
    idClient INTEGER;
BEGIN  
    SELECT INTO idClient idpers FROM (SELECT * FROM recherche_client($1, $2, $3)) AS client;
	DELETE FROM Client WHERE idPersonne = idClient;
	
END;
$BODY$
LANGUAGE PlpgSQL;

/* 4 - Retrouver un moniteur */
DROP FUNCTION IF EXISTS recherche_moniteur;
CREATE OR REPLACE FUNCTION recherche_moniteur(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE)
RETURNS TABLE (idpers INTEGER, nomMo VARCHAR, prenomMo VARCHAR, dateNaissanceMo DATE, mailMo VARCHAR, numTelephoneMo VARCHAR) AS $$

BEGIN
    RETURN QUERY SELECT * FROM moniteur WHERE lower(Nom) = lower($1) AND lower(Prenom) = lower($2) AND DateNaissance = $3;
END;
$$ Language PlpgSQL;


/* 5 - Créer un moniteur */
DROP PROCEDURE IF EXISTS creer_moniteur;
CREATE OR REPLACE PROCEDURE creer_moniteur(nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR) AS $BODY$
BEGIN
    INSERT INTO Client(nom, prenom, datenaissance, mail, numtelephone) VALUES ($1, $2, $3, $4, $5);
END;
$BODY$
LANGUAGE PlpgSQL;

--5 - Consulter la liste des employés
CREATE OR REPLACE FUNCTION ConsulterListeEmploye()
RETURNS TABLE (
    Nom VARCHAR(30),
    Prenom VARCHAR(30),
    Mail VARCHAR(50),
    NumTelephone VARCHAR(16),
    DateNaissance DATE,
    TypeEmploye EtypeEmploye
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ce.nom,
        ce.prenom,
        ce.mail,
        ce.numtelephone,
        ce.datenaissance,
        ce.typeemploye
    FROM
        compteemploye ce;
END;
$$ LANGUAGE plpgsql;

--  6- Afficher profil Employe 
DROP FUNCTION IF EXISTS AfficherProfilEmploye(Nom VARCHAR(30), Prenom VARCHAR(30));
CREATE OR REPLACE FUNCTION AfficherProfilEmploye(Nom VARCHAR(30), Prenom VARCHAR(30))
RETURNS TABLE (
    nomEmploye VARCHAR(30),
    prenomEmploye VARCHAR(30),
    dateNaissanceEmploye DATE,
    mail VARCHAR(50),
    numTelephone VARCHAR(30),
    TypeEmploye EtypeEmploye
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        Ce.nom,
        Ce.prenom,
        Ce.datenaissance,
        Ce.mail,
        Ce.numtelephone,
        Ce.TypeEmploye
    FROM
        CompteEmploye Ce
    WHERE
        lower(Ce.nom) = lower($1) AND lower(Ce.prenom) = lower($2);
END;
$$ LANGUAGE plpgsql;


