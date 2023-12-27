- - Création des types ENUM
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

- - Création des tables
DROP TYPE IF EXISTS Personne CASCADE;
CREATE TABLE Personne (
IdPersonne SERIAL PRIMARY KEY,
Nom Varchar(30),
Prenom Varchar(30),
DateNaissance Date,
Mail Varchar(50),
NumTelephone Varchar(10),
Role Varchar(20) CHECK (Role IN ('Client', 'Moniteur', 'Proprietaire', 'GarconDePlage'))
)
PARTITION BY LIST (Role);

DROP TYPE IF EXISTS Client CASCADE;
CREATE TABLE Client PARTITION OF Personne FOR VALUES IN ('Client') (
Camping ECamping,
Statut EStatutClient,
Taille float,
Poids float,
PreferenceContact EPreferenceContact,
IdCertificat int REFERENCES CertificatMedical(IdCertificat)
);

DROP TYPE IF EXISTS Moniteur CASCADE;
CREATE TABLE Moniteur PARTITION OF Personne FOR VALUES IN ('Moniteur') (
IdCompte serial REFERENCES Compte(IdCompte)

);

DROP TYPE IF EXISTS Proprietaire CASCADE;
CREATE TABLE Proprietaire PARTITION OF Personne FOR VALUES IN ('Proprietaire') (
IdCompte serial REFERENCES Compte(IdCompte)
);

DROP TYPE IF EXISTS GarconDePlage CASCADE;
CREATE TABLE GarconDePlage PARTITION OF Personne FOR VALUES IN ('GarconDePlage') (
IdCompte serial REFERENCES Compte(IdCompte)

);

DROP TABLE IF EXISTS EstParentDe CASCADE;
CREATE TABLE EstParentDe(
IdParent int REFERENCES Personne(IdPersonne),
IdEnfant int REFERENCES Personne(IdPersonne),
PRIMARY KEY (IdParent, IdEnfant)
);

DROP TABLE IF EXISTS CertificatMedical CASCADE;
CREATE TABLE CertificatMedical(
IdCertificat SERIAL PRIMARY KEY,
DateDelivrance Date,
DocumentPDF bytea,
IdClient int NOT NULL REFERENCES Client(IdPersonne) -- FK ajoutée après l'insertion des clients
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
IdClient serialREFERENCES Personne(IdPersonne),
IdTypeForfait serial REFERENCES TypeForfait(IdTypeForfait),
IdPaiement serial REFERENCES Paiement(IdPaiement)
);

DROP TABLE IF EXISTS Paiement CASCADE;
CREATE TABLE Paiement(
IdPaiement SERIAL PRIMARY KEY,
DateHeure time,
Montant float,
MoyenPaiement EMoyenPaiement,

IdForfait serial REFERENCES Forfait(IdForfait),

IdLocation serial REFERENCES Location(IdLocation)
);

DROP TABLE IF EXISTS Location CASCADE;
CREATE TABLE Location(
IdLocation SERIAL PRIMARY KEY,
DateHeureLocation time,
Duree int,
TarifLocation float,
EtatLocation EEtatLocation,
NumSerie serial REFERENCES Materiel(NumSerie),
IdPersonne serial REFERENCES Personne(IdPersonne),

IdPaiement serial REFERENCES Paiement(IdPaiement)
);

DROP TABLE IF EXISTS CoursPlancheVoile CASCADE;
CREATE TABLE CoursPlancheVoile(
IdCours SERIAL PRIMARY KEY,
DateHeure time,
Niveau EEtatCours,
IdMoniteur serial REFERENCES Moniteur(IdPersonne)
);

- - Création de la table Participation

DROP TABLE IF EXISTS Participation CASCADE;
CREATE TABLE Participation (
IdPersonne SERIAL REFERENCES Client(IdPersonne),
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

DROP TABLE IF EXISTS Materiel CASCADE;
CREATE TABLE Materiel(
NumSerie SERIAL PRIMARY KEY,
Disponible Boolean,
NbPlaces Int,
Statut EStatutMateriel,
IdPrixMateriel serial REFERENCES PrixMateriel(IdPrixMateriel),
Role_Materiel Varchar(20) CHECK (Role IN ('¨Pedalo', 'StandUpPaddle', 'Catamaran ', 'PlancheAVoile')))
PARTITION BY LIST (Role_Materiel);

DROP TABLE IF EXISTS Pedalo CASCADE;
CREATE TABLE Pedalo PARTITION OF Materiel FOR VALUES IN(’Pedalo’)(
);

DROP TABLE IF EXISTS StandUpPaddle CASCADE;
CREATE TABLE StandUpPaddle  PARTITION OF Materiel FOR VALUES IN(’StandUpPaddle’)(
Capacite int
);

DROP TABLE IF EXISTS Catamaran CASCADE;
CREATE TABLE Catamaran PARTITION OF Materiel FOR VALUES IN(’Catamaran’)();

DROP TABLE IF EXISTS PlancheAVoile CASCADE;
CREATE TABLE PlancheAVoile  PARTITION OF Materiel FOR VALUES IN(’PlancheAVoile ’)(
IdCours SERIAL REFERENCES CoursPlancheVoile(IdCours)
);

DROP TABLE IF EXISTS Flotteur CASCADE;
CREATE TABLE Flotteur(
Taille ETailleFlotteur
) INHERITS (PlancheAVoile);

DROP TABLE IF EXISTS PiedDeMat CASCADE;
CREATE TABLE PiedDeMat() INHERITS (PlancheAVoile);

DROP TABLE IF EXISTS Diplome CASCADE;
CREATE TABLE Diplome(
IdDiplome SERIAL PRIMARY KEY,
DateObtention date,
DocumentPDF bytea,
IdPersonne int REFERENCES Personne(IdPersonne)
);

DROP TABLE IF EXISTS Compte CASCADE;
CREATE TABLE Compte (
IdCompte SERIAL PRIMARY KEY,
NomUtilisateur varchar(30),
MotDePasse varchar(20),
IdMoniteur serial REFERENCES Moniteur(IdPersonne), -- FK ajoutée après l'insertion des données

IdProprietaire serial REFERENCES Proprietaire(IdPersonne)
);

DROP TABLE IF EXISTS PermisBateau CASCADE;
CREATE TABLE PermisBateau(
IdPermis SERIAL PRIMARY KEY,
DocumentPDF bytea,
DateObtention Date,
IdProprietaire int REFERENCES Proprietaire(IdPersonne)
);

DROP TABLE IF EXISTS Reservation CASCADE;
CREATE TABLE Reservation (
IdCours SERIAL REFERENCES CoursPlancheVoile(IdCours),
NumSerie SERIAL REFERENCES PlancheAVoile(NumSerie),
PRIMARY KEY (IdCours, NumSerie)
);
