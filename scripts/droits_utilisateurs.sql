--SELECT groname FROM pg_group WHERE groname = 'proprietaires_abeilles' OR groname = 'moniteurs_abeilles' OR groname = 'garcons_de_plage_abeilles';
/*
SELECT *
FROM pg_user
JOIN pg_auth_members ON (pg_user.usesysid = pg_auth_members.member)
JOIN pg_roles ON (pg_roles.oid = pg_auth_members.roleid)
WHERE pg_roles.rolname = 'proprietaires_abeilles';
*/ --  moniteurs_abeilles
SELECT usename AS role_name, 
CASE 
    WHEN usesuper AND usecreatedb THEN CAST ('superuser, create database' AS pg_catalog.text) 
    WHEN usesuper THEN CAST ('superuser' AS pg_catalog.text) 
    WHEN usecreatedb THEN CAST ('create database' AS pg_catalog.text) 
    ELSE CAST ('' AS pg_catalog.text) 
END AS role_attributes 
FROM pg_catalog.pg_user 
ORDER BY role_name desc;


-- Propriétaires
DROP OWNED BY proprietaires_abeilles;
DROP GROUP IF EXISTS proprietaires_abeilles;
CREATE GROUP proprietaires_abeilles;

GRANT super_role TO proprietaires_abeilles;

GRANT SELECT, DELETE, INSERT ON Client TO proprietaires_abeilles;
GRANT SELECT, DELETE, INSERT ON CompteEmploye TO proprietaires_abeilles;
GRANT SELECT, DELETE, INSERT ON PermisBateau TO proprietaires_abeilles;
GRANT SELECT, DELETE, INSERT ON Diplome TO proprietaires_abeilles;
GRANT SELECT, INSERT ON coursplanchevoile TO proprietaires_abeilles;
GRANT SELECT, INSERT ON ArchiveMateriel TO proprietaires_abeilles;
GRANT SELECT ON v_stock_materiel_raw TO proprietaires_abeilles;
GRANT SELECT ON v_stock_materiel TO proprietaires_abeilles;
GRANT SELECT ON v_Planche_a_voile_compo_raw TO proprietaires_abeilles;
GRANT SELECT ON v_Planche_a_voile_compo TO proprietaires_abeilles;
GRANT SELECT ON v_Planche_a_voile TO proprietaires_abeilles;
GRANT UPDATE ON CompteEmploye TO proprietaires_abeilles;
GRANT SELECT, INSERT ON Catamaran TO proprietaires_abeilles;
GRANT SELECT, INSERT ON Flotteur TO proprietaires_abeilles;
GRANT SELECT, INSERT ON Pedalo TO proprietaires_abeilles;
GRANT SELECT, INSERT ON PiedDeMat TO proprietaires_abeilles;
GRANT SELECT, INSERT ON StandUpPaddle TO proprietaires_abeilles;
GRANT SELECT, INSERT ON Voile TO proprietaires_abeilles;
GRANT SELECT ON typeforfait TO proprietaires_abeilles;
GRANT SELECT, INSERT ON paiement TO proprietaires_abeilles;
GRANT SELECT, INSERT ON forfait TO proprietaires_abeilles;
GRANT SELECT, INSERT ON reservation TO proprietaires_abeilles;
GRANT SELECT, INSERT ON location TO proprietaires_abeilles;

GRANT USAGE ON TYPE ECamping TO proprietaires_abeilles;
GRANT USAGE ON TYPE EPreferenceContact TO proprietaires_abeilles;
GRANT USAGE ON TYPE EStatutClient TO proprietaires_abeilles;
GRANT USAGE ON TYPE ETailleVoile TO proprietaires_abeilles;
GRANT USAGE ON TYPE ECapaciteFlotteur TO proprietaires_abeilles;

