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

/* 5 - Consulter la liste des employés */
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

/* 6 - Afficher profil Employe */
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

/* 7 - Retrouver un employé */
--SELECT enum_range(null::ERoleEmploye); -- "{Propriétaire,Moniteur,""Garçon de Plage""}"
SELECT * FROM CompteEmploye;
DROP FUNCTION IF EXISTS f_rechercher_employe;
CREATE OR REPLACE FUNCTION f_rechercher_employe(roleEmploye VARCHAR, nomEmploye VARCHAR, prenomEmploye VARCHAR, dateNaissanceEmploye DATE, mailEmploye VARCHAR, numTelEmploye VARCHAR)
RETURNS TABLE (idEmp INTEGER, nomEmp VARCHAR, prenomEmp VARCHAR, mailEmp VARCHAR, numTelEmp VARCHAR) AS $$

BEGIN
    RETURN QUERY SELECT idCompte, nom, prenom, mail, numTelephone
		FROM CompteEmploye 
		WHERE typeEmploye::TEXT LIKE ($1) AND lower(Nom) = lower($2) AND lower(Prenom) = lower($3) AND DateNaissance = $4 AND (lower(mail) = lower($5) OR numTelephone = $6);
END;
$$ Language PlpgSQL;
-- SELECT f_rechercher_employe('Moniteur', 'BOND', 'James', '1996-08-04', 'jbond@yahoor.fr', null); -- test

/* 8 - Créer un moniteur */
--SELECT * FROM CompteEmploye WHERE TypeEmploye = 'Moniteur';
-- la FK diplôme est insérée au moment de créer le diplôme
DROP FUNCTION IF EXISTS f_creer_moniteur;
CREATE OR REPLACE FUNCTION f_creer_moniteur(nomUtilisateur VARCHAR, motdepasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR)
	RETURNS int
	AS $BODY$
DECLARE nouvIdMoniteur int;

BEGIN
	INSERT INTO CompteEmploye (NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
		($1, crypt($2, gen_salt('bf')), $3, $4, $5, $6, $7, 'Moniteur')
		RETURNING IdCompte INTO nouvIdMoniteur;
	RETURN nouvIdMoniteur;
END;
$BODY$
LANGUAGE PlpgSQL;
SELECT f_creer_moniteur ('jbond', 'jbond', 'BOND', 'James', '1996-08-04', 'jbond@yahoor.fr', null); --test

/* 9 - Créer un propriétaire */
SELECT * FROM CompteEmploye WHERE TypeEmploye = 'Propriétaire';
-- la FK diplôme est insérée au moment de créer le diplôme
DROP FUNCTION IF EXISTS f_creer_moniteur;
CREATE OR REPLACE FUNCTION f_creer_moniteur(nomUtilisateur VARCHAR, motdepasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR)
	RETURNS RECORD
	AS $BODY$
DECLARE nouvIdMoniteur RECORD;

BEGIN
	INSERT INTO CompteEmploye (NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
		($1, crypt($2, gen_salt('bf')), $3, $4, $5, $6, $7, 'Moniteur')
		RETURNING IdCompte INTO nouvIdMoniteur;
	RETURN nouvIdMoniteur;
END;
$BODY$
LANGUAGE PlpgSQL;
--SELECT f_creer_moniteur ('jbond', 'jbond', 'BOND', 'James', '1996-08-04', 'jbond@yahoor.fr', null); --test

/* 10 - Créer diplôme */
DROP PROCEDURE IF EXISTS p_creer_diplome;
CREATE OR REPLACE PROCEDURE p_creer_diplome(dateObtention DATE, LienDocumentPDF VARCHAR, IdMoniteur int) 
	AS $BODY$
DECLARE nouvIdDiplome int;
BEGIN
	INSERT INTO Diplome (DateObtention, LienDocumentPDF, IdMoniteur) VALUES
	($1, $2, $3)
	RETURNING IdDiplome INTO nouvIdDiplome;
	UPDATE CompteEmploye 
		SET IdDiplome = nouvIdDiplome
		WHERE IdCompte = $3;
END;
$BODY$
LANGUAGE PlpgSQL;
SELECT * FROM CompteEmploye WHERE TypeEmploye = 'Moniteur';
SELECT * FROM Diplome d inner join CompteEmploye c on d.idMoniteur = c.idCompte;
--CALL p_creer_diplome ('2022-02-02', 'vsdsdf', 3);


-- check constraints de Diplôme et Moniteur
SELECT conname AS constraint_name, 
contype AS constraint_type
FROM pg_catalog.pg_constraint cons
JOIN pg_catalog.pg_class t ON t.oid = cons.conrelid
WHERE t.relname ='diplome' OR t.relname = 'compteemploye';

/* 11 - Créer permis bateau */
DROP PROCEDURE IF EXISTS p_creer_permis;
CREATE OR REPLACE PROCEDURE p_creer_permis(dateObtention DATE, LienDocumentPDF VARCHAR, IdProprietaire int) AS $BODY$
BEGIN
	INSERT INTO PermisBateau (DateObtention, LienDocumentPDF, IdProprietaire) VALUES
	($1, $2, $3); 
END;
$BODY$
LANGUAGE PlpgSQL;
--CALL p_creer_permis('2022-10-10', 'csdc', 2); --test
--SELECT * FROM PermisBateau;
