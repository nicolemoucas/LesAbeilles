-- Certificat Médical 
SELECT * FROM CertificatMedical;
INSERT INTO CertificatMedical (IdCertificat, DateDelivrance, DocumentPDF, IdClient) VALUES
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),; -- example random pour pouvoir insérer les données

-- Type Forfait OK
SELECT * FROM TypeForfait;
INSERT INTO TypeForfait (IdTypeForfait, NbSeances, Prix) VALUES 
	(DEFAULT, 1, 25),
	(DEFAULT, 2, 42),
	(DEFAULT, 5, 100);
SELECT * FROM TypeForfait;

-- Forfait NOK
SELECT * FROM Forfait;
INSERT INTO Forfait (IdForfait, DateFin, NbSeancesRestantes, ForfaitEnfant, IdPersonne, IdTypeForfait) VALUES
	(DEFAULT, '2023-10-10', 1, TRUE, 13, 3);
	
-- Location NOK
SELECT * FROM Location;
INSERT INTO Location (IdLocation, DateHeureLocation, Duree, TarifLocation, EtatLocation, NumSerie, IdPersonne) VALUES

-- Personne 
SELECT enum_range(null::ECamping);
SELECT enum_range(null::EStatutClient);
SELECT enum_range(null::EPreferenceContact);
SELECT enum_range(null::ERoleEmploye);

-- Compte
CREATE EXTENSION pgcrypto;
SELECT * FROM Compte;
INSERT INTO Compte (IdCompte, NomUtilisateur, MotDePasse) VALUES
	(DEFAULT, jeanmichel, crypt('jeanmichel', gen_salt('bf')),
	(DEFAULT, micheljean, crypt('micheljean', gen_salt('bf'))
)

ALTER TABLE Compte 
	ADD FOREIGN KEY (IdPersonne) REFERENCES Personne(IdPersonne);
ALTER TABLE Moniteur
	ADD FOREIGN KEY (IdCertificat) REFERENCES CertificatMedical(IdCertificat);

-- Client OK
SELECT * FROM Client;
INSERT INTO Client (IdPersonne, Nom, Prenom, DateNaissance, Mail, Camping, Statut, Taille, Poids, PreferenceContact) VALUES
	(DEFAULT, 'FRASELLE', 'Nadège', '1997-08-02', 'nadege.fraselle@gmail.com', 'Autre', 'Débutant', 170, 60, 'Mail'),
	(DEFAULT, 'MARTIN', 'Luc', '1982-05-13', 'lm@gmail.com', 'Grand Plage', 'Sportif', 185, 86, 'Mail'),
	(DEFAULT, 'LEFEBVRE', 'Hugo', '1989-11-07', 'hl@hotmail.com', 'Jolibois', 'Débutant', 168, 70, 'Mail'),
	(DEFAULT, 'ROBERT', 'Lena', '1998-10-27', 'lr@orange.com', 'Jolibois', 'Sportif', 170, 60, 'Mail'),
	(DEFAULT, 'GARCIA', 'Evan', '1987-07-12', 'eg@outlook.com', 'Marande', 'Sportif', 178, 68, 'Mail');
INSERT INTO Client (IdPersonne, Nom, Prenom, DateNaissance, NumTelephone, Camping, Statut, Taille, Poids, PreferenceContact) VALUES
	(DEFAULT, 'JACQUES', 'Jean', '1980-10-20', 0734982410, 'Jolibois', 'Débutant', 169, 73, 'Téléphone'),
	(DEFAULT, 'PETIT', 'Emma', '1995-08-24', 0712345678, 'Marande', 'Sportif', 172, 65, 'Téléphone'),
	(DEFAULT, 'PETIT', 'Paul', '1996-08-24', 0682749174, 'Marande', 'Sportif', 182, 75, 'Téléphone'),
	(DEFAULT, 'DUPONT', 'Zoe', '1984-09-21', 0756234890, 'Grand Plage', 'Sportif', 156, 50, 'Téléphone');
INSERT INTO Client (IdPersonne, Nom, Prenom, DateNaissance, Mail, NumTelephone, Camping, Statut, Taille, Poids, PreferenceContact) VALUES
	(DEFAULT, 'FERNANDEZ', 'Augustin', '1996-05-03', 'af@gmail.com', 0789456123, 'Autre', 'Sportif', 196, 80, 'Téléphone'),
	(DEFAULT, 'FERNANDEZ', 'Julie', '1997-05-03', 'jf@gmail.com', 0684957138, 'Autre', 'Sportif', 196, 80, 'Téléphone'),
	(DEFAULT, 'RODRIGUEZ', 'Julia', '1998-07-15', 'jr@icloud.com', 0756938517, 'Jolibois', 'Débutant', 165, 55, 'Mail');
INSERT INTO Client (IdPersonne, Nom, Prenom, DateNaissance, Camping, Statut, Taille, Poids, IdCertificat) VALUES
	(DEFAULT, 'PETIT', 'Lola', '2013-04-18', 'Marande', 'Sportif', 138, 30, 1),
	(DEFAULT, 'PETIT', 'Noah', '2012-01-04', 'Marande', 'Sportif', 145, 40, 2),
	(DEFAULT, 'FERNANDEZ', 'Leo', '2015-06-30', 'Autre', 'Débutant', 143, 44, 3),
	(DEFAULT, 'FERNANDEZ', 'Alice', '2014-03-15', 'Autre', 'Sportif', 140, 33, 4),
	(DEFAULT, 'FRASELLE', 'Mochi', '2020-09-10', 'Autre', 'Débutant', 50, 5, 5);
SELECT * FROM Client;

-- Ajouter FK à Certificat Médical et Client NOK
SELECT * FROM CertificatMedical;
SELECT * FROM Client;
ALTER TABLE CertificatMedical 
	ADD FOREIGN KEY (IdClient) REFERENCES Personne(IdPersonne);
ALTER TABLE Client
	ADD FOREIGN KEY (IdCertificat) REFERENCES CertificatMedical(IdCertificat);
	
-- Est Parent De NOK
SELECT * FROM EstParentDe;
SELECT * FROM Client;
SELECT * FROM ONLY Personne WHERE IdPersonne = 7;
SELECT * FROM Personne WHERE IdPersonne = 7;
SELECT * FROM Personne where idpersonne = 13;
/*INSERT INTO EstParentDe (IdParent, IdEnfant) VALUES
	(7, 13), (7, 14), (8, 13), (8, 14),
	(10, 15), (10, 16), (11, 15), (11, 16);
*/

-- Moniteur
SELECT * FROM Moniteur;
INSERT INTO Moniteur (IdPersonne, Nom, Prenom, DateNaissance, Mail, NumTelephone) VALUES
	(DEFAULT, 'FROTTIER', 'Louis', '2000-11-15', 'lf15@gmail.com', 0795847645);
INSERT INTO Moniteur (IdPersonne, Nom, Prenom, DateNaissance, NumTelephone) VALUES
	(DEFAULT, 'BOND', 'James', '1996-08-04', '0699887766');
INSERT INTO Moniteur (IdPersonne, Nom, Prenom, DateNaissance, Mail) VALUES
	(DEFAULT, 'FLEURIOT', 'Florent', '1980-05-29', 'ffff@gmail.com');
SELECT * FROM Moniteur;

-- Cours de Planche à Voile NOK
SELECT enum_range(null::EStatutClient);
SELECT * FROM CoursPlancheVoile;
INSERT INTO CoursPlancheVoile (IdCours, DateHeure, Niveau, IdPersonne) VALUES
	(DEFAULT, '2023-08-21 14:00:00', 'Debutant', 16);
	
-- Prix Materiel OK
SELECT * FROM PrixMateriel;
INSERT INTO PrixMateriel (IdPrixMateriel, NomMateriel, PrixHeure, PrixHeureSupp) VALUES
	(DEFAULT, 'Catamaran', 45.0, 35.0),
	(DEFAULT, 'Planche à voile', 25.0, 20.0),
	(DEFAULT, 'Stand Up Paddle', 20.0, 15.0);
INSERT INTO PrixMateriel (IdPrixMateriel, NomMateriel, PrixDemiHeure, PrixHeure) VALUES
	(DEFAULT, 'Pédalo', 10.0, 15.0);
SELECT * FROM PrixMateriel;

-- Materiel
SELECT enum_range(null::EStatutMateriel);

--- Catamaran OK
SELECT * FROM Catamaran;
INSERT INTO Catamaran (NumSerie, Disponible, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, TRUE, 4, 'Fonctionnel', 1),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 1);
SELECT * FROM Catamaran;

