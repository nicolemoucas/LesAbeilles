/* FONCTIONNALITÉS */

/* 1 - Retrouver un client */
DROP FUNCTION IF EXISTS recherche_client;
CREATE OR REPLACE FUNCTION recherche_client(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE)
RETURNS TABLE (idpers INTEGER, nomCl VARCHAR, prenomCl VARCHAR, dateNaissanceCl DATE, mailCl VARCHAR, numTelephoneCl VARCHAR,
campingCl ECamping, statutCl EStatutClient, tailleCl INTEGER, poidsCl FLOAT, preferenceContactCl EPreferenceContact, idCertificatCl INTEGER) AS $$

BEGIN
    RETURN QUERY SELECT * FROM client WHERE lower(Nom) = lower($1) AND lower(Prenom) = lower($2) AND DateNaissance = $3;
END;
$$ Language PlpgSQL;

/* 2 - Créer un client */
DROP PROCEDURE IF EXISTS creer_client;
CREATE OR REPLACE PROCEDURE creer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR,
camping ECamping, statut EStatutClient, poids FLOAT, taille INTEGER, preferenceContact EPreferenceContact) AS $BODY$
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
		WHERE lower(typeEmploye::TEXT) LIKE lower($1) AND lower(Nom) = lower($2) AND lower(Prenom) = lower($3) AND DateNaissance = $4 AND (lower(mail) = lower($5) OR numTelephone = $6);
END;
$$ Language PlpgSQL;
--SELECT * FROM CompteEmploye;
--SELECT f_rechercher_employe('Moniteur', 'BOND', 'James', '1996-08-04', 'jbond@lesabeilles.fr', null); -- test

/* 8- Créer un propriétaire */
--SELECT * FROM CompteEmploye WHERE TypeEmploye = 'Propriétaire';
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
	IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = $1) THEN
		EXECUTE FORMAT('REASSIGN OWNED BY %I TO proprietaires_abeilles', nomUtil);
	END IF;
	EXECUTE FORMAT('DROP USER IF EXISTS %I', nomUtil);
    EXECUTE FORMAT('CREATE USER "%I" WITH ENCRYPTED PASSWORD ''%s''', nomUtil, mdp);
	EXECUTE FORMAT('GRANT proprietaires_abeilles TO %I', nomUtil);
	RETURN nouvIdProprietaire;
END;
$BODY$
LANGUAGE PlpgSQL;
SELECT f_creer_proprietaire('kfrottier', 'kfrottiermdp', 'FROTTIER', 'Kylie', '1996-08-04', 'kfrottier@lesabeilles.fr', null); --test

/* Créer un profil moniteur (Propriétaire) */
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
	IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = $1) THEN
		EXECUTE FORMAT('REASSIGN OWNED BY %I TO moniteurs_abeilles', nomUtil);
	END IF;
	EXECUTE FORMAT('DROP USER IF EXISTS %I', nomUtil);
    EXECUTE FORMAT('CREATE USER "%I" WITH ENCRYPTED PASSWORD ''%s''', nomUtil, mdp);
	EXECUTE FORMAT('GRANT moniteurs_abeilles TO %I', nomUtil);
	RETURN nouvIdMoniteur;
END;
$BODY$
LANGUAGE PlpgSQL;
SELECT f_creer_moniteur('batman', 'batmanmdp', 'WAYNE', 'Bruce', '1996-08-04', 'bwayne@batman.com', null); --test

/* Supprimer un employé (Propriétaire) */
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
	EXECUTE FORMAT('DROP OWNED BY %I', nomUtil);
	EXECUTE FORMAT('DROP USER IF EXISTS %I', nomUtil);
END;
$BODY$
LANGUAGE PlpgSQL;
--CALL p_supprimer_employe('Propriétaire', 'FROTTIER', 'Kylie', '1996-08-04', 'kfrottier@lesabeilles.fr', null); --test
--CALL p_supprimer_employe('Moniteur', 'WAYNE', 'Bruce', '1996-08-04', 'bwayne@batman.com', null) --test
--SELECT * FROM CompteEmploye where typeemploye = 'Propriétaire';
--SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'kfrottier';

/* 11 - Créer diplôme */
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

/* 12 - Créer permis bateau */
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

/* 13 - Trouver noms moniteurs */
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

/* 14 Récupérer rôle utilisateur */
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

DROP PROCEDURE IF EXISTS modifier_employe;
CREATE OR REPLACE PROCEDURE modifier_employe(idEmp INT, nomEmploye VARCHAR, prenomEmploye VARCHAR, dateNaissanceEmploye DATE, mailEmploye VARCHAR, telEmploye VARCHAR) as $BODY$
BEGIN
	UPDATE compteemploye 
	SET nom = $2, prenom = $3, datenaissance = $4, mail = $5, numtelephone = $6
	WHERE idcompte = $1;
