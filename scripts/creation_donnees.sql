CREATE EXTENSION IF NOT EXISTS pgcrypto; -- pour crypter les mots de passe

-- Certificat Médical OK
INSERT INTO CertificatMedical (IdCertificat, DateDelivrance, DocumentPDF, IdClient) VALUES
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),-- example random pour pouvoir insérer les données
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 13); 
SELECT * FROM CertificatMedical;

-- Type Forfait OK
INSERT INTO TypeForfait (IdTypeForfait, NbSeances, Prix) VALUES 
	(DEFAULT, 1, 25),
	(DEFAULT, 2, 42),
	(DEFAULT, 5, 100);
SELECT * FROM TypeForfait;

-- Forfait OK
INSERT INTO Forfait (IdForfait, DateFin, NbSeancesRestantes, ForfaitEnfant, IdClient, IdTypeForfait, IdPaiement) VALUES
	(DEFAULT, '2023-10-10', 1, TRUE, 13, 1, 1),
	(DEFAULT, '2023-10-10', 1, TRUE, 14, 2, 2),
	(DEFAULT, '2024-10-10', 1, TRUE, 15, 3, 3),
	(DEFAULT, '2024-10-10', 5, TRUE, 16, 3, 4),
	(DEFAULT, '2024-10-10', 0, FALSE, 1, 3, 4),
	(DEFAULT, '2024-10-10', 1, FALSE, 2, 3, 4);
SELECT * FROM Forfait;

-- Paiement OK
SELECT enum_range(null::EMoyenPaiement);
INSERT INTO Paiement (IdPaiement, DateHeure, Montant, MoyenPaiement) VALUES
	(DEFAULT, '2023-07-10 10:00:00', 25, 'Carte'),
	(DEFAULT, '2023-08-12 11:20:00', 42, 'Espèces'),
	(DEFAULT, '2023-07-28 15:30:00', 100, 'Carte'),
	(DEFAULT, '2023-10-10 15:15:50', 300, 'Carte');
SELECT * FROM Paiement;