GRANT EXECUTE ON FUNCTION recherche_client(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION fetch_nom_moniteur() TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION verification_moniteur_disponible(idMoniteur INT, dateHeureCours TIMESTAMP) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION f_rechercher_employe(roleEmploye VARCHAR, nomEmploye VARCHAR, prenomEmploye VARCHAR, dateNaissanceEmploye DATE, mailEmploye VARCHAR, numTelEmploye VARCHAR) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION f_creer_proprietaire(nomUtilisateur VARCHAR, motDePasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION f_creer_moniteur(nomUtilisateur VARCHAR, motdepasse VARCHAR, nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION f_annuler_cours(idCoursSupp int) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION consulter_cours_voile() TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION possede_remise(idPers INTEGER) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION creer_planche_voile(p_idFloteur INTEGER, p_idPiedMat INTEGER, p_idDeVoile INTEGER) TO proprietaires_abeilles;

GRANT EXECUTE ON PROCEDURE creer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR,
camping ECamping, statut EStatutClient, poids FLOAT, taille FLOAT, preferenceContact EPreferenceContact) TO proprietaires_abeilles;
GRANT EXECUTE ON PROCEDURE supprimer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE) TO proprietaires_abeilles;
GRANT EXECUTE ON PROCEDURE creer_cours(horaireCours TIMESTAMP, nivCours EStatutClient, idMoniteur INT) TO proprietaires_abeilles;
GRANT EXECUTE ON PROCEDURE p_supprimer_employe(roleEmploye VARCHAR, nomEmploye VARCHAR, prenomEmploye VARCHAR, dateNaissanceEmploye DATE, mailEmploye VARCHAR, numTelEmploye VARCHAR) TO proprietaires_abeilles;
GRANT EXECUTE ON PROCEDURE modifier_employe(idEmp INT, nomEmploye VARCHAR, prenomEmploye VARCHAR, dateNaissanceEmploye DATE, mailEmploye VARCHAR, telEmploye VARCHAR)  TO proprietaires_abeilles;
GRANT EXECUTE ON PROCEDURE acheter_forfait(idClientFor INTEGER, idForfait INTEGER, typePaiement EMoyenPaiement) TO proprietaires_abeilles;

GRANT USAGE ON SEQUENCE client_idclient_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE coursplanchevoile_idcours_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE compteemploye_idcompte_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE catamaran_idcatamaran_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE flotteur_idflotteur_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE pedalo_idpedalo_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE pieddemat_idpieddemat_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE standuppaddle_idstanduppaddle_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE voile_idvoile_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE paiement_idpaiement_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE  forfait_idforfait_seq TO proprietaires_abeilles;

DROP USER IF EXISTS lfrottier;
CREATE USER lfrottier WITH ENCRYPTED PASSWORD 'lfrottier';
DROP USER IF EXISTS jfrottier;
CREATE USER jfrottier WITH ENCRYPTED PASSWORD 'jfrottier';

GRANT proprietaires_abeilles TO lfrottier WITH ADMIN OPTION;
ALTER ROLE jfrottier WITH SUPERUSER;
GRANT proprietaires_abeilles TO jfrottier WITH ADMIN OPTION;

SELECT * FROM information_schema.role_table_grants WHERE grantee = 'proprietaires_abeilles';

-- Moniteurs
DROP OWNED BY moniteurs_abeilles;
DROP GROUP IF EXISTS moniteurs_abeilles;
CREATE GROUP moniteurs_abeilles;

GRANT SELECT ON Client TO moniteurs_abeilles;
GRANT INSERT ON Client TO moniteurs_abeilles;
GRANT SELECT ON v_stock_materiel_raw TO moniteurs_abeilles;
GRANT SELECT ON v_stock_materiel TO moniteurs_abeilles;
GRANT SELECT ON v_Planche_a_voile_compo_raw TO moniteurs_abeilles;
GRANT SELECT ON v_Planche_a_voile_compo TO moniteurs_abeilles;
GRANT SELECT ON v_Planche_a_voile TO moniteurs_abeilles;
GRANT SELECT, INSERT ON Catamaran TO moniteurs_abeilles;
GRANT SELECT, INSERT ON Flotteur TO moniteurs_abeilles;
GRANT SELECT, INSERT ON Pedalo TO moniteurs_abeilles;
GRANT SELECT, INSERT ON PiedDeMat TO moniteurs_abeilles;
GRANT SELECT, INSERT ON StandUpPaddle TO moniteurs_abeilles;
GRANT SELECT, INSERT ON Voile TO moniteurs_abeilles;
GRANT SELECT ON typeforfait TO moniteurs_abeilles;
GRANT SELECT, INSERT ON paiement TO moniteurs_abeilles;
GRANT SELECT, INSERT ON forfait TO moniteurs_abeilles;
GRANT SELECT, INSERT ON coursplanchevoile TO moniteurs_abeilles;
GRANT SELECT, INSERT ON reservation TO moniteurs_abeilles;
GRANT SELECT, INSERT ON location TO moniteurs_abeilles;

GRANT USAGE ON TYPE ECamping TO moniteurs_abeilles;
GRANT USAGE ON TYPE EPreferenceContact TO moniteurs_abeilles;
GRANT USAGE ON TYPE EStatutClient TO moniteurs_abeilles;
GRANT USAGE ON TYPE ETailleVoile TO moniteurs_abeilles;
GRANT USAGE ON TYPE ECapaciteFlotteur TO moniteurs_abeilles;


GRANT EXECUTE ON FUNCTION recherche_client(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION consulter_cours_voile() TO moniteurs_abeilles;
GRANT EXECUTE ON PROCEDURE creer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR,
camping ECamping, statut EStatutClient, poids FLOAT, taille FLOAT, preferenceContact EPreferenceContact) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION f_rechercher_catamaran(dateLoc timestamp, dureeLoc interval) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION f_rechercher_pedalo(dateLoc timestamp, dureeLoc interval) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION f_rechercher_standuppaddle(dateLoc timestamp, dureeLoc interval) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION f_rechercher_planchevoile(dateLoc timestamp, dureeLoc interval, capaciteFlot ecapaciteflotteur, tailVoile etaillevoile) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION possede_remise(idPers INTEGER) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION creer_planche_voile(p_idFloteur INTEGER, p_idPiedMat INTEGER, p_idDeVoile INTEGER) TO moniteurs_abeilles;
GRANT EXECUTE ON FUNCTION f_rechercher_pedalo(dateLoc TIMESTAMP, dureeLoc INTERVAL) TO moniteurs_abeilles;

GRANT EXECUTE ON PROCEDURE acheter_forfait(idClientFor INTEGER, idForfait INTEGER, typePaiement EMoyenPaiement) TO moniteurs_abeilles;

GRANT USAGE ON SEQUENCE client_idclient_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE catamaran_idcatamaran_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE flotteur_idflotteur_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE pedalo_idpedalo_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE pieddemat_idpieddemat_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE standuppaddle_idstanduppaddle_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE voile_idvoile_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE paiement_idpaiement_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE  forfait_idforfait_seq TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE coursplanchevoile_idcours_seq TO moniteurs_abeilles;


DROP USER IF EXISTS jbond;
CREATE USER jbond WITH ENCRYPTED PASSWORD 'jbond';
DROP USER IF EXISTS ffleuriot;
CREATE USER ffleuriot WITH ENCRYPTED PASSWORD 'ffleuriot';
DROP USER IF EXISTS hmeyer;
CREATE USER hmeyer WITH ENCRYPTED PASSWORD 'hmeyer';

GRANT moniteurs_abeilles TO jbond;
GRANT moniteurs_abeilles TO ffleuriot;
GRANT moniteurs_abeilles TO hmeyer;

-- Garçons de plage
DROP OWNED BY garcons_de_plage_abeilles;
DROP GROUP IF EXISTS garcons_de_plage_abeilles;
CREATE GROUP garcons_de_plage_abeilles;

DROP USER IF EXISTS dlee;
CREATE USER dlee WITH ENCRYPTED PASSWORD 'dlee';
DROP USER IF EXISTS lpetit;
CREATE USER lpetit WITH ENCRYPTED PASSWORD 'lpetit';

GRANT SELECT ON v_stock_materiel_raw TO garcons_de_plage_abeilles;
GRANT SELECT ON v_stock_materiel TO garcons_de_plage_abeilles;
GRANT SELECT ON v_Planche_a_voile_compo_raw TO garcons_de_plage_abeilles;
GRANT SELECT ON v_Planche_a_voile_compo TO garcons_de_plage_abeilles;
GRANT SELECT ON v_Planche_a_voile TO garcons_de_plage_abeilles;
GRANT SELECT, INSERT ON Catamaran TO garcons_de_plage_abeilles;
GRANT SELECT, INSERT ON Flotteur TO garcons_de_plage_abeilles;
GRANT SELECT, INSERT ON Pedalo TO garcons_de_plage_abeilles;
GRANT SELECT, INSERT ON PiedDeMat TO garcons_de_plage_abeilles;
GRANT SELECT, INSERT ON StandUpPaddle TO garcons_de_plage_abeilles;
GRANT SELECT, INSERT ON Voile TO garcons_de_plage_abeilles;

GRANT EXECUTE ON FUNCTION consulter_cours_voile() TO garcons_de_plage_abeilles;

GRANT USAGE ON TYPE ETailleVoile TO garcons_de_plage_abeilles;
GRANT USAGE ON SEQUENCE catamaran_idcatamaran_seq TO garcons_de_plage_abeilles;
GRANT USAGE ON SEQUENCE flotteur_idflotteur_seq TO garcons_de_plage_abeilles;
GRANT USAGE ON SEQUENCE pedalo_idpedalo_seq TO garcons_de_plage_abeilles;
GRANT USAGE ON SEQUENCE pieddemat_idpieddemat_seq TO garcons_de_plage_abeilles;
GRANT USAGE ON SEQUENCE standuppaddle_idstanduppaddle_seq TO garcons_de_plage_abeilles;
GRANT USAGE ON SEQUENCE voile_idvoile_seq TO garcons_de_plage_abeilles;

GRANT garcons_de_plage_abeilles TO dlee;
GRANT garcons_de_plage_abeilles TO lpetit;

-- Connexion user
DROP OWNED BY connexion_user;
DROP USER IF EXISTS connexion_user;
CREATE USER connexion_user WITH ENCRYPTED PASSWORD 'connexion';

GRANT SELECT ON informations_connexion TO connexion_user; 
GRANT EXECUTE ON FUNCTION verification_utilisateur(identifiant VARCHAR, mdp VARCHAR) TO connexion_user;
GRANT EXECUTE ON FUNCTION fetch_role_utilisateur(identifiant VARCHAR, mdp VARCHAR) TO connexion_user;