--- Planche A Voile 
SELECT * FROM PlancheAVoile;
INSERT INTO PlancheAVoile (NumSerie, Disponible, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, 1, );
SELECT * FROM PlancheAVoile;

-- Stand Up Paddle OK
SELECT * FROM StandUpPaddle;
INSERT INTO StandUpPaddle (NumSerie, Disponible, NbPlaces, Statut, IdPrixMateriel, Capacite) VALUES
	(DEFAULT, TRUE, 4, 'Reçu', 3, 200),
	(DEFAULT, TRUE, 4, 'Reçu', 3, 200),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 3, 200),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 3, 200),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 3, 200),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 3, 200),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 3, 200),
	(DEFAULT, FALSE, 4, 'Hors service', 3, 200),
	(DEFAULT, FALSE, 4, 'Hors service', 3, 200),
	(DEFAULT, FALSE, 4, 'Hors service', 3, 200);
SELECT * FROM StandUpPaddle;

-- Flotteur Planche à Voile
SELECT * FROM Flotteur;
INSERT INTO Flotteur (NumSerie, Disponible, NbPlaces, Statut, IdPrixMateriel, IdCours, Taille) VALUES
	(DEFAULT);
SELECT * FROM Flotteur;

-- Pédalo
SELECT * FROM Pedalo;
INSERT INTO Pedalo (NumSerie, Disponible, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, TRUE, 4, 'Fonctionnel', 4),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 4),
	(DEFAULT, FALSE, 4, 'Fonctionnel', 4),
	(DEFAULT, FALSE, 4, 'Hors service', 4);
SELECT * FROM Pedalo;