-- Diplôme OK
INSERT INTO Diplome (IdDiplome, DateObtention, DocumentPDF, IdMoniteur) VALUES
	(DEFAULT, '2021-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 3),-- example random pour pouvoir insérer les données
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 3),
	(DEFAULT, '2020-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 4),
	(DEFAULT, '2022-10-10', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 4); 
SELECT * FROM Diplome;
SELECT * FROM CompteEmploye;

-- Permis Bateau
INSERT INTO PermisBateau (IdPermis, DateObtention, DocumentPDF, IdProprietaire) VALUES
	(DEFAULT, '2022-01-02', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 1),
	(DEFAULT, '2023-01-02', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 1),
	(DEFAULT, '2023-01-02', decode('013d7d16d7ad4fefb61bd95b765c8ceb', 'hex'), 2);
SELECT * FROM PermisBateau;
	
-- Location
SELECT * FROM PrixMateriel;
SELECT enum_range(null::EEtatLocation); --"{Terminée,""En cours"",Annulée}"
INSERT INTO Location (DateHeureLocation, Duree, TarifLocation, EtatLocation, IdClient, IdPaiement, IdCatamaran) VALUES
	('2023-08-10 10:00:00', '01:00:00', 45, 'Terminée', 1, 1, 1);
INSERT INTO Location (DateHeureLocation, Duree, TarifLocation, EtatLocation, IdClient, IdPaiement, IdPlancheVoile) VALUES
	('2023-08-10 10:00:00', '01:00:00', 25, 'Annulée', 2, 2, 2),
	('2023-08-11 10:00:00', '02:00:00', 45, 'Terminée', 3, 2, 2);
INSERT INTO Location (DateHeureLocation, Duree, TarifLocation, EtatLocation, IdClient, IdPaiement, IdStandUpPaddle) VALUES
	('2023-09-10 10:00:00', '01:00:00', 20, 'Terminée', 4, 3, 3),
	('2023-09-04 10:00:00', '02:00:00', 35, 'Annulée', 5, 3, 3);
INSERT INTO Location (DateHeureLocation, Duree, TarifLocation, EtatLocation, IdClient, IdPaiement, IdPedalo) VALUES
	('2023-9-15 10:00:00', '01:00:00', 15, 'Terminée', 6, 4, 4),
	('2023-9-15 10:00:00', '01:30:00', 25, 'Terminée', 7, 4, 4),
	('2023-9-15 10:00:00', '00:30:00', 10, 'Terminée', 8, 4, 4);
SELECT * FROM Location;

-- Personne 
SELECT enum_range(null::ECamping);
SELECT enum_range(null::EStatutClient);
SELECT enum_range(null::EPreferenceContact);
SELECT enum_range(null::ERoleEmploye);

-- Client OK
INSERT INTO Client (IdClient, Nom, Prenom, DateNaissance, Mail, Camping, Statut, Taille, Poids, PreferenceContact) VALUES
	(DEFAULT, 'FRASELLE', 'Nadège', '1997-08-02', 'nadege.fraselle@gmail.com', 'Autre', 'Débutant', 170, 60, 'Mail'),
	(DEFAULT, 'MARTIN', 'Luc', '1982-05-13', 'lm@gmail.com', 'Grand Plage', 'Sportif', 185, 86, 'Mail'),
	(DEFAULT, 'LEFEBVRE', 'Hugo', '1989-11-07', 'hl@hotmail.com', 'Jolibois', 'Débutant', 168, 70, 'Mail'),
	(DEFAULT, 'ROBERT', 'Lena', '1998-10-27', 'lr@orange.com', 'Jolibois', 'Sportif', 170, 60, 'Mail'),
	(DEFAULT, 'GARCIA', 'Evan', '1987-07-12', 'eg@outlook.com', 'Marande', 'Sportif', 178, 68, 'Mail');
INSERT INTO Client (IdClient, Nom, Prenom, DateNaissance, NumTelephone, Camping, Statut, Taille, Poids, PreferenceContact) VALUES
	(DEFAULT, 'JACQUES', 'Jean', '1980-10-20', 0734982410, 'Jolibois', 'Débutant', 169, 73, 'Téléphone'),
	(DEFAULT, 'PETIT', 'Emma', '1995-08-24', 0712345678, 'Marande', 'Sportif', 172, 65, 'Téléphone'),
	(DEFAULT, 'PETIT', 'Paul', '1996-08-24', 0682749174, 'Marande', 'Sportif', 182, 75, 'Téléphone'),
	(DEFAULT, 'DUPONT', 'Zoe', '1984-09-21', 0756234890, 'Grand Plage', 'Sportif', 156, 50, 'Téléphone');
INSERT INTO Client (IdClient, Nom, Prenom, DateNaissance, Mail, NumTelephone, Camping, Statut, Taille, Poids, PreferenceContact) VALUES
	(DEFAULT, 'FERNANDEZ', 'Augustin', '1996-05-03', 'af@gmail.com', 0789456123, 'Autre', 'Sportif', 196, 80, 'Téléphone'),
	(DEFAULT, 'FERNANDEZ', 'Julie', '1997-05-03', 'jf@gmail.com', 0684957138, 'Autre', 'Sportif', 196, 80, 'Téléphone'),
	(DEFAULT, 'RODRIGUEZ', 'Julia', '1998-07-15', 'jr@icloud.com', 0756938517, 'Jolibois', 'Débutant', 165, 55, 'Mail');
INSERT INTO Client (IdClient, Nom, Prenom, DateNaissance, Camping, Statut, Taille, Poids, IdCertificat) VALUES
	(DEFAULT, 'PETIT', 'Lola', '2013-04-18', 'Marande', 'Sportif', 138, 30, 1),
	(DEFAULT, 'PETIT', 'Noah', '2012-01-04', 'Marande', 'Sportif', 145, 40, 2),
	(DEFAULT, 'FERNANDEZ', 'Leo', '2015-06-30', 'Autre', 'Débutant', 143, 44, 3),
	(DEFAULT, 'FERNANDEZ', 'Alice', '2014-03-15', 'Autre', 'Sportif', 140, 33, 4),
	(DEFAULT, 'FRASELLE', 'Mochi', '2020-09-10', 'Autre', 'Débutant', 50, 5, 5);
SELECT * FROM Client;

-- Est Parent De OK
INSERT INTO EstParentDe (IdParent, IdEnfant) VALUES
	(1, 17),
	(7, 13), (7, 14), (8, 13), (8, 14),
	(10, 15), (10, 16), (11, 15), (11, 16);
SELECT * FROM EstParentDe;

-- Comptes Employé
SELECT enum_range(null::ERoleEmploye); -- "{Propriétaire,Moniteur,""Garçon de Plage""}"
-- Propriétaires OK
INSERT INTO CompteEmploye (IdCompte, NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye, IdPermis) VALUES
	(DEFAULT, 'lfrottier', crypt('lfrottier', gen_salt('bf')), 'FROTTIER', 'Louis', '1980-11-15', 'lf15@gmail.com', '0795847645', 'Propriétaire', 2),
	(DEFAULT, 'jfrottier', crypt('jfrottier', gen_salt('bf')), 'FROTTIER', 'Jeannette', '1981-11-15', 'jf15@gmail.com', '0795847646', 'Propriétaire', 3);
-- Moniteurs OK
INSERT INTO CompteEmploye (IdCompte, NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye, IdDiplome) VALUES
	(DEFAULT, 'jbond', crypt('jbond', gen_salt('bf')), 'BOND', 'James', '1996-08-04', 'jbond@yahoor.fr', '0699887766', 'Moniteur', 2),
	(DEFAULT, 'ffleuriot', crypt('ffleuriot', gen_salt('bf')), 'FLEURIOT', 'Florent', '1980-05-29', 'ff@gmail.be', '0694857601', 4),
	(DEFAULT, 'hmeyer', crypt('hmeyer', gen_salt('bf')), 'MEYER', 'Hugo', '2000-02-02', 'hmeyer@gmail.lu', '0785948372', 'Moniteur', 3);
-- Garçons de plage OK
INSERT INTO CompteEmploye (IdCompte, NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
	(DEFAULT, 'dlee', crypt('dlee', gen_salt('bf')), 'LEE', 'David', '1996-08-04', 'dlee@outlook.fr', '0649586700', 'Garçon de Plage'),
	(DEFAULT, 'lpetit', crypt('lpetit', gen_salt('bf')), 'PETIT', 'Laura', '1993-06-04', 'lpetit@gmail.fr', '0766548392', 'Garçon de Plage');
SELECT * FROM CompteEmploye;

-- Cours de Planche à Voile
SELECT * FROM Client;
SELECT enum_range(null::EStatutClient); --"{Débutant,Sportif}"
INSERT INTO CoursPlancheVoile (IdCours, DateHeure, Niveau, IdCompte) VALUES
	(DEFAULT, '2023-08-21 14:00:00', 'Débutant', 1),
	(DEFAULT, '2023-08-22 14:00:00', 'Débutant', 3),
	(DEFAULT, '2023-08-23 14:00:00', 'Débutant', 6),
	(DEFAULT, '2023-08-24 14:00:00', 'Sportif', 2),
	(DEFAULT, '2023-08-25 14:00:00', 'Sportif', 4),
	(DEFAULT, '2023-08-26 10:00:00', 'Sportif', 5),
	(DEFAULT, '2023-08-26 14:00:00', 'Débutant', 4),
	(DEFAULT, '2023-08-26 14:00:00', 'Sportif', 5);
SELECT * FROM CoursPlancheVoile;

-- Prix Matériel
INSERT INTO PrixMateriel (IdPrixMateriel, NomMateriel, PrixHeure, PrixHeureSupp) VALUES
	(DEFAULT, 'Catamaran', 45.0, 35.0),
	(DEFAULT, 'Planche à voile', 25.0, 20.0),
	(DEFAULT, 'Stand Up Paddle', 20.0, 15.0);
INSERT INTO PrixMateriel (IdPrixMateriel, NomMateriel, PrixDemiHeure, PrixHeure) VALUES
	(DEFAULT, 'Pédalo', 10.0, 15.0);
SELECT * FROM PrixMateriel;

-- Materiel
SELECT enum_range(null::EStatutMateriel); --"{Reçu,Fonctionnel,""Hors service"",""Mis au rebut""}"

--- Catamaran Hobie Cart 15 (prix materiel 1) OK
INSERT INTO Catamaran (IdCatamaran, Disponible, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, TRUE, 4, 'Fonctionnel', 1),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 1);
SELECT * FROM Catamaran;

-- Stand Up Paddle (prix materiel 3) OK
INSERT INTO StandUpPaddle (IdStandUpPaddle, Disponible, NbPlaces, Statut, Capacite, IdPrixMateriel) VALUES
	(DEFAULT, TRUE, 4, 'Reçu', '200l', 3),
	(DEFAULT, TRUE, 4, 'Reçu', '200l', 3),
	(DEFAULT, TRUE, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, TRUE, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, TRUE, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, TRUE, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, TRUE, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, FALSE, 4, 'Hors service', '200l', 3),
	(DEFAULT, FALSE, 4, 'Hors service', '200l', 3),
	(DEFAULT, FALSE, 4, 'Hors service', '200l', 3);
SELECT * FROM StandUpPaddle;

--- Planche A Voile (prix materiel 2) OK
INSERT INTO PlancheAVoile (IdPlancheVoile, Disponible, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, TRUE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --2 
	(DEFAULT, TRUE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --4
	(DEFAULT, TRUE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --6
	(DEFAULT, TRUE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --8 
	(DEFAULT, FALSE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --10
	(DEFAULT, FALSE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --12
	(DEFAULT, FALSE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --14
	(DEFAULT, FALSE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --16
	(DEFAULT, FALSE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2), --18
	(DEFAULT, FALSE, 1, 'Reçu', 2), (DEFAULT, TRUE, 1, 'Reçu', 2); --20
SELECT * FROM PlancheAVoile;

-- Flotteur (Planche à Voile) OK
SELECT enum_range(null::ECapaciteFlotteur); -- "{150l,170l,190l,205l}"
INSERT INTO Flotteur (IdFlotteur, IdPlancheVoile, Capacite) VALUES
	-- 7 de 150L
	(DEFAULT, 1, '150l'),
	(DEFAULT, 2, '150l'),
	(DEFAULT, 3, '150l'),
	(DEFAULT, 4, '150l'),
	(DEFAULT, 5, '150l'),
	(DEFAULT, 6, '150l'),
	(DEFAULT, 7, '150l'),
	-- 7 de 170L
	(DEFAULT, 8, '170l'),
	(DEFAULT, 9, '170l'),
	(DEFAULT, 10, '170l'),
	(DEFAULT, 11, '170l'),
	(DEFAULT, 12, '170l'),
	(DEFAULT, 13, '170l'),
	(DEFAULT, 14, '170l'),
	-- 3 de 190L
	(DEFAULT, 15, '190l'),
	(DEFAULT, 16, '190l'),
	(DEFAULT, 17, '190l'),
	-- 3 de 205L
	(DEFAULT, 18, '205l'),
	(DEFAULT, 19, '205l'),
	(DEFAULT, 20, '205l');
SELECT * FROM Flotteur;

-- Pied De Mat (Planche à Voile) OK
INSERT INTO PiedDeMat (IdPiedDeMat, IdPlancheVoile) VALUES
	-- 25
	(DEFAULT, 1), (DEFAULT, 10), (DEFAULT, 18), --3
	(DEFAULT, 2), (DEFAULT, 11), (DEFAULT, 19), --6
	(DEFAULT, 3), (DEFAULT, 12), (DEFAULT, 20), --9
	(DEFAULT, 4), (DEFAULT, 13), (DEFAULT, 1), --12
	(DEFAULT, 5), (DEFAULT, 14), (DEFAULT, 2), --15
	(DEFAULT, 6), (DEFAULT, 15), (DEFAULT, 3), --18
	(DEFAULT, 7), (DEFAULT, 16), (DEFAULT, 4), --21
	(DEFAULT, 8), (DEFAULT, 17), (DEFAULT, 5), --24
	(DEFAULT, 9);
SELECT * FROM PiedDeMat;

-- Voile (Planche à Voile) OK
SELECT enum_range(null::ETailleVoile); -- "{3m2,4m2,4.5m2,4.9m2,5.4m2}"
INSERT INTO Voile (IdVoile, IdPlancheVoile, Taille) VALUES
	-- 7 de 3m2
	(DEFAULT, 1, '3m2'),
	(DEFAULT, 2, '3m2'),
	(DEFAULT, 3, '3m2'),
	(DEFAULT, 4, '3m2'),
	(DEFAULT, 5, '3m2'),
	(DEFAULT, 6, '3m2'),
	(DEFAULT, 7, '3m2'),
	-- 4 de 3m2
	(DEFAULT, 5, '4m2'),
	(DEFAULT, 6, '4m2'),
	(DEFAULT, 7, '4m2'),
	(DEFAULT, 8, '4m2'),
	-- 2 de 4.5m2
	(DEFAULT, 9, '4.5m2'),
	(DEFAULT, 10, '4.5m2'),
	-- 2 de 4.9m2
	(DEFAULT, 11, '4.9m2'),
	(DEFAULT, 12, '4.9m2'),
	-- 2 de 5.4m2
	(DEFAULT, 13, '5.4m2'),
	(DEFAULT, 14, '5.4m2');
SELECT * FROM Voile;

-- Pédalo (prix materiel 4) OK
INSERT INTO Pedalo (IdPedalo, Disponible, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, TRUE, 4, 'Fonctionnel', 4),
	(DEFAULT, TRUE, 4, 'Fonctionnel', 4),
	(DEFAULT, FALSE, 4, 'Fonctionnel', 4),
	(DEFAULT, FALSE, 4, 'Hors service', 4);
SELECT * FROM Pedalo;
	 
-- Réservation
SELECT * FROM CoursPlancheVoile;
SELECT * FROM PlancheAVoile;
INSERT INTO Reservation (IdCours, IdPlancheVoile) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4), 
	(5, 5),
	(6, 6),
	(7, 7);
SELECT * FROM Reservation;

-- Participation
SELECT * FROM CoursPlancheVoile;
INSERT INTO Participation (IdClient, IdCours) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4), 
	(5, 5),
	(6, 6),
	(7, 7);
SELECT * FROM Participation;

-- Ajout des FK

ALTER TABLE EstParentDe
	ADD FOREIGN KEY (IdParent) REFERENCES Client(IdClient),
	ADD FOREIGN KEY (IdEnfant) REFERENCES Client(IdClient);
	 
ALTER TABLE CertificatMedical 
	ADD FOREIGN KEY (IdClient) REFERENCES Client(IdClient);

ALTER TABLE Forfait 
	ADD FOREIGN KEY (IdClient) REFERENCES Client(IdClient),
	ADD FOREIGN KEY (IdPaiement) REFERENCES Paiement(IdPaiement),
	ADD FOREIGN KEY (IdTypeForfait) REFERENCES TypeForfait(IdTypeForfait);

ALTER TABLE Diplome 
	ADD FOREIGN KEY (IdMoniteur) REFERENCES CompteEmploye(IdCompte);

ALTER TABLE PermisBateau 
	ADD FOREIGN KEY (IdPermis) REFERENCES PermisBateau(IdPermis);

ALTER TABLE Client
	ADD FOREIGN KEY (IdCertificat) REFERENCES CertificatMedical(IdCertificat);

ALTER TABLE CompteEmploye 
	ADD FOREIGN KEY (IdDiplome) REFERENCES Diplome(IdDiplome),
	ADD FOREIGN KEY (IdPermis) REFERENCES PermisBateau(IdPermis);

ALTER TABLE Catamaran
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel);

ALTER TABLE Flotteur
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile);

ALTER TABLE Pedalo
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel);

ALTER TABLE PiedDeMat
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile);

ALTER TABLE PlancheAVoile
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel);

ALTER TABLE StandUpPaddle
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel);
	
ALTER TABLE Voile
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile);

