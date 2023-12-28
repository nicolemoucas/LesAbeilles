-- Création des types ENUM
DROP TYPE IF EXISTS EMoyenPaiement CASCADE;
CREATE TYPE EMoyenPaiement AS ENUM ('Carte', 'Especes');

DROP TYPE IF EXISTS EETatLocation CASCADE;
CREATE TYPE EETatLocation AS ENUM ('Terminée', 'En cours', 'Annulée');

DROP TYPE IF EXISTS ETailleFlotteur CASCADE;
CREATE TYPE ETailleFlotteur AS ENUM ('150l', '170l', '190l', '205l');

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
IdCertificat int REFERENCES CertificatMedical(IdCertificat)
);


DROP TABLE IF EXISTS EstParentDe CASCADE;
CREATE TABLE EstParentDe(
IdParent int REFERENCES Client(IdClient),
IdEnfant int REFERENCES Client(IdClient),
PRIMARY KEY (IdParent, IdEnfant)
);

DROP TABLE IF EXISTS CertificatMedical CASCADE;
CREATE TABLE CertificatMedical(
IdCertificat SERIAL PRIMARY KEY,
DateDelivrance Date,
DocumentPDF bytea,
IdClient int NOT NULL REFERENCES Client(IdClient) -- FK ajoutée après l'insertion des clients
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
IdClient serial REFERENCES Client(IdClient),
IdTypeForfait serial REFERENCES TypeForfait(IdTypeForfait)
);

DROP TABLE IF EXISTS Paiement CASCADE;
CREATE TABLE Paiement(
IdPaiement SERIAL PRIMARY KEY,
DateHeure time,
Montant float,
MoyenPaiement EMoyenPaiement,
IdForfait serial REFERENCES Forfait(IdForfait)
);

DROP TABLE IF EXISTS Location CASCADE;
CREATE TABLE Location(
IdLocation SERIAL PRIMARY KEY,
DateHeureLocation time,
Duree int,
TarifLocation float,
EtatLocation EEtatLocation,
NumSerie serial REFERENCES Materiel(NumSerie),
IdClient serial REFERENCES Client(IdClient),
IdPaiement serial REFERENCES Paiement(IdPaiement),
IdPedalo serial REFERENCES Pedalo(IdPedalo),
IdStandUpPaddle serial REFERENCES StandUpPaddle(IdStandUpPaddle),
IdCatamaran serial REFERENCES Catamaran(IdCatamaran),
IdPlancheVoile serial REFERENCES PlancheAVoile(IdPlancheVoile)
);

DROP TABLE IF EXISTS CoursPlancheVoile CASCADE;
CREATE TABLE CoursPlancheVoile(
IdCours SERIAL PRIMARY KEY,
DateHeure time,
Niveau EEtatCours,
IdCompte serial REFERENCES CompteEmploye(IdCompte)
);

-- Création de la table Participation

DROP TABLE IF EXISTS Participation CASCADE;
CREATE TABLE Participation (
IdClient SERIAL REFERENCES Client(IdClient),
IdCours SERIAL REFERENCES CoursPlancheVoile(IdCours),
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
IdPrixMateriel serial REFERENCES PrixMateriel(IdPrixMateriel)
);

DROP TABLE IF EXISTS StandUpPaddle CASCADE;
CREATE TABLE StandUpPaddle(
IdStandUpPaddle SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces Int,
Statut EStatutMateriel,
Capacite int,
IdPrixMateriel serial REFERENCES PrixMateriel(IdPrixMateriel)
);

DROP TABLE IF EXISTS Catamaran CASCADE;
CREATE TABLE Catamaran(
IdCatamaran SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces Int,
Statut EStatutMateriel,
IdPrixMateriel serial REFERENCES PrixMateriel(IdPrixMateriel));

DROP TABLE IF EXISTS PlancheAVoile CASCADE;
CREATE TABLE PlancheAVoile(
IdPlancheVoile SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces Int,
Statut EStatutMateriel,
IdPrixMateriel serial REFERENCES PrixMateriel(IdPrixMateriel),
IdCours SERIAL REFERENCES CoursPlancheVoile(IdCours)
);

DROP TABLE IF EXISTS Flotteur CASCADE;
CREATE TABLE Flotteur(
IdPlancheVoile Serial PRIMARY KEY REFERENCES PlancheAVoile(IdPlancheVoile),
Taille ETailleFlotteur
);

DROP TABLE IF EXISTS PiedDeMat CASCADE;
CREATE TABLE PiedDeMat(
IdPlancheVoile Serial PRIMARY KEY REFERENCES PlancheAVoile(IdPlancheVoile)
);


DROP TABLE IF EXISTS Voile CASCADE;
CREATE TABLE Voile(
IdPlancheVoile Serial PRIMARY KEY REFERENCES PlancheAVoile(IdPlancheVoile)
);


DROP TABLE IF EXISTS Diplome CASCADE;
CREATE TABLE Diplome(
IdDiplome SERIAL PRIMARY KEY,
DateObtention date,
DocumentPDF bytea
);

DROP TABLE IF EXISTS CompteEmploye CASCADE;
CREATE TABLE CompteEmploye (
IdCompte SERIAL PRIMARY KEY,
NomUtilisateur varchar(30),
MotDePasse varchar(20),
Nom Varchar(30),
Prenom Varchar(30),
DateNaissance Date,
Mail Varchar(50),
NumTelephone Varchar(10),
TypeEmploye EtypeEmploye null,
IdDiplome serial REFERENCES Diplome(IdDiplome), -- FK ajoutée après l'insertion des données
IdPermis serial REFERENCES PermisBateau(IdPermis)
);

DROP TABLE IF EXISTS PermisBateau CASCADE;
CREATE TABLE PermisBateau(
IdPermis SERIAL PRIMARY KEY,
DocumentPDF bytea,
DateObtention Date
);

DROP TABLE IF EXISTS Reservation CASCADE;
CREATE TABLE Reservation (
IdCours SERIAL REFERENCES CoursPlancheVoile(IdCours),
IdPlancheVoile SERIAL REFERENCES PlancheAVoile(IdPlancheVoile),
PRIMARY KEY (IdCours, IdPlancheVoile)
);
