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

DROP TYPE IF EXISTS ERoleEmploye CASCADE
CREATE TYPE ERoleEmploye AS ENUM ('Propriétaire', 'Moniteur', 'Garçon de Plage');

DROP TABLE IF EXISTS Personne CASCADE;
CREATE TABLE Personne(
IdPersonne SERIAL PRIMARY KEY,
Nom Varchar(30),
Prenom Varchar(30),
DateNaissance Date,
Mail Varchar(50),
NumTelephone Varchar(10)
);

DROP TABLE IF EXISTS Moniteur CASCADE;
CREATE TABLE Moniteur() INHERITS (Personne);

DROP TABLE IF EXISTS Client CASCADE;
CREATE TABLE Client(
Camping ECamping,
Statut EStatutClient,
Taille float,
Poids float,
PreferenceContact EPreferenceContact,
IdCertificat int -- FK ajoutée après l'insertion des certificats
) INHERITS (Personne);

DROP TABLE IF EXISTS EstParentDe CASCADE;
CREATE TABLE EstParentDe(
IdParent int REFERENCES Personne(IdPersonne),
IdEnfant int REFERENCES Personne(IdPersonne),
PRIMARY KEY (IdParent, IdEnfant));

DROP TABLE IF EXISTS Proprietaire CASCADE;
CREATE TABLE Proprietaire() INHERITS (Personne);

DROP TABLE IF EXISTS GarconDePlage CASCADE;
CREATE TABLE GarconDePlage() INHERITS (Personne);

DROP TABLE IF EXISTS CertificatMedical CASCADE;
CREATE TABLE CertificatMedical(
IdCertificat SERIAL PRIMARY KEY,
DateDelivrance Date,
DocumentPDF bytea,
IdClient int NOT NULL -- FK ajoutée après l'insertion des clients
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
IdPersonne int REFERENCES Personne(IdPersonne),
IdTypeForfait int REFERENCES TypeForfait(IdTypeForfait)
);

DROP TABLE IF EXISTS Paiement CASCADE;
CREATE TABLE Paiement(
IdPaiement SERIAL PRIMARY KEY,
DateHeure time,
Montant float,
MoyenPaiement EMoyenPaiement
);

DROP TABLE IF EXISTS Location CASCADE;
CREATE TABLE Location(
IdLocation SERIAL PRIMARY KEY,
DateHeureLocation time,
Duree int,
TarifLocation float,
EtatLocation EEtatLocation,
NumSerie int REFERENCES Materiel(NumSerie),
IdPersonne int REFERENCES Personne(IdPersonne)
);

DROP TABLE IF EXISTS CoursPlancheVoile CASCADE;
CREATE TABLE CoursPlancheVoile(
IdCours SERIAL PRIMARY KEY,
DateHeure time,
Niveau EEtatCours,
IdPersonne int REFERENCES Personne(IdPersonne)
);

DROP TABLE IF EXISTS PrixMateriel CASCADE;
CREATE TABLE PrixMateriel(
IdPrixMateriel SERIAL PRIMARY KEY,
NomMateriel varchar(30),
PrixHeure float,
PrixHeureSupp float NULL,
PrixDemiHeure float NULL
);

DROP TABLE IF EXISTS Materiel CASCADE;
CREATE TABLE Materiel(
NumSerie SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces Int,
Statut EStatutMateriel,
IdPrixMateriel int REFERENCES PrixMateriel(IdPrixMateriel)
);

DROP TABLE IF EXISTS Pedalo CASCADE;
CREATE TABLE Pedalo() INHERITS (Materiel);

DROP TABLE IF EXISTS StandUpPaddle CASCADE;
CREATE TABLE StandUpPaddle(
Capacite int
) INHERITS (Materiel);

DROP TABLE IF EXISTS Catamaran CASCADE;
CREATE TABLE Catamaran() INHERITS (Materiel);

DROP TABLE IF EXISTS PlancheAVoile CASCADE;
CREATE TABLE PlancheAVoile(
IdCours int REFERENCES CoursPlancheVoile(IdCours) 
) INHERITS (Materiel);

DROP TABLE IF EXISTS Catamaran CASCADE;
CREATE TABLE Catamaran(
Taille ETailleVoile) INHERITS (PlancheAVoile);

DROP TABLE IF EXISTS Flotteur CASCADE;
CREATE TABLE Flotteur(
Taille ETailleFlotteur) INHERITS (PlancheAVoile);

DROP TABLE IF EXISTS PiedDeMat CASCADE;
CREATE TABLE PiedDeMat() INHERITS (PlancheAVoile);

DROP TABLE IF EXISTS Diplome CASCADE;
CREATE TABLE Diplome(
IdDiplome SERIAL PRIMARY KEY,
DateObtention date,
DocumentPDF bytea
);

DROP TABLE IF EXISTS Compte CASCADE;
CREATE TABLE Compte (
IdCompte SERIAL PRIMARY KEY,
NomUtilisateur varchar(30),
MotDePasse varchar(20),
IdPersonne int -- FK ajoutée après l'insertion des données
);

DROP TABLE IF EXISTS PermisBateau CASCADE;
CREATE TABLE PermisBateau(
IdPermis SERIAL PRIMARY KEY,
DocumentPDF bytea,
DateObtention Date,
IdPersonne int REFERENCES Personne(IdPersonne)
);
