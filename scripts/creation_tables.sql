-- FK ajoutées après l'insertion des clients

-- Création des types ENUM
DROP TYPE IF EXISTS EMoyenPaiement CASCADE;
CREATE TYPE EMoyenPaiement AS ENUM ('Carte', 'Espèces');

DROP TYPE IF EXISTS EETatLocation CASCADE;
CREATE TYPE EETatLocation AS ENUM ('Terminée', 'En cours', 'Annulée');

DROP TYPE IF EXISTS ECapaciteFlotteur CASCADE;
CREATE TYPE ECapaciteFlotteur AS ENUM ('150l', '170l', '190l', '205l');

DROP TYPE IF EXISTS ETailleVoile CASCADE;
CREATE TYPE ETailleVoile AS ENUM ('3m2', '4m2', '4.5m2', '4.9m2', '5.4m2');

DROP TYPE IF EXISTS ECamping CASCADE;
CREATE TYPE ECamping AS ENUM ('Jolibois', 'Grand Plage', 'Marande', 'Autre');

DROP TYPE IF EXISTS EPreferenceContact CASCADE;
CREATE TYPE EPreferenceContact AS ENUM ('Mail', 'Téléphone');

DROP TYPE IF EXISTS EStatutClient CASCADE;
CREATE TYPE EStatutClient AS ENUM ('Débutant', 'Sportif');

DROP TYPE IF EXISTS EStatutMateriel CASCADE;
CREATE TYPE EStatutMateriel AS ENUM ('Reçu', 'Fonctionnel', 'Hors service', 'Mis au rebut','En location');

DROP TYPE IF EXISTS EEtatCours CASCADE;
CREATE TYPE EEtatCours AS ENUM ('Prévu', 'En cours', 'Réalisé', 'Annulé');

DROP TYPE IF EXISTS ETypeEmploye CASCADE;
CREATE TYPE ETypeEmploye AS ENUM ('Propriétaire', 'Moniteur', 'Garçon de Plage', 'Annulé');


-- Création des tables
DROP Table IF EXISTS Client CASCADE;
CREATE TABLE Client(
IdClient SERIAL PRIMARY KEY,
Nom Varchar(30),
Prenom Varchar(30),
DateNaissance Date,
Mail Varchar(50),
NumTelephone Varchar(10),
Camping ECamping,
Statut EStatutClient,
Taille int, -- en centimètres
Poids float,
PreferenceContact EPreferenceContact,
IdCertificat int
);

DROP TABLE IF EXISTS CertificatMedical CASCADE;
CREATE TABLE CertificatMedical(
IdCertificat SERIAL PRIMARY KEY,
DateDelivrance Date,
LienDocumentPDF Varchar(120),
IdClient int NOT NULL 
);

DROP TABLE IF EXISTS TypeForfait CASCADE;
CREATE TABLE TypeForfait(
IdTypeForfait SERIAL PRIMARY KEY,
NbSeances int,
Prix int
);

DROP TABLE IF EXISTS Forfait CASCADE;
CREATE TABLE Forfait(
IdForfait SERIAL PRIMARY KEY,
DateFin Date,
NbSeancesRestantes int,
ForfaitEnfant Boolean,
IdClient int,
IdTypeForfait int,
IdPaiement int
);

DROP TABLE IF EXISTS Paiement CASCADE;
CREATE TABLE Paiement(
IdPaiement SERIAL PRIMARY KEY,
DateHeure timestamp,
Montant float,
MoyenPaiement EMoyenPaiement
);

DROP TABLE IF EXISTS Location CASCADE;
CREATE TABLE Location(
IdLocation SERIAL PRIMARY KEY,
DateHeureLocation timestamp,
Duree interval,
TarifLocation float,
EtatLocation EEtatLocation,
IdClient int,
IdPaiement int,
IdStandUpPaddle int,
IdPlancheVoile int,
IdPedalo int,
IdCatamaran int 
);

DROP TABLE IF EXISTS CoursPlancheVoile CASCADE;
CREATE TABLE CoursPlancheVoile(
IdCours SERIAL PRIMARY KEY,
DateHeure timestamp,
Niveau EStatutClient,
EtatCours EEtatCours,
IdCompte int
);

DROP TABLE IF EXISTS Participation CASCADE;
CREATE TABLE Participation (
IdClient int,
IdCours int,
PRIMARY KEY (IdClient, IdCours)
);

DROP TABLE IF EXISTS PrixMateriel CASCADE;
CREATE TABLE PrixMateriel(
IdPrixMateriel SERIAL PRIMARY KEY,
NomMateriel varchar(30),
PrixHeure float,
PrixHeureSupp float NULL,
PrixDemiHeure float NULL
);