END;
$BODY$
LANGUAGE PlpgSQL;

/* 14 Consulter la liste des inscrits à un cours*/

CREATE OR REPLACE FUNCTION listeInscritsCoursVoile(DateCours timestamp)
RETURNS TABLE (
	idClient integer,
	NomClient varchar(30),
	PrenomClient varchar(30)	
) AS $$
BEGIN 
    RETURN QUERY
    SELECT
		c.idCours,
        Cl.nom,
        Cl.prenom
    FROM
        Coursplanchevoile c
		
	join participation p on c.idcours = p.idcours
	
	join client cl on p.idclient = cl.idclient
	
    WHERE c.dateheure = datecours;
END;
$$ LANGUAGE plpgsql;

/* 15 - Consulter le planning des cours de voile */

CREATE OR REPLACE FUNCTION consulter_cours_voile()
RETURNS TABLE (
	IdCours int,
    DateHeure timestamp,
    Niveau EStatutclient,
    NomMoniteur text,
	EtatCours Varchar(30)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
		cpv.IdCours,
        cpv.DateHeure,
        cpv.Niveau,
        ce.Nom || ' ' || ce.Prenom AS NomMoniteur,
		cpv.etatcours::varchar
    FROM
        CoursPlancheVoile cpv
    JOIN
        CompteEmploye ce ON cpv.IdCompte = ce.IdCompte
	ORDER BY cpv.IdCours;
END;
$$ LANGUAGE plpgsql;

/* 16 - Modifier le profil d'un client */

CREATE OR REPLACE PROCEDURE modifier_profil_client(
    IN client_id INT,
    IN nouveau_nom VARCHAR(30),
    IN nouveau_prenom VARCHAR(30),
    IN nouvelle_date_naissance DATE,
    IN nouveau_mail VARCHAR(50),
    IN nouveau_camping ECamping,
    IN nouveau_statut EStatutClient,
    IN nouvelle_taille FLOAT,
    IN nouveau_poids FLOAT,
    IN nouvelle_preference_contact EPreferenceContact
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- si le client n'existe pas
    IF NOT EXISTS (SELECT 1 FROM Client WHERE IdPersonne = client_id) THEN
        RAISE EXCEPTION 'Le client avec l''ID % n''existe pas.', client_id;
    END IF;

    -- sinon alors mise à jour du profil client
    UPDATE Client
    SET
        Nom = nouveau_nom,
        Prenom = nouveau_prenom,
        DateNaissance = nouvelle_date_naissance,
        Mail = nouveau_mail,
        Camping = nouveau_camping,
        Statut = nouveau_statut,
        Taille = nouvelle_taille,
        Poids = nouveau_poids,
        PreferenceContact = nouvelle_preference_contact
    WHERE IdPersonne = client_id;

    RAISE NOTICE 'Le profil du client avec l''ID % a été modifié.', client_id;
END;
$$;

/* 17 - Mettre un matériel "Hors service" */

CREATE OR REPLACE PROCEDURE mettre_hors_service(IN materiel_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- si l'équipement n'existe pas
    IF NOT EXISTS (SELECT 1 FROM Materiel WHERE NumSerie = materiel_id) THEN
        RAISE EXCEPTION 'L''équipement avec le numéro de série % n''existe pas.', materiel_id;
    END IF;

	--sinon
    UPDATE Materiel
    SET Statut = 'Hors service'
    WHERE NumSerie = materiel_id;

    RAISE NOTICE 'L''équipement avec le numéro de série % a été mis hors service.', materiel_id;
END;
$$;

/* 18- Changer l'état d'un matériel */
CREATE OR REPLACE PROCEDURE changer_etat_materiel(IN materiel_id INT,IN type_materiel VARCHAR(30),IN nouvel_etat EStatutMateriel)
LANGUAGE plpgsql
AS $$
BEGIN
    CASE type_materiel
        WHEN 'Pedalo' THEN
            UPDATE Pedalo SET Statut = nouvel_etat WHERE IdPedalo = materiel_id;
        WHEN 'StandUpPaddle' THEN
            UPDATE StandUpPaddle SET Statut = nouvel_etat WHERE IdStandUpPaddle = materiel_id;
        WHEN 'Catamaran' THEN
            UPDATE Catamaran SET Statut = nouvel_etat WHERE IdCatamaran = materiel_id;
        WHEN 'PlancheAVoile' THEN
            UPDATE PlancheAVoile SET Statut = nouvel_etat WHERE IdPlancheVoile = materiel_id;
        WHEN 'Voile' THEN
            UPDATE Voile SET Statut = nouvel_etat WHERE IdPlancheVoile = materiel_id;
        WHEN 'Flotteur' THEN
            UPDATE Flotteur SET Statut = nouvel_etat WHERE IdPlancheVoile = materiel_id;
        WHEN 'PiedDeMat' THEN
            UPDATE PiedDeMat SET Statut = nouvel_etat WHERE IdPlancheVoile = materiel_id;
        ELSE
            RAISE EXCEPTION 'type de matériel non pris en charge : %', type_materiel;
    END CASE;

    RAISE NOTICE 'L''état du matériel avec l''ID % a été changé en %.', materiel_id, nouvel_etat;
END;
$$;

/* 19- Archiver une location */
CREATE OR REPLACE PROCEDURE ArchiverLocations()
LANGUAGE plpgsql
AS $$
BEGIN
--dans la version du projet amélioré :
--pour chaque location terminée dans la table Location,
-- création d'une ligne dans la table LocationArchive 
    INSERT INTO LocationArchive
    SELECT *
    FROM Location
    WHERE EtatLocation = 'Terminée';
END;
$$;

/* 20- Inscription d'un client à un cours de planche à voile */
DROP FUNCTION IF EXISTS inscrireclientaucours(INT, INT);

-- Créer la nouvelle fonction
CREATE OR REPLACE FUNCTION inscrireclientaucours(p_idcours INT, p_idclient INT)
RETURNS VOID
AS $$
BEGIN
    -- Vérifier si le client n'est pas déjà inscrit à ce cours
    IF NOT EXISTS (SELECT 1 FROM participation WHERE idcours = p_idcours AND idclient = p_idclient) THEN
        -- Insérer l'inscription
        INSERT INTO participation(idcours, idclient)
        VALUES (p_idclient,p_idcours);
    END IF;
END;
$$ LANGUAGE plpgsql;

/* 21- Créer un profil de garçon de plage */

CREATE OR REPLACE PROCEDURE CreerProfilGarconDePlage(
    nom_personne VARCHAR(30),
    prenom_personne VARCHAR(30),
    date_naissance_personne DATE,
    mail_personne VARCHAR(50),
    telephone_personne VARCHAR(15)
)
AS $$
BEGIN
    INSERT INTO Personne (Nom, Prenom, DateNaissance, Mail, Telephone)
    VALUES (nom_personne, prenom_personne, date_naissance_personne, mail_personne, telephone_personne);

    INSERT INTO GarconDePlage DEFAULT VALUES;
END;
$$ LANGUAGE plpgsql;


/* 22 - Annuler un cours */
--SELECT * FROM CoursPlancheVoile;
--SELECT enum_range(null::EEtatCours); --"{Prévu,"En cours",Réalisé,Annulé}"
DROP FUNCTION IF EXISTS f_annuler_cours;
CREATE OR REPLACE FUNCTION f_annuler_cours(idCoursAnnule int)
	RETURNS int
	AS $$
DECLARE idCoursModif Varchar;
BEGIN
	UPDATE CoursPlancheVoile
		SET etatCours = 'Annulé'
		WHERE idCours = idCoursAnnule
		RETURNING idCours INTO idCoursModif;
	RETURN idCoursModif;
END;
$$
LANGUAGE PlpgSQL;
--SELECT f_annuler_cours(36);

/* 23 - Consulter les cours dans lesquels le client peut s'inscrire */
DROP FUNCTION IF EXISTS consulter_cours_voile_pour_inscription();
CREATE OR REPLACE FUNCTION consulter_cours_voile_pour_inscription()
RETURNS TABLE (
    idCours INT,
    dateheure TIMESTAMP,
    niveau EStatutClient,
    nommoniteur text,
    nbplacesrestantes bigint
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        cpv.IdCours,
        cpv.dateheure,
        cpv.niveau,
        c.nom || ' ' || c.prenom AS nommoniteur,
        15 - COUNT(p.IdCours) AS nbplacesrestantes
    FROM
        CoursPlancheVoile cpv
    LEFT JOIN
        CompteEmploye c ON cpv.IdCompte = c.IdCompte
    LEFT JOIN
        Participation p ON cpv.IdCours = p.IdCours
    WHERE
        cpv.EtatCours = 'Prévu'
    GROUP BY
        cpv.IdCours,
        cpv.dateheure,
        cpv.niveau,
        c.nom,
        c.prenom
    ORDER BY
        cpv.dateheure;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS f_rechercher_catamaran;
CREATE OR REPLACE FUNCTION f_rechercher_catamaran(dateLoc timestamp, dureeLoc interval)
RETURNS TABLE (idMatos INTEGER) AS $$
DECLARE
	minTime timestamp;
	maxTime timestamp;
BEGIN

	SELECT INTO minTime dateLoc - dureeLoc;
	SELECT INTO maxTime dateLoc + dureeLoc;

	RETURN QUERY SELECT idcatamaran as idMatos
					  FROM catamaran t_mat WHERE statut = 'Fonctionnel' AND NOT EXISTS(
							SELECT idcatamaran FROM location t_loc
							WHERE t_loc.idcatamaran = t_mat.idcatamaran
							AND t_loc.etatlocation = 'En cours'
							AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
								OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
								OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
								OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
							);
END;
$$ Language PlpgSQL;

DROP FUNCTION IF EXISTS f_rechercher_pedalo;
CREATE OR REPLACE FUNCTION f_rechercher_pedalo(dateLoc timestamp, dureeLoc interval)
RETURNS TABLE (idMatos INTEGER) AS $$
DECLARE
	minTime timestamp;
	maxTime timestamp;
BEGIN

	SELECT INTO minTime dateLoc - dureeLoc;
	SELECT INTO maxTime dateLoc + dureeLoc;
/* 23 - Modifier le profil d'un client */
DROP PROCEDURE IF EXISTS modifier_profil_client;
CREATE OR REPLACE PROCEDURE modifier_profil_client(
    idCli INT,
    nomClient VARCHAR,
    prenomClient VARCHAR,
    dateNaissanceClient DATE,
    mailClient VARCHAR,
    telClient VARCHAR,
    prefContactClient EPreferenceContact,
    campingClient ECamping,
    tailleClient INT,
    poidsClient INT,
    statutClient EStatutClient
) AS $BODY$
BEGIN
    UPDATE Client
    SET
        nom = nomClient,
        prenom = prenomClient,
        datenaissance = dateNaissanceClient,
        mail = mailClient,
        numtelephone = telClient,
        preferencecontact = prefContactClient,
        camping = campingClient,
        taille = tailleClient,
        poids = poidsClient,
        statut = statutClient
    WHERE idclient = idCli;
END;
$BODY$
LANGUAGE PlpgSQL;

	RETURN QUERY SELECT idpedalo as idMatos
					  FROM pedalo t_mat WHERE statut = 'Fonctionnel' AND NOT EXISTS(
							SELECT idpedalo FROM location t_loc
							WHERE t_loc.idpedalo = t_mat.idpedalo
							AND t_loc.etatlocation = 'En cours'
							AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
								OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
								OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
								OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
							);
END;
$$ Language PlpgSQL;


DROP FUNCTION IF EXISTS f_rechercher_standuppaddle(dateLoc TIMESTAMP, dureeLoc INTERVAL);

CREATE OR REPLACE FUNCTION f_rechercher_standuppaddle(dateLoc TIMESTAMP, dureeLoc INTERVAL)
RETURNS TABLE (
    idMatos INTEGER,
    nomMateriel VARCHAR(30),
    idPrixMatos INTEGER,
    prixHeure FLOAT,
    prixHeureSupp FLOAT,
    prixDemiHeure FLOAT,
    statut EStatutMateriel
) AS $$
DECLARE
    minTime TIMESTAMP;
    maxTime TIMESTAMP;
BEGIN
    SELECT INTO minTime dateLoc - dureeLoc;
    SELECT INTO maxTime dateLoc + dureeLoc;

    RETURN QUERY SELECT DISTINCT
        s.idstanduppaddle as idMatos,
        m.nomMateriel,
        s.idPrixMateriel as idPrixMatos,
        m.prixHeure,
        m.prixHeureSupp,
        m.prixDemiHeure,
        s.statut
    FROM
        StandUpPaddle s
    JOIN
        PrixMateriel m ON s.idPrixMateriel = m.idPrixMateriel
    LEFT JOIN
        v_stock_materiel_raw c ON c.IdMatos = s.idStandUpPaddle
    WHERE
        s.statut = 'Fonctionnel'
        AND NOT EXISTS (
            SELECT 1
            FROM
                Location t_loc
            WHERE
                t_loc.idStandUpPaddle = s.idStandUpPaddle
                AND t_loc.etatlocation = 'En cours'
                AND (
                    (t_loc.dateheurelocation BETWEEN minTime AND maxTime)
                    OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
                    OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
                    OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
                )
        );
END;
$$ LANGUAGE PLPGSQL;

DROP FUNCTION IF EXISTS f_rechercher_planchevoile;
CREATE OR REPLACE FUNCTION f_rechercher_planchevoile(dateLoc timestamp, dureeLoc interval, capaciteFlot ecapaciteflotteur, tailVoile etaillevoile)
RETURNS TABLE (idFloteur INTEGER, idPiedMat INTEGER, idDeVoile INTEGER) AS $$
DECLARE
	minTime timestamp;
	maxTime timestamp;
	idFloteur INTEGER;
	idPiedMat INTEGER;
	idDeVoile INTEGER;
BEGIN

	SELECT INTO minTime dateLoc - dureeLoc;
	SELECT INTO maxTime dateLoc + dureeLoc;

	SELECT INTO idFloteur idflotteur FROM flotteur t_flot
	WHERE statut = 'Fonctionnel'
	AND capacite = capaciteFlot
	AND NOT EXISTS(
		SELECT idplanchevoile FROM coursplanchevoile t_cours LEFT JOIN reservation t_res ON t_cours.idcours = t_res.idcours
			WHERE t_res.idplanchevoile = t_flot.idplanchevoile
			AND t_cours.etatcours = 'Prévu'
			AND ((t_cours.dateheure BETWEEN minTime AND maxTime)
				OR ((t_cours.dateheure + interval '2 hours' BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours'))
				OR (maxTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours')))
				))
	AND NOT EXISTS(
		SELECT idplanchevoile FROM location t_loc
			WHERE t_loc.idplanchevoile = t_flot.idplanchevoile
			AND t_loc.etatlocation = 'En cours'
			AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
				OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
				OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
	)
	LIMIT 1;

	SELECT INTO idPiedMat idpieddemat FROM pieddemat t_mat
	WHERE statut = 'Fonctionnel'
	AND NOT EXISTS(
		SELECT idplanchevoile FROM coursplanchevoile t_cours LEFT JOIN reservation t_res ON t_cours.idcours = t_res.idcours
			WHERE t_res.idplanchevoile = t_mat.idplanchevoile
			AND t_cours.etatcours = 'Prévu'
			AND ((t_cours.dateheure BETWEEN minTime AND maxTime)
				OR ((t_cours.dateheure + interval '2 hours' BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours'))
				OR (maxTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours')))
				))
	AND NOT EXISTS(
		SELECT idplanchevoile FROM location t_loc
			WHERE t_loc.idplanchevoile = t_mat.idplanchevoile
			AND t_loc.etatlocation = 'En cours'
			AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
				OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
				OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
	)
	LIMIT 1;

	SELECT INTO idDeVoile idvoile FROM voile t_voi
	WHERE statut = 'Fonctionnel'
	AND NOT EXISTS(
		SELECT idplanchevoile FROM coursplanchevoile t_cours LEFT JOIN reservation t_res ON t_cours.idcours = t_res.idcours
			WHERE t_res.idplanchevoile = t_voi.idplanchevoile
			AND t_cours.etatcours = 'Prévu'
			AND ((t_cours.dateheure BETWEEN minTime AND maxTime)
				OR ((t_cours.dateheure + interval '2 hours' BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours'))
				OR (maxTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours')))
				))
	AND NOT EXISTS(
		SELECT idplanchevoile FROM location t_loc
			WHERE t_loc.idplanchevoile = t_voi.idplanchevoile
			AND t_loc.etatlocation = 'En cours'
			AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
				OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
				OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
	)
	LIMIT 1;


	RETURN QUERY SELECT idFloteur,idPiedMat, idDeVoile;
END;
$$ Language PlpgSQL;
/* 24 - Création d'un garçon de plage */
DROP FUNCTION IF EXISTS creer_garcon;
CREATE OR REPLACE FUNCTION creer_garcon(nomUtilisateur VARCHAR, motdepasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR)
    RETURNS int
    AS $BODY$
DECLARE
    nouvIdGarcon int;
    nomUtil VARCHAR;
    mdp VARCHAR;
BEGIN
    nomUtil := $1;
    mdp := $2;
    INSERT INTO CompteEmploye (NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
		($1, crypt($2, gen_salt('bf')), $3, $4, $5, $6, $7, 'Garçon de plage')
		RETURNING IdCompte INTO nouvIdGarcon;
    --EXECUTE FORMAT('REASSIGN OWNED BY %I TO garcons_de_plage_abeilles', nomUtil);
    EXECUTE FORMAT('DROP USER IF EXISTS %I', nomUtil);
    EXECUTE FORMAT('CREATE USER "%I" WITH ENCRYPTED PASSWORD ''%s''', nomUtil, mdp);
    EXECUTE FORMAT('GRANT garcons_de_plage_abeilles TO %I', nomUtil);
    RETURN nouvIdGarcon;
END;
$BODY$
LANGUAGE PlpgSQL;

DROP PROCEDURE IF EXISTS acheter_forfait;
CREATE OR REPLACE PROCEDURE acheter_forfait(idClientFor INTEGER, idForfait INTEGER, typePaiement EMoyenPaiement, montantForfait FLOAT) AS $BODY$
DECLARE
	now timestamp;
	idPaie INTEGER;
	annee INTEGER;
	enfant BOOLEAN;
	nbseancesForfait INTEGER;
	dateFinForfait DATE;
BEGIN
	now := NOW();
	
	SELECT INTO montantForfait prix FROM typeforfait WHERE idtypeforfait = idForfait;
	SELECT INTO nbseancesForfait nbseances FROM typeforfait WHERE idtypeforfait = idForfait;
	SELECT INTO enfant EXISTS (SELECT * FROM CLIENT WHERE idClient = idClientFor AND idcertificat IS NOT NULL);
	SELECT INTO annee date_part('year', CURRENT_DATE);
	SELECT INTO dateFinForfait to_date(CONCAT(annee, '/10/10'), 'YYYY/MM/DD');
	
	INSERT INTO paiement (dateheure, montant, moyenpaiement) 
	VALUES (now, montantForfait, typePaiement);
	
	SELECT INTO idPaie idpaiement FROM paiement 
	WHERE dateheure = now AND montant = montantForfait AND moyenpaiement = typePaiement;
	
	
	INSERT INTO forfait (datefin, nbseancesrestantes, forfaitenfant, idclient, idtypeforfait, idpaiement)
	VALUES(dateFinForfait, nbseancesForfait, enfant, idClientFor, idForfait, idPaie);
END;
$BODY$
LANGUAGE PlpgSQL;

DROP FUNCTION IF EXISTS possede_remise;
CREATE OR REPLACE FUNCTION possede_remise(idPers INTEGER)
    RETURNS BOOLEAN
    AS $BODY$
BEGIN
    RETURN (SELECT EXISTS(SELECT * FROM client WHERE idCLient = idPers AND camping IS NOT NULL AND camping != 'Autre'));
END;
$BODY$
LANGUAGE PlpgSQL;

DROP PROCEDURE IF EXISTS acheter_forfait;
CREATE OR REPLACE PROCEDURE acheter_forfait(idClientFor INTEGER, idForfait INTEGER, typePaiement EMoyenPaiement, montantForfait FLOAT) AS $BODY$
DECLARE
	now timestamp;
	idPaie INTEGER;
	annee INTEGER;
	enfant BOOLEAN;
	nbseancesForfait INTEGER;
	dateFinForfait DATE;
BEGIN
	now := NOW();
	
	SELECT INTO montantForfait prix FROM typeforfait WHERE idtypeforfait = idForfait;
	SELECT INTO nbseancesForfait nbseances FROM typeforfait WHERE idtypeforfait = idForfait;
	SELECT INTO enfant EXISTS (SELECT * FROM CLIENT WHERE idClient = idClientFor AND idcertificat IS NOT NULL);
	SELECT INTO annee date_part('year', CURRENT_DATE);
	SELECT INTO dateFinForfait to_date(CONCAT(annee, '/10/10'), 'YYYY/MM/DD');
	
	INSERT INTO paiement (dateheure, montant, moyenpaiement) 
	VALUES (now, montantForfait, typePaiement);
	
	SELECT INTO idPaie idpaiement FROM paiement 
	WHERE dateheure = now AND montant = montantForfait AND moyenpaiement = typePaiement;
	
	
	INSERT INTO forfait (datefin, nbseancesrestantes, forfaitenfant, idclient, idtypeforfait, idpaiement)
	VALUES(dateFinForfait, nbseancesForfait, enfant, idClientFor, idForfait, idPaie);
END;
$BODY$
LANGUAGE PlpgSQL;

DROP FUNCTION IF EXISTS calculer_reduction_prix;
CREATE OR REPLACE FUNCTION calculer_reduction_prix(montant FlOAT, idPers INTEGER)
    RETURNS FLOAT
    AS $BODY$
BEGIN
    IF (SELECT EXISTS(SELECT * FROM client WHERE idCLient = idPers AND (camping IS NOT NULL OR camping = 'Autre'))) THEN
        RETURN SELECT montant * 0.9;
    END IF;
    RETURN SELECT montant;
END;
$BODY$
LANGUAGE PlpgSQL;

--enregistrer location
-- Déclencheur pour vérifier la disponibilité du matériel lors de la location
CREATE OR REPLACE FUNCTION check_location_disponibilite()
RETURNS TRIGGER AS $$
DECLARE
    dateDebut Location.DateDebut%TYPE;
    dateFin Location.DateFin%TYPE;
    idMateriel INTEGER;
BEGIN
    -- Extraire les valeurs de date début, date fin et idMateriel depuis la nouvelle ligne
    dateDebut := NEW.DateDebut;
    dateFin := NEW.DateFin;
    idMateriel := NEW.IdMateriel;  -- Remplacez IdMateriel par le vrai nom de la colonne dans votre table

    -- Vérifier si le matériel est déjà en location pour la période spécifiée
    IF EXISTS (
        SELECT 1
        FROM Location
        WHERE IdMateriel = idMateriel
          AND (
            (dateDebut >= DateDebut AND dateDebut < DateFin) OR
            (dateFin > DateDebut AND dateFin <= DateFin) OR
            (dateDebut <= DateDebut AND dateFin >= DateFin)
          )
    ) THEN
        RAISE EXCEPTION 'Le matériel est déjà en location pour cette période.';
    END IF;

    -- Appeler la fonction de vérification du matériel
    RETURN check_location_materiel();
END;
$$ LANGUAGE plpgsql;

-- Déclencheur avant chaque insertion dans la table Location
CREATE TRIGGER check_location_disponibilite_trigger
BEFORE INSERT
ON Location
FOR EACH ROW
EXECUTE FUNCTION check_location_disponibilite();
=======

	SELECT INTO minTime dateLoc - dureeLoc;
	SELECT INTO maxTime dateLoc + dureeLoc;

	SELECT INTO idFloteur idflotteur FROM flotteur t_flot
	WHERE statut = 'Fonctionnel'
	AND capacite = capaciteFlot
	AND NOT EXISTS(
		SELECT idplanchevoile FROM coursplanchevoile t_cours LEFT JOIN reservation t_res ON t_cours.idcours = t_res.idcours
			WHERE t_res.idplanchevoile = t_flot.idplanchevoile
			AND t_cours.etatcours = 'Prévu'
			AND ((t_cours.dateheure BETWEEN minTime AND maxTime)
				OR ((t_cours.dateheure + interval '2 hours' BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours'))
				OR (maxTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours')))
				))
	AND NOT EXISTS(
		SELECT idplanchevoile FROM location t_loc
			WHERE t_loc.idplanchevoile = t_flot.idplanchevoile
			AND t_loc.etatlocation = 'En cours'
			AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
				OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
				OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
	)
	LIMIT 1;

	SELECT INTO idPiedMat idpieddemat FROM pieddemat t_mat
	WHERE statut = 'Fonctionnel'
	AND NOT EXISTS(
		SELECT idplanchevoile FROM coursplanchevoile t_cours LEFT JOIN reservation t_res ON t_cours.idcours = t_res.idcours
			WHERE t_res.idplanchevoile = t_mat.idplanchevoile
			AND t_cours.etatcours = 'Prévu'
			AND ((t_cours.dateheure BETWEEN minTime AND maxTime)
				OR ((t_cours.dateheure + interval '2 hours' BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours'))
				OR (maxTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours')))
				))
	AND NOT EXISTS(
		SELECT idplanchevoile FROM location t_loc
			WHERE t_loc.idplanchevoile = t_mat.idplanchevoile
			AND t_loc.etatlocation = 'En cours'
			AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
				OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
				OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
	)
	LIMIT 1;

	SELECT INTO idDeVoile idvoile FROM voile t_voi
	WHERE statut = 'Fonctionnel'
	AND NOT EXISTS(
		SELECT idplanchevoile FROM coursplanchevoile t_cours LEFT JOIN reservation t_res ON t_cours.idcours = t_res.idcours
			WHERE t_res.idplanchevoile = t_voi.idplanchevoile
			AND t_cours.etatcours = 'Prévu'
			AND ((t_cours.dateheure BETWEEN minTime AND maxTime)
				OR ((t_cours.dateheure + interval '2 hours' BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours'))
				OR (maxTime BETWEEN t_cours.dateheure AND (t_cours.dateheure + interval '2 hours')))
				))
	AND NOT EXISTS(
		SELECT idplanchevoile FROM location t_loc
			WHERE t_loc.idplanchevoile = t_voi.idplanchevoile
			AND t_loc.etatlocation = 'En cours'
			AND ((t_loc.dateheurelocation BETWEEN minTime AND maxTime)
				OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
				OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
				OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree)))
	)
	LIMIT 1;


	RETURN QUERY SELECT idFloteur,idPiedMat, idDeVoile;
END;
$$ Language PlpgSQL;
/* 24 - Création d'un garçon de plage */
DROP FUNCTION IF EXISTS creer_garcon;
CREATE OR REPLACE FUNCTION creer_garcon(nomUtilisateur VARCHAR, motdepasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR)
    RETURNS int
    AS $BODY$
DECLARE
    nouvIdGarcon int;
    nomUtil VARCHAR;
    mdp VARCHAR;
BEGIN
    nomUtil := $1;
    mdp := $2;
    INSERT INTO CompteEmploye (NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
		($1, crypt($2, gen_salt('bf')), $3, $4, $5, $6, $7, 'Garçon de plage')
		RETURNING IdCompte INTO nouvIdGarcon;
    --EXECUTE FORMAT('REASSIGN OWNED BY %I TO garcons_de_plage_abeilles', nomUtil);
    EXECUTE FORMAT('DROP USER IF EXISTS %I', nomUtil);
    EXECUTE FORMAT('CREATE USER "%I" WITH ENCRYPTED PASSWORD ''%s''', nomUtil, mdp);
    EXECUTE FORMAT('GRANT garcons_de_plage_abeilles TO %I', nomUtil);
    RETURN nouvIdGarcon;
END;
$BODY$
LANGUAGE PlpgSQL;

/* 24 - Ajout d'une location */
CREATE OR REPLACE PROCEDURE ajouter_location(
    p_IdClient INT,
    p_IdMatos INT,
    p_TypeMatos VARCHAR(30),
    p_DateHeureLocation TIMESTAMP,
    p_Duree INTERVAL,
    p_PrixHeure FLOAT,
    p_PrixHeureSupp FLOAT,
    p_EtatLocation EEtatLocation,
    p_MoyenPaiement EMoyenPaiement
)
AS $$
DECLARE
    v_IdPaiement INT;
    v_MontantTotal FLOAT;
    v_IdStandUpPaddle INT := NULL;
    v_IdPlancheVoile INT := NULL;
    v_IdPedalo INT := NULL;
    v_IdCatamaran INT := NULL;
BEGIN
    IF p_Duree = '1 hour' THEN
        v_MontantTotal := p_PrixHeure;
    ELSE
        v_MontantTotal := p_PrixHeure + (EXTRACT(HOUR FROM p_Duree) - 1) * p_PrixHeureSupp;
    END IF;

    INSERT INTO Paiement (DateHeure, Montant, MoyenPaiement)
    VALUES (CURRENT_TIMESTAMP, v_MontantTotal, p_MoyenPaiement)
    RETURNING IdPaiement INTO v_IdPaiement;

    CASE p_TypeMatos
        WHEN 'StandUpPaddle' THEN
            v_IdStandUpPaddle := p_IdMatos;
        WHEN 'PlancheAVoile' THEN
            v_IdPlancheVoile := p_IdMatos;
        WHEN 'Pedalo' THEN
            v_IdPedalo := p_IdMatos;
        WHEN 'Catamaran' THEN
            v_IdCatamaran := p_IdMatos;
    END CASE;

    INSERT INTO Location (
        IdClient, IdPaiement, DateHeureLocation, Duree, TarifLocation, EtatLocation,
        IdStandUpPaddle, IdPlancheVoile, IdPedalo, IdCatamaran
    )
    VALUES (
        p_IdClient, v_IdPaiement, p_DateHeureLocation, p_Duree, v_MontantTotal, 'En cours',
        v_IdStandUpPaddle, v_IdPlancheVoile, v_IdPedalo, v_IdCatamaran
    );
END;
$$ LANGUAGE plpgsql;


--rechercher location pedalo
CREATE OR REPLACE FUNCTION f_rechercher_pedalo(dateLoc TIMESTAMP, dureeLoc INTERVAL)
RETURNS TABLE (
    idMatos INTEGER,
    nomMateriel VARCHAR(30),
    idPrixMatos INTEGER,
    prixHeure FLOAT,
    prixHeureSupp FLOAT,
    prixDemiHeure FLOAT,
    statut EStatutMateriel
) AS $$
DECLARE
    minTime TIMESTAMP;
    maxTime TIMESTAMP;
BEGIN
    SELECT INTO minTime dateLoc - dureeLoc;
    SELECT INTO maxTime dateLoc + dureeLoc;

    RETURN QUERY SELECT DISTINCT
        p.idstanduppaddle as idMatos,
        m.nomMateriel,
        p.idPrixMateriel as idPrixMatos,
        m.prixHeure,
        m.prixHeureSupp,
        m.prixDemiHeure,
        p.statut
    FROM
        pedalo p
    JOIN
        PrixMateriel m ON p.idPrixMateriel = m.idPrixMateriel
    LEFT JOIN
        v_stock_materiel_raw c ON c.IdMatos = p.pedalo
    WHERE
        p.statut = 'Fonctionnel'
        AND NOT EXISTS (
            SELECT 1
            FROM
                Location t_loc
            WHERE
                t_loc.idpedalo = p.pedalo
                AND t_loc.etatlocation = 'En cours'
                AND (
                    (t_loc.dateheurelocation BETWEEN minTime AND maxTime)
                    OR ((t_loc.dateheurelocation + t_loc.duree) BETWEEN minTime AND maxTime)
                    OR (minTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
                    OR (maxTime BETWEEN t_loc.dateheurelocation AND (t_loc.dateheurelocation + t_loc.duree))
                )
        );
END;
$$ LANGUAGE PLPGSQL;

DROP FUNCTION IF EXISTS creer_planche_voile;
CREATE OR REPLACE FUNCTION creer_planche_voile(p_idFloteur INTEGER, p_idPiedMat INTEGER, p_idDeVoile INTEGER) 
RETURNS TABLE (idPlanche INTEGER) AS $BODY$
BEGIN

    INSERT INTO plancheavoile (nbplaces, statut, idprixmateriel) VALUES (1, 'Fonctionnel', '2')  RETURNING idplanchevoile INTO idPlanche;
    UPDATE flotteur set idplanchevoile = idPlanche WHERE idFlotteur = p_idFloteur;
    UPDATE pieddemat set idplanchevoile = idPlanche WHERE idpieddemat = p_idPiedMat;
    UPDATE voile set idplanchevoile = idPlanche WHERE idvoile = p_idDeVoile;

    RETURN QUERY SELECT idPlanche;
END;
$BODY$
LANGUAGE PlpgSQL;