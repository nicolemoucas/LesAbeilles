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
    idPersonne INTEGER;
BEGIN  
    SELECT INTO idPersonne idpers FROM (SELECT * FROM recherche_client($1, $2, $3)) AS client;
	DELETE FROM Client WHERE idClient = idPersonne;
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
DROP FUNCTION IF EXISTS f_rechercher_employe;
CREATE OR REPLACE FUNCTION f_rechercher_employe(roleEmploye VARCHAR, nomEmploye VARCHAR, prenomEmploye VARCHAR, dateNaissanceEmploye DATE, mailEmploye VARCHAR, numTelEmploye VARCHAR)
RETURNS TABLE (idEmp INTEGER, nomUtilEmp VARCHAR, nomEmp VARCHAR, prenomEmp VARCHAR, mailEmp VARCHAR, numTelEmp VARCHAR) AS $$

BEGIN
    RETURN QUERY SELECT idCompte, nomUtilisateur, nom, prenom, mail, numTelephone
		FROM CompteEmploye 
		WHERE typeEmploye::TEXT LIKE ($1) AND lower(Nom) = lower($2) AND lower(Prenom) = lower($3) AND DateNaissance = $4 AND (lower(mail) = lower($5) OR numTelephone = $6);
END;
$$ Language PlpgSQL;
--SELECT * FROM CompteEmploye;
SELECT f_rechercher_employe('Moniteur', 'BOND', 'James', '1996-08-04', 'jbond@lesabeilles.fr', null); -- test

/* Créer un propriétaire */
SELECT * FROM CompteEmploye WHERE TypeEmploye = 'Propriétaire';
DROP FUNCTION IF EXISTS f_creer_proprietaire;
CREATE OR REPLACE FUNCTION f_creer_proprietaire(nomUtilisateur VARCHAR, motDePasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR)
	RETURNS int
	AS $BODY$
DECLARE
	nouvIdProprietaire int;
	nomUtil VARCHAR;
	mdp VARCHAR;