DROP TABLE IF EXISTS Pedalo CASCADE;
CREATE TABLE Pedalo(
IdPedalo SERIAL PRIMARY KEY,
NbPlaces Int,
Statut EStatutMateriel,
IdPrixMateriel int
);

DROP TABLE IF EXISTS StandUpPaddle CASCADE;
CREATE TABLE StandUpPaddle(
IdStandUpPaddle SERIAL PRIMARY KEY,
NbPlaces int,
Statut EStatutMateriel,
Capacite Varchar(5),
IdPrixMateriel int
);

DROP TABLE IF EXISTS Catamaran CASCADE;
CREATE TABLE Catamaran(
IdCatamaran SERIAL PRIMARY KEY,
NbPlaces int,
Statut EStatutMateriel,
IdPrixMateriel int
);

DROP TABLE IF EXISTS PlancheAVoile CASCADE;
CREATE TABLE PlancheAVoile(
IdPlancheVoile SERIAL PRIMARY KEY,
NbPlaces int,
Statut EStatutMateriel,
IdPrixMateriel int
);

DROP TABLE IF EXISTS Flotteur CASCADE;
CREATE TABLE Flotteur(
IdFlotteur Serial,
IdPlancheVoile int,
Capacite ECapaciteFlotteur,
Statut EStatutMateriel,
CONSTRAINT PK_Flotteur PRIMARY KEY (IdFlotteur, IdPlancheVoile)
);

DROP TABLE IF EXISTS PiedDeMat CASCADE;
CREATE TABLE PiedDeMat(
IdPiedDeMat Serial,
IdPlancheVoile int,
Statut EStatutMateriel,
CONSTRAINT PK_PiedDeMat PRIMARY KEY (IdPiedDeMat, IdPlancheVoile)
);

DROP TABLE IF EXISTS Voile CASCADE;
CREATE TABLE Voile(
IdVoile Serial,
IdPlancheVoile int,
Taille ETailleVoile,
Statut EStatutMateriel,
CONSTRAINT PK_Voile PRIMARY KEY (IdVoile, IdPlancheVoile)
);

DROP TABLE IF EXISTS Diplome CASCADE;
CREATE TABLE Diplome(
IdDiplome SERIAL PRIMARY KEY,
DateObtention Date,
LienDocumentPDF Varchar(120),
IdMoniteur int
);

DROP TABLE IF EXISTS CompteEmploye CASCADE;
CREATE TABLE CompteEmploye (
IdCompte SERIAL PRIMARY KEY,
NomUtilisateur varchar(30),
MotDePasse varchar(100),
Nom Varchar(30),
Prenom Varchar(30),
DateNaissance Date,
Mail Varchar(50),
NumTelephone Varchar(10),
TypeEmploye EtypeEmploye null,
IdDiplome int,
IdPermis int
);

DROP TABLE IF EXISTS PermisBateau CASCADE;
CREATE TABLE PermisBateau(
IdPermis SERIAL PRIMARY KEY,
DateObtention Date,
LienDocumentPDF Varchar(120),
IdProprietaire int
);

DROP TABLE IF EXISTS Reservation CASCADE;
CREATE TABLE Reservation (
IdCours int,
IdPlancheVoile int,
PRIMARY KEY (IdCours, IdPlancheVoile)
);

DROP VIEW IF EXISTS informations_connexion CASCADE;
CREATE VIEW informations_connexion AS
SELECT nomutilisateur, motdepasse, typeemploye FROM compteemploye;


/* VIEWS STOCK MATÉRIEL */ 
/* View planche à voile */
--SELECT * FROM Flotteur;
--SELECT * FROM PiedDeMat;
--SELECT * FROM PlancheAVoile;
--SELECT * FROM Voile;
--SELECT * FROM PrixMateriel;

DROP VIEW IF EXISTS v_Planche_a_voile_compo_raw CASCADE;
CREATE OR REPLACE VIEW v_Planche_a_voile_compo_raw AS
	SELECT m.idPrixMateriel, pv.idPlancheVoile, m.nomMateriel, m.prixHeure, m.prixHeureSupp,
		pv.nbPlaces, pv.statut AS StatutPlancheAVoile, 
		f.idFlotteur, f.capacite AS capaciteFlotteur, f.statut AS StatutFlotteur, 
		pm.idPiedDeMat, pm.statut AS statutPiedDeMat,
		v.idVoile, v.taille AS tailleVoile, v.statut AS statutVoile
		FROM PlancheAVoile pv
		LEFT JOIN PrixMateriel m ON pv.idPrixMateriel = m.idPrixMateriel
		LEFT JOIN Flotteur f ON pv.idPlancheVoile = f.idPlancheVoile
		LEFT JOIN PiedDeMat pm ON pv.idPlancheVoile = pm.idPlancheVoile
		LEFT JOIN Voile v ON pv.idPlancheVoile = v.idPlancheVoile
	ORDER BY pv.idPlancheVoile;
--SELECT * FROM v_Planche_a_voile_compo_raw;

DROP VIEW IF EXISTS v_Planche_a_voile_compo CASCADE;
CREATE OR REPLACE VIEW v_Planche_a_voile_compo AS
	SELECT pv.idPlancheVoile, m.nomMateriel, m.prixHeure, m.prixHeureSupp,
		pv.nbPlaces, pv.statut AS StatutPlancheAVoile, 
		f.idFlotteur, f.capacite AS capaciteFlotteur, f.statut AS StatutFlotteur, 
		pm.idPiedDeMat, pm.statut AS statutPiedDeMat,
		v.idVoile, v.taille AS tailleVoile, v.statut AS statutVoile
		FROM PlancheAVoile pv
		LEFT JOIN PrixMateriel m ON pv.idPrixMateriel = m.idPrixMateriel
		LEFT JOIN Flotteur f ON pv.idPlancheVoile = f.idPlancheVoile
		LEFT JOIN PiedDeMat pm ON pv.idPlancheVoile = pm.idPlancheVoile
		LEFT JOIN Voile v ON pv.idPlancheVoile = v.idPlancheVoile
	ORDER BY pv.idPlancheVoile;
--SELECT * FROM v_Planche_a_voile_compo;
	
DROP VIEW IF EXISTS v_Planche_a_voile CASCADE;
CREATE OR REPLACE VIEW v_Planche_a_voile AS
	SELECT m.idPrixMateriel, 'Flotteur' AS nomMateriel, m.prixHeure, m.prixHeureSupp, 
			m.prixDemiHeure, f.idFlotteur AS IdMatos, 0 as nbPlaces, f.statut,
			f.Capacite::text, null AS Taille, f.idPlancheVoile
			FROM Flotteur f
			LEFT JOIN PlancheAVoile pv ON pv.IdPlancheVoile = f.IdPlancheVoile
			LEFT JOIN PrixMateriel m ON m.idPrixMateriel = pv.idPrixMateriel
	UNION
	SELECT m.idPrixMateriel, 'Pied de mat' AS nomMateriel, m.prixHeure, m.prixHeureSupp, 
			m.prixDemiHeure, pm.idPiedDeMat AS IdMatos, 0 as nbPlaces, pm.statut, 
			null AS Capacite, null AS Taille, pm.idPlancheVoile
			FROM PiedDeMat pm
			LEFT JOIN PlancheAVoile pv ON pv.IdPlancheVoile = pm.IdPlancheVoile
			LEFT JOIN PrixMateriel m ON m.idPrixMateriel = pv.idPrixMateriel
	UNION
	SELECT m.idPrixMateriel, 'Voile' AS nomMateriel, m.prixHeure, m.prixHeureSupp, 
			m.prixDemiHeure, v.idVoile AS IdMatos, 0 as nbPlaces, v.statut, 
			null AS Capacite, v.taille::text AS Taille, v.idPlancheVoile
			FROM Voile v
			LEFT JOIN PlancheAVoile pv ON pv.IdPlancheVoile = v.IdPlancheVoile
			LEFT JOIN PrixMateriel m ON m.idPrixMateriel = pv.idPrixMateriel
			ORDER BY nomMateriel, idMatos;
--SELECT * FROM v_Planche_a_voile;

/* View stock de matériel */
--c.IdPrixMateriel, NomMateriel, PrixHeure, PrixHeureSupp, PrixDemiHeure, IdMatos, NbPlaces, Statut, Capacite
--SELECT * FROM PrixMateriel;
--SELECT * FROM Catamaran;
--SELECT * FROM Pedalo;
--SELECT * FROM StandUpPaddle;
DROP VIEW IF EXISTS v_stock_materiel_raw CASCADE;
CREATE OR REPLACE VIEW v_stock_materiel_raw AS
	SELECT m.idPrixMateriel, m.nomMateriel, m.prixHeure, m.prixHeureSupp, 
		m.prixDemiHeure, c.idCatamaran AS IdMatos, c.nbPlaces, c.Statut, 
		null AS Capacite, null AS Taille
			FROM Catamaran c
			LEFT JOIN PrixMateriel m ON m.idPrixMateriel = c.idPrixMateriel			
	UNION   	
	SELECT m.idPrixMateriel, m.nomMateriel, m.prixHeure, m.prixHeureSupp, 
			m.prixDemiHeure, p.IdPedalo AS IdMatos, p.nbPlaces, p.Statut, 
			null AS Capacite, null AS Taille
				FROM Pedalo p
				LEFT JOIN PrixMateriel m ON m.idPrixMateriel = p.idPrixMateriel
	UNION 
	SELECT m.idPrixMateriel, m.nomMateriel, m.prixHeure, m.prixHeureSupp, 
			m.prixDemiHeure, s.idStandUpPaddle AS IdMatos, s.nbPlaces, s.statut, 
			s.Capacite, null AS Taille
				FROM StandUpPaddle s
				LEFT JOIN PrixMateriel m ON m.idPrixMateriel = s.idPrixMateriel
	UNION
	SELECT m.idPrixMateriel, pv.nomMateriel, m.prixHeure, m.prixHeureSupp, 
			m.prixDemiHeure, pv.idMatos, pv.nbPlaces, pv.statut, 
			pv.Capacite, pv.taille
				FROM v_Planche_a_voile pv
				LEFT JOIN PlancheAVoile p ON p.IdPlancheVoile = pv.IdPlancheVoile
				LEFT JOIN PrixMateriel m ON m.idPrixMateriel = pv.idPrixMateriel
	ORDER BY NomMateriel, IdMatos;
--SELECT * FROM v_stock_materiel_raw where nommateriel LIKE 'Pied de mat';

DROP VIEW IF EXISTS v_stock_materiel CASCADE;
CREATE OR REPLACE VIEW v_stock_materiel AS
	SELECT idmatos AS "ID", nommateriel AS "Nom matériel", prixHeure AS "Prix heure (€)", prixHeureSupp AS "Prix heure supplémentaire (€)", 
		prixDemiHeure AS "Prix demi-heure (€)", nbPlaces AS "Nombre de places", statut AS "Statut", capacite AS "Capacité",
		taille AS "Taille"
		FROM v_stock_materiel_raw
		ORDER BY nommateriel;
--SELECT * FROM v_stock_materiel;
--SELECT DISTINCT "Nom matériel" AS nomMat FROM v_stock_materiel;

-- view planning
--SELECT * FROM V_stock_materiel_raw;
--SELECT * FROM Client;
--SELECT * FROM v_Planche_a_voile_compo;
--SELECT * FROM Catamaran;

DROP VIEW IF EXISTS v_planning_locations;
CREATE OR REPLACE VIEW v_planning_locations AS
	SELECT l.IdLocation, l.DateHeureLocation, l.Duree, l.TarifLocation, l.EtatLocation, l.IdClient,
		c.Nom AS NomClient, c.Prenom AS PrenomClient, c.Mail AS MailClient, c.numTelephone AS TelephoneClient,
		vc.NomMateriel
		FROM Location l
		INNER JOIN v_stock_materiel_raw vc ON l.IdCatamaran = vc.IdMatos AND vc.nomMateriel = 'Catamaran'
		INNER JOIN Client c ON l.IdClient = c.IdClient
	UNION
	SELECT l.IdLocation, l.DateHeureLocation, l.Duree, l.TarifLocation, l.EtatLocation, l.IdClient,
		c.Nom AS NomClient, c.Prenom AS PrenomClient, c.Mail AS MailClient, c.numTelephone AS TelephoneClient,
		vp.NomMateriel
		FROM Location l
		INNER JOIN v_stock_materiel_raw vp ON l.IdPedalo = vp.IdMatos AND vp.nomMateriel = 'Pédalo'
		INNER JOIN Client c ON l.IdClient = c.IdClient
	UNION
	SELECT l.IdLocation, l.DateHeureLocation, l.Duree, l.TarifLocation, l.EtatLocation, l.IdClient,
		c.Nom AS NomClient, c.Prenom AS PrenomClient, c.Mail AS MailClient, c.numTelephone AS TelephoneClient,
		vs.NomMateriel 
		FROM Location l
		INNER JOIN v_stock_materiel_raw vs ON l.IdStandUpPaddle = vs.IdMatos AND vs.nomMateriel = 'Stand Up Paddle'
		INNER JOIN Client c ON l.IdClient = c.IdClient
	UNION
	SELECT l.IdLocation, l.DateHeureLocation, l.Duree, l.TarifLocation, l.EtatLocation, l.IdClient,
		c.Nom AS NomClient, c.Prenom AS PrenomClient, c.Mail AS MailClient, c.numTelephone AS TelephoneClient,
		vpv.NomMateriel 
		FROM Location l
		INNER JOIN v_Planche_a_voile_compo vpv ON l.IdStandUpPaddle = vpv.IdPlancheVoile
		INNER JOIN Client c ON l.IdClient = c.IdClient;
SELECT * FROM v_planning_locations;