ALTER TABLE Location
	ADD FOREIGN KEY (IdClient) REFERENCES Client(IdClient),
	ADD FOREIGN KEY (IdPaiement) REFERENCES Paiement(IdPaiement),
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile),
	ADD FOREIGN KEY (IdStandUpPaddle) REFERENCES StandUpPaddle(IdStandUpPaddle),
	ADD FOREIGN KEY (IdPedalo) REFERENCES Pedalo(IdPedalo),
	ADD FOREIGN KEY (IdCatamaran) REFERENCES Catamaran(IdCatamaran);
	
ALTER TABLE CoursPlancheVoile
	ADD FOREIGN KEY (IdCompte) REFERENCES CompteEmploye(IdCompte);
	
ALTER TABLE Reservation
	ADD FOREIGN KEY (IdCours) REFERENCES CoursPlancheVoile(IdCours),
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile);
	
ALTER TABLE Participation
	ADD FOREIGN Key (IdClient) REFERENCES Client(IdClient),
	ADD FOREIGN Key (IdCours) REFERENCES CoursPlancheVoile(IdCours);
	
-- check constraints de Participation
SELECT conname AS constraint_name, 
contype AS constraint_type
FROM pg_catalog.pg_constraint cons
JOIN pg_catalog.pg_class t ON t.oid = cons.conrelid
WHERE t.relname ='participation';