BEGIN
	nomUtil := $1;
	mdp := $2;
	INSERT INTO CompteEmploye (NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
		($1, crypt($2, gen_salt('bf')), $3, $4, $5, $6, $7, 'Propriétaire')
		RETURNING IdCompte INTO nouvIdProprietaire;
	-- créer user et ajout au groupe de propriétaires
    EXECUTE FORMAT('CREATE USER "%I" WITH ENCRYPTED PASSWORD ''%s''', nomUtil, mdp);
	EXECUTE FORMAT('GRANT proprietaires_abeilles TO %I', nomUtil);
	RETURN nouvIdProprietaire;
END;
$BODY$
LANGUAGE PlpgSQL;
--SELECT f_creer_proprietaire('kfrottier', 'kfrottiermdp', 'FROTTIER', 'Kylie', '1996-08-04', 'kfrottier@lesabeilles.fr', null); --test

/* Créer un moniteur */
--SELECT * FROM CompteEmploye WHERE TypeEmploye = 'Moniteur';
-- la FK diplôme est insérée au moment de créer le diplôme
DROP FUNCTION IF EXISTS f_creer_moniteur;
CREATE OR REPLACE FUNCTION f_creer_moniteur(nomUtilisateur VARCHAR, motdepasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR)
	RETURNS int
	AS $BODY$
DECLARE
	nouvIdMoniteur int;
	nomUtil VARCHAR;
	mdp VARCHAR;
BEGIN
	nomUtil := $1;
	mdp := $2;
	INSERT INTO CompteEmploye (NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
		($1, crypt($2, gen_salt('bf')), $3, $4, $5, $6, $7, 'Moniteur')
		RETURNING IdCompte INTO nouvIdMoniteur;
	-- créer user et ajout au groupe de moniteurs
    EXECUTE FORMAT('CREATE USER "%I" WITH ENCRYPTED PASSWORD ''%s''', nomUtil, mdp);
	EXECUTE FORMAT('GRANT moniteurs_abeilles TO %I', nomUtil);
	RETURN nouvIdMoniteur;
END;
$BODY$
LANGUAGE PlpgSQL;
--SELECT f_creer_moniteur('batman', 'batmanmdp', 'WAYNE', 'Bruce', '1996-08-04', 'bwayne@batman.com', null); --test

/* Supprimer un employé */
DROP PROCEDURE IF EXISTS p_supprimer_employe;
CREATE OR REPLACE PROCEDURE p_supprimer_employe(roleEmploye VARCHAR, nomEmploye VARCHAR, prenomEmploye VARCHAR, dateNaissanceEmploye DATE, mailEmploye VARCHAR, numTelEmploye VARCHAR)
	AS $BODY$
DECLARE
    idEmploye INTEGER;
	nomUtil VARCHAR;
BEGIN
    SELECT idEmp, nomUtilEmp INTO idEmploye, nomUtil FROM (SELECT * FROM f_rechercher_employe($1, $2, $3, $4, $5, $6)) AS employe;
	DELETE FROM CompteEmploye WHERE idCompte = idEmploye;
	-- supprimer rôle employé
	EXECUTE FORMAT('DROP USER IF EXISTS %I', nomUtil);
END;
$BODY$
LANGUAGE PlpgSQL;
--CALL p_supprimer_employe('Propriétaire', 'FROTTIER', 'Kylie', '1996-08-04', 'kfrottier@lesabeilles.fr', null); --test
--SELECT * FROM CompteEmploye where typeemploye = 'Propriétaire';
--SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'kfrottier';

/* Créer diplôme */
DROP PROCEDURE IF EXISTS p_creer_diplome;
CREATE OR REPLACE PROCEDURE p_creer_diplome(dateObtention DATE, LienDocumentPDF VARCHAR, IdMoniteur int) 
	AS $BODY$
DECLARE 
	nouvIdDiplome int;
BEGIN
	INSERT INTO Diplome (DateObtention, LienDocumentPDF, IdMoniteur) VALUES
	($1, $2, $3)
	RETURNING IdDiplome INTO nouvIdDiplome;
	-- Insertion du diplôme (FK) dans moniteur
	UPDATE CompteEmploye 
		SET IdDiplome = nouvIdDiplome
		WHERE IdCompte = $3;
END;
$BODY$
LANGUAGE PlpgSQL;
--SELECT * FROM CompteEmploye WHERE TypeEmploye = 'Moniteur';
--SELECT * FROM Diplome d inner join CompteEmploye c on d.idMoniteur = c.idCompte;
--CALL p_creer_diplome ('2022-02-02', 'LIENTEST.com', 3);

-- check constraints de Diplôme et Moniteur
SELECT conname AS constraint_name, 
contype AS constraint_type
FROM pg_catalog.pg_constraint cons
JOIN pg_catalog.pg_class t ON t.oid = cons.conrelid
WHERE t.relname ='diplome' OR t.relname = 'compteemploye';

/* 11 - Créer permis bateau */
DROP PROCEDURE IF EXISTS p_creer_permis;
CREATE OR REPLACE PROCEDURE p_creer_permis(dateObtention DATE, LienDocumentPDF VARCHAR, IdProprietaire int) 
	AS $BODY$
DECLARE 
	nouvIdPermis int;
BEGIN
	INSERT INTO PermisBateau (DateObtention, LienDocumentPDF, IdProprietaire) VALUES
	($1, $2, $3)
	RETURNING IdPermis INTO nouvIdPermis; 
	-- Insertion du diplôme (FK) dans moniteur
	UPDATE CompteEmploye 
		SET IdPermis = nouvIdPermis
		WHERE IdCompte = $3;
END;
$BODY$
LANGUAGE PlpgSQL;
--CALL p_creer_permis('2022-10-10', 'LIENTESTPERMIS.com', 2); --test
--SELECT * FROM PermisBateau;

/* 12 - Trouver noms moniteurs */
DROP FUNCTION IF EXISTS fetch_nom_moniteur;
CREATE OR REPLACE FUNCTION fetch_nom_moniteur()
RETURNS TABLE (id_moniteur INT, nom_moniteur VARCHAR, prenom_moniteur VARCHAR, date_moniteur DATE) AS $$

BEGIN
    RETURN QUERY (SELECT idcompte, nom, prenom, datenaissance FROM compteemploye WHERE typeemploye='Moniteur');
END;
$$ Language PlpgSQL;

DROP FUNCTION IF EXISTS verification_utilisateur;
CREATE OR REPLACE FUNCTION verification_utilisateur(identifiant VARCHAR, mdp VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE 
    mdpcrypte VARCHAR;
BEGIN
    SELECT INTO mdpcrypte motdepasse FROM informations_connexion WHERE nomutilisateur=$1;
    IF mdpcrypte IS NOT NULL THEN 
        RETURN (SELECT (mdpcrypte= crypt($2, mdpcrypte)));
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ Language PlpgSQL;

DROP FUNCTION IF EXISTS fetch_role_utilisateur;
CREATE OR REPLACE FUNCTION fetch_role_utilisateur(identifiant VARCHAR, mdp VARCHAR)
RETURNS etypeemploye AS $$
DECLARE 
	mdpcrypte VARCHAR;
BEGIN
    SELECT INTO mdpcrypte motdepasse FROM informations_connexion WHERE nomutilisateur=$1;
    RETURN (SELECT typeemploye FROM informations_connexion WHERE nomutilisateur = $1 AND motdepasse = crypt($2, mdpcrypte));
END;
$$ Language PlpgSQL;

-- false si le moniteur est pas dispo, true s'il est dispo
DROP FUNCTION IF EXISTS verification_moniteur_disponible;
CREATE OR REPLACE FUNCTION verification_moniteur_disponible(idMoniteur INT, dateHeureCours TIMESTAMP)
RETURNS BOOLEAN AS $$

BEGIN
     RETURN (SELECT(NOT EXISTS(SELECT * FROM coursplanchevoile WHERE idCompte = idMoniteur AND dateheure BETWEEN $2 - interval '2 hours' AND $2 + interval '2 hours' AND etatcours='Prévu')));
END;
$$ Language PlpgSQL;

DROP PROCEDURE IF EXISTS creer_cours;
CREATE OR REPLACE PROCEDURE creer_cours(horaireCours TIMESTAMP, nivCours EStatutClient, idMoniteur INT) AS $BODY$
BEGIN
    INSERT INTO CoursPlancheVoile(dateheure, niveau, etatcours, idcompte) VALUES ($1, $2, 'Prévu', $3);
END;
$BODY$
LANGUAGE PlpgSQL;