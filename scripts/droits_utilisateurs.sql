--SELECT groname FROM pg_group WHERE groname = 'proprietaires_abeilles' OR groname = 'moniteurs_abeilles' OR groname = 'garcons_de_plage_abeilles';
/*SELECT usename, rolname
FROM pg_user
JOIN pg_auth_members ON (pg_user.usesysid = pg_auth_members.member)
JOIN pg_roles ON (pg_roles.oid = pg_auth_members.roleid)
WHERE pg_roles.rolname = 'proprietaires_abeilles';*/ --moniteurs

-- Propriétaires
DROP GROUP IF EXISTS proprietaires_abeilles;
CREATE GROUP proprietaires_abeilles;

GRANT SELECT ON Client TO proprietaires_abeilles;
GRANT INSERT ON Client TO proprietaires_abeilles;
GRANT DELETE ON Client TO proprietaires_abeilles;
GRANT SELECT ON compteemploye to proprietaires_abeilles;
GRANT SELECT, INSERT ON coursplanchevoile TO proprietaires_abeilles;

GRANT USAGE ON TYPE ECamping TO proprietaires_abeilles;
GRANT USAGE ON TYPE EPreferenceContact TO proprietaires_abeilles;
GRANT USAGE ON TYPE EStatutClient TO proprietaires_abeilles;

GRANT EXECUTE ON FUNCTION recherche_client(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE) TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION fetch_nom_moniteur() TO proprietaires_abeilles;
GRANT EXECUTE ON FUNCTION verification_moniteur_disponible(idMoniteur INT, dateHeureCours TIMESTAMP) TO proprietaires_abeilles;

GRANT EXECUTE ON PROCEDURE creer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR,
camping ECamping, statut EStatutClient, poids FLOAT, taille FLOAT, preferenceContact EPreferenceContact) TO proprietaires_abeilles;
GRANT EXECUTE ON PROCEDURE supprimer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE) TO proprietaires_abeilles;
GRANT EXECUTE ON PROCEDURE creer_cours(horaireCours TIMESTAMP, nivCours EStatutClient, idMoniteur INT) TO proprietaires_abeilles;

GRANT USAGE ON SEQUENCE client_idclient_seq TO proprietaires_abeilles;
GRANT USAGE ON SEQUENCE coursplanchevoile_idcours_seq TO proprietaires_abeilles;

DROP USER IF EXISTS lfrottier;
CREATE USER lfrottier WITH ENCRYPTED PASSWORD 'lfrottier';
DROP USER IF EXISTS jfrottier;
CREATE USER jfrottier WITH ENCRYPTED PASSWORD 'jfrottier';

GRANT proprietaires_abeilles TO lfrottier;
GRANT proprietaires_abeilles TO jfrottier;

-- Moniteurs
DROP GROUP IF EXISTS moniteurs_abeilles;
CREATE GROUP moniteurs_abeilles;

GRANT SELECT ON Client TO moniteurs_abeilles;
GRANT INSERT ON Client TO moniteurs_abeilles;

GRANT USAGE ON TYPE ECamping TO moniteurs_abeilles;
GRANT USAGE ON TYPE EPreferenceContact TO moniteurs_abeilles;
GRANT USAGE ON TYPE EStatutClient TO moniteurs_abeilles;

GRANT EXECUTE ON FUNCTION recherche_client(nomClient VARCHAR, prenomClient VARCHAR, dateNaissanceClient DATE) TO moniteurs_abeilles;
GRANT EXECUTE ON PROCEDURE creer_client(nom VARCHAR, prenom VARCHAR, dateNaissance DATE, mail VARCHAR, numTelephone VARCHAR,
camping ECamping, statut EStatutClient, poids FLOAT, taille FLOAT, preferenceContact EPreferenceContact) TO moniteurs_abeilles;
GRANT USAGE ON SEQUENCE client_idclient_seq TO moniteurs_abeilles;

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
DROP GROUP IF EXISTS garcons_de_plage_abeilles;
CREATE GROUP garcons_de_plage_abeilles;

DROP USER IF EXISTS dlee;
CREATE USER dlee WITH ENCRYPTED PASSWORD 'dlee';
DROP USER IF EXISTS lpetit;
CREATE USER lpetit WITH ENCRYPTED PASSWORD 'lpetit';

GRANT garcons_de_plage_abeilles TO dlee;
GRANT garcons_de_plage_abeilles TO lpetit;

-- Connexion user
DROP USER IF EXISTS connexion_user;
CREATE USER connexion_user WITH ENCRYPTED PASSWORD 'connexion';

GRANT SELECT ON informations_connexion TO connexion_user; 
GRANT EXECUTE ON FUNCTION verification_utilisateur(identifiant VARCHAR, mdp VARCHAR) TO connexion_user;
GRANT EXECUTE ON FUNCTION fetch_role_utilisateur(identifiant VARCHAR, mdp VARCHAR) TO connexion_user;