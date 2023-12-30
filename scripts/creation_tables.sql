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
CREATE TYPE EStatutMateriel AS ENUM ('Reçu', 'Fonctionnel', 'Hors service', 'Mis au rebut');

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
Taille float,
Poids float,
PreferenceContact EPreferenceContact,
IdCertificat int
);

DROP TABLE IF EXISTS EstParentDe CASCADE;
CREATE TABLE EstParentDe(
IdParent int,
IdEnfant int,
PRIMARY KEY (IdParent, IdEnfant)
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
Disponible Boolean,
NbPlaces Int,
Statut EStatutMateriel,
IdPrixMateriel int
);

DROP TABLE IF EXISTS StandUpPaddle CASCADE;
CREATE TABLE StandUpPaddle(
IdStandUpPaddle SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces int,
Statut EStatutMateriel,
Capacite Varchar(5),
IdPrixMateriel int
);

DROP TABLE IF EXISTS Catamaran CASCADE;
CREATE TABLE Catamaran(
IdCatamaran SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces int,
Statut EStatutMateriel,
IdPrixMateriel int
);

DROP TABLE IF EXISTS PlancheAVoile CASCADE;
CREATE TABLE PlancheAVoile(
IdPlancheVoile SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces int,
Statut EStatutMateriel,
IdPrixMateriel int
);

DROP TABLE IF EXISTS Flotteur CASCADE;
CREATE TABLE Flotteur(
IdFlotteur Serial,
IdPlancheVoile int,
Capacite ECapaciteFlotteur,
CONSTRAINT PK_Flotteur PRIMARY KEY (IdFlotteur, IdPlancheVoile)
);

DROP TABLE IF EXISTS PiedDeMat CASCADE;
CREATE TABLE PiedDeMat(
IdPiedDeMat Serial,
IdPlancheVoile int,
CONSTRAINT PK_PiedDeMat PRIMARY KEY (IdPiedDeMat, IdPlancheVoile)
);

DROP TABLE IF EXISTS Voile CASCADE;
CREATE TABLE Voile(
IdVoile Serial,
IdPlancheVoile int,
Taille ETailleVoile,
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
