CREATE EXTENSION IF NOT EXISTS pgcrypto; -- pour crypter les mots de passe

-- Certificat Médical OK
INSERT INTO CertificatMedical (IdCertificat, DateDelivrance, LienDocumentPDF, IdClient) VALUES
	(DEFAULT, '2022-10-10', 'https://drive.google.com/file/d/1fbdICYRItidtTzYpYLW6ZWwdElZiG_-z/view?usp=drive_link', 13),-- example random pour pouvoir insérer les données
	(DEFAULT, '2022-10-10', 'https://drive.google.com/file/d/1QlICJMIBRUyzmb50Bty8Jl8pqYZh2FnM/view?usp=drive_link', 14),
	(DEFAULT, '2022-10-10', 'https://drive.google.com/file/d/1NrU0QpN-17j-dyhuSIfgP4Ktff2X3cnW/view?usp=drive_link', 15),
	(DEFAULT, '2022-10-10', 'https://drive.google.com/file/d/1bdbLyyKGs9MPdf4hA1lj6g2vJgBwZiw2/view?usp=drive_link', 16),
	(DEFAULT, '2022-10-10', 'https://drive.google.com/file/d/1pYPuPtIbEho8oBHU9ZQyucOwM7YkT-uE/view?usp=drive_link', 17); 
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
INSERT INTO Diplome (IdDiplome, DateObtention, LienDocumentPDF, IdMoniteur) VALUES
	(DEFAULT, '2021-10-10', 'https://drive.google.com/file/d/1QiXghjblbhdeyqIvnLT9n_trK4Io1OU7/view?usp=drive_link', 3),-- example random pour pouvoir insérer les données
	(DEFAULT, '2022-10-10', 'https://drive.google.com/file/d/1b3xjlb21cCZA392lbzGPY0tsQkc4tSeF/view?usp=drive_link', 3),
	(DEFAULT, '2020-10-10', 'https://drive.google.com/file/d/1JpNlpyos-tFZ3AGmVEeWsaoLTIzkg24b/view?usp=drive_link', 4),
	(DEFAULT, '2022-10-10', 'https://drive.google.com/file/d/1BSGwX18SWwfXWR7w0b7Vc8L4jkx-ElkT/view?usp=drive_link', 4); 
SELECT * FROM Diplome;
SELECT * FROM CompteEmploye;

-- Permis Bateau
INSERT INTO PermisBateau (IdPermis, DateObtention, LienDocumentPDF, IdProprietaire) VALUES
	(DEFAULT, '2022-01-02', 'https://drive.google.com/file/d/1RunXqNU_UQaShvsZp63I5Wcr0HOVDzYW/view?usp=drive_link', 1),
	(DEFAULT, '2023-01-02', 'https://drive.google.com/file/d/1foUCZ4RWaPsM_lUN7tOtj2phqaQfzGYV/view?usp=drive_link', 1),
	(DEFAULT, '2023-01-02', 'https://drive.google.com/file/d/14bj8lZfiRb4LHh8pOBEx-byt5pK_p_E0/view?usp=drive_link', 2);
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
-- Enfants
INSERT INTO Client (IdClient, Nom, Prenom, DateNaissance, Camping, Statut, NumTelephone, Taille, Poids, IdCertificat) VALUES
	(DEFAULT, 'PETIT', 'Lola', '2013-04-18', 'Marande', 'Sportif', 0682749174, 138, 30, 1),
	(DEFAULT, 'PETIT', 'Noah', '2012-01-04', 'Marande', 'Sportif', 0682749174, 145, 40, 2),
	(DEFAULT, 'FERNANDEZ', 'Leo', '2015-06-30', 'Autre', 'Débutant', 0684957138, 143, 44, 3),
	(DEFAULT, 'FERNANDEZ', 'Alice', '2014-03-15', 'Autre', 'Sportif', 0684957138, 140, 33, 4);
INSERT INTO Client (IdClient, Nom, Prenom, DateNaissance, Camping, Statut, Mail, Taille, Poids, IdCertificat) VALUES
	(DEFAULT, 'FRASELLE', 'Mochi', '2015-09-10', 'Autre', 'Débutant', 'nadege.fraselle@gmail.com', 50, 5, 5);
SELECT * FROM Client;

-- Comptes Employé
SELECT enum_range(null::ERoleEmploye); -- "{Propriétaire,Moniteur,""Garçon de Plage""}"
-- Propriétaires OK
INSERT INTO CompteEmploye (IdCompte, NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye, IdPermis) VALUES
	(DEFAULT, 'lfrottier', crypt('lfrottier', gen_salt('bf')), 'FROTTIER', 'Louis', '1980-11-15', 'lf15@lesabeilles.com', '0795847645', 'Propriétaire', 2),
	(DEFAULT, 'jfrottier', crypt('jfrottier', gen_salt('bf')), 'FROTTIER', 'Jeannette', '1981-11-15', 'jf15@lesabeilles.com', '0795847646', 'Propriétaire', 3);
-- Moniteurs OK
INSERT INTO CompteEmploye (IdCompte, NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye, IdDiplome) VALUES
	(DEFAULT, 'jbond', crypt('jbond', gen_salt('bf')), 'BOND', 'James', '1996-08-04', 'jbond@lesabeilles.fr', '0699887766', 'Moniteur', 2),
	(DEFAULT, 'ffleuriot', crypt('ffleuriot', gen_salt('bf')), 'FLEURIOT', 'Florent', '1980-05-29', 'ff@lesabeilles.be', '0694857601', 'Moniteur', 4),
	(DEFAULT, 'hmeyer', crypt('hmeyer', gen_salt('bf')), 'MEYER', 'Hugo', '2000-02-02', 'hmeyer@lesabeilles.lu', '0785948372', 'Moniteur', 3);
-- Garçons de plage OK
INSERT INTO CompteEmploye (IdCompte, NomUtilisateur, MotDePasse, Nom, Prenom, DateNaissance, Mail, NumTelephone, TypeEmploye) VALUES
	(DEFAULT, 'dlee', crypt('dlee', gen_salt('bf')), 'LEE', 'David', '1996-08-04', 'dlee@lesabeilles.fr', '0649586700', 'Garçon de Plage'),
	(DEFAULT, 'lpetit', crypt('lpetit', gen_salt('bf')), 'PETIT', 'Laura', '1993-06-04', 'lpetit@lesabeilles.fr', '0766548392', 'Garçon de Plage');
--SELECT * FROM CompteEmploye where typeemploye = 'Propriétaire';
--SELECT * FROM CompteEmploye where typeemploye = 'Moniteur';

-- Cours de Planche à Voile
--SELECT * FROM Client;
--SELECT enum_range(null::EStatutClient); --"{Débutant,Sportif}"
--SELECT enum_range(null::EEtatCours); --"{Prévu,"En cours",Réalisé,Annulé}"
INSERT INTO CoursPlancheVoile (IdCours, DateHeure, Niveau, EtatCours, IdCompte) VALUES
	(DEFAULT, '2023-08-21 14:00:00', 'Débutant', 'Réalisé', 1),
	(DEFAULT, '2023-08-22 14:00:00', 'Débutant', 'Réalisé', 3),
	(DEFAULT, '2023-08-23 14:00:00', 'Débutant', 'Réalisé', 6),
	(DEFAULT, '2023-08-24 14:00:00', 'Sportif', 'Annulé', 2),
	(DEFAULT, '2023-08-25 14:00:00', 'Sportif', 'Réalisé', 4),
	(DEFAULT, '2023-08-26 10:00:00', 'Sportif', 'Annulé', 5),
	(DEFAULT, '2023-08-26 14:00:00', 'Débutant', 'Réalisé', 4),
	(DEFAULT, '2023-08-26 14:00:00', 'Sportif', 'Annulé', 5),
	(DEFAULT, '2024-08-28 14:00:00', 'Débutant', 'Prévu', 4),
	(DEFAULT, '2024-08-26 14:00:00', 'Sportif', 'Prévu', 7),
	(DEFAULT, '2024-06-28 14:00:00', 'Débutant', 'Prévu', 4),
	(DEFAULT, '2024-07-26 14:00:00', 'Sportif', 'Prévu', 7);
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
SELECT enum_range(null::EStatutMateriel); --"{Reçu,Fonctionnel,""Hors service"",""Mis au rebut"",""En location""}"

--- Catamaran Hobie Cart 15 (prix materiel 1) OK
INSERT INTO Catamaran (IdCatamaran, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, 4, 'Fonctionnel', 1),
	(DEFAULT, 4, 'Fonctionnel', 1);
SELECT * FROM Catamaran;

-- Stand Up Paddle (prix materiel 3) OK
INSERT INTO StandUpPaddle (IdStandUpPaddle, NbPlaces, Statut, Capacite, IdPrixMateriel) VALUES
	(DEFAULT, 4, 'Reçu', '200l', 3),
	(DEFAULT, 4, 'Reçu', '200l', 3),
	(DEFAULT, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, 4, 'Fonctionnel', '200l', 3),
	(DEFAULT, 4, 'Hors service', '200l', 3),
	(DEFAULT, 4, 'Hors service', '200l', 3),
	(DEFAULT, 4, 'Hors service', '200l', 3);
SELECT * FROM StandUpPaddle;

--- Planche A Voile (prix materiel 2) OK
INSERT INTO PlancheAVoile (IdPlancheVoile, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --2 
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --4
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --6
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --8 
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --10
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --12
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --14
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --16
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2), --18
	(DEFAULT, 1, 'Reçu', 2), (DEFAULT, 1, 'Reçu', 2); --20
--SELECT * FROM PlancheAVoile;

-- Flotteur (Planche à Voile) OK
--SELECT enum_range(null::ECapaciteFlotteur); -- "{150l,170l,190l,205l}"
--SELECT enum_range(null::EStatutMateriel); -- "{Reçu,Fonctionnel,""Hors service"",""Mis au rebut"",""En location""}"
INSERT INTO Flotteur (IdFlotteur, IdPlancheVoile, Capacite, Statut) VALUES
	-- 7 de 150L
	(DEFAULT, 1, '150l', 'Reçu'),
	(DEFAULT, 2, '150l', 'Reçu'),
	(DEFAULT, 3, '150l', 'Fonctionnel'),
	(DEFAULT, 4, '150l', 'Fonctionnel'),
	(DEFAULT, 5, '150l', 'Hors service'),
	(DEFAULT, 6, '150l', 'Fonctionnel'),
	(DEFAULT, 7, '150l', 'Fonctionnel'),
	-- 7 de 170L
	(DEFAULT, 8, '170l', 'Reçu'),
	(DEFAULT, 9, '170l', 'Fonctionnel'),
	(DEFAULT, 10, '170l', 'Fonctionnel'),
	(DEFAULT, 11, '170l', 'Fonctionnel'),
	(DEFAULT, 12, '170l', 'Fonctionnel'),
	(DEFAULT, 13, '170l', 'Fonctionnel'),
	(DEFAULT, 14, '170l', 'En location'),
	-- 3 de 190L
	(DEFAULT, 15, '190l', 'Fonctionnel'),
	(DEFAULT, 16, '190l', 'Fonctionnel'),
	(DEFAULT, 17, '190l', 'Reçu'),
	-- 3 de 205L
	(DEFAULT, 18, '205l', 'Fonctionnel'),
	(DEFAULT, 19, '205l', 'Fonctionnel'),
	(DEFAULT, 20, '205l', 'Mis au rebut');
SELECT * FROM Flotteur;

-- Pied De Mat (Planche à Voile) OK
--SELECT enum_range(null::EStatutMateriel); -- "{Reçu,Fonctionnel,""Hors service"",""Mis au rebut"",""En location""}"
INSERT INTO PiedDeMat (IdPiedDeMat, IdPlancheVoile, Statut) VALUES
	-- 25
	(DEFAULT, 1, 'Reçu'), (DEFAULT, 10, 'Fonctionnel'), (DEFAULT, 18, 'Fonctionnel'), --3
	(DEFAULT, 2, 'Reçu'), (DEFAULT, 11, 'Fonctionnel'), (DEFAULT, 19, 'Fonctionnel'), --6
	(DEFAULT, 3, 'Reçu'), (DEFAULT, 12, 'Fonctionnel'), (DEFAULT, 20, 'Fonctionnel'), --9
	(DEFAULT, 4, 'Fonctionnel'), (DEFAULT, 13, 'Fonctionnel'), (DEFAULT, 1, 'Hors service'), --12
	(DEFAULT, 5, 'Fonctionnel'), (DEFAULT, 14, 'Fonctionnel'), (DEFAULT, 2, 'Hors service'), --15
	(DEFAULT, 6, 'Fonctionnel'), (DEFAULT, 15, 'Fonctionnel'), (DEFAULT, 3, 'Hors service'), --18
	(DEFAULT, 7, 'Fonctionnel'), (DEFAULT, 16, 'Fonctionnel'), (DEFAULT, 4, 'Hors service'), --21
	(DEFAULT, 8, 'Fonctionnel'), (DEFAULT, 17, 'Fonctionnel'), (DEFAULT, 5, 'Mis au rebut'), --24
	(DEFAULT, 9, 'Fonctionnel');
--SELECT * FROM PiedDeMat;

-- Voile (Planche à Voile) OK
--SELECT enum_range(null::ETailleVoile); -- "{3m2,4m2,4.5m2,4.9m2,5.4m2}"
--SELECT enum_range(null::EStatutMateriel); -- "{Reçu,Fonctionnel,""Hors service"",""Mis au rebut"",""En location""}"
INSERT INTO Voile (IdVoile, IdPlancheVoile, Taille, Statut) VALUES
	-- 7 de 3m2
	(DEFAULT, 1, '3m2', 'Reçu'),
	(DEFAULT, 2, '3m2', 'Reçu'),
	(DEFAULT, 3, '3m2', 'Fonctionnel'),
	(DEFAULT, 4, '3m2', 'Fonctionnel'),
	(DEFAULT, 5, '3m2', 'Fonctionnel'),
	(DEFAULT, 6, '3m2', 'Fonctionnel'),
	(DEFAULT, 7, '3m2', 'Mis au rebut'),
	-- 4 de 3m2
	(DEFAULT, 5, '4m2', 'Fonctionnel'),
	(DEFAULT, 6, '4m2', 'Fonctionnel'),
	(DEFAULT, 7, '4m2', 'Fonctionnel'),
	(DEFAULT, 8, '4m2', 'En location'),
	-- 2 de 4.5m2
	(DEFAULT, 9, '4.5m2', 'Fonctionnel'),
	(DEFAULT, 10, '4.5m2', 'Fonctionnel'),
	-- 2 de 4.9m2
	(DEFAULT, 11, '4.9m2', 'Fonctionnel'),
	(DEFAULT, 12, '4.9m2', 'Fonctionnel'),
	-- 2 de 5.4m2
	(DEFAULT, 13, '5.4m2', 'En location'),
	(DEFAULT, 14, '5.4m2', 'Mis au rebut');
--SELECT * FROM Voile;

-- Pédalo (prix materiel 4) OK
--SELECT enum_range(null::EStatutMateriel); --"{Reçu,Fonctionnel,""Hors service"",""Mis au rebut"",""En location""}"
INSERT INTO Pedalo (IdPedalo, NbPlaces, Statut, IdPrixMateriel) VALUES
	(DEFAULT, 4, 'Fonctionnel', 4),
	(DEFAULT, 4, 'Mis au rebut', 4),
	(DEFAULT, 4, 'Fonctionnel', 4),
	(DEFAULT, 4, 'Hors service', 4),
	(DEFAULT, 4, 'En location', 4),
	(DEFAULT, 4, 'Mis au rebut', 4);
--SELECT * FROM Pedalo;
	 
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
	 
ALTER TABLE CertificatMedical 
	ADD FOREIGN KEY (IdClient) REFERENCES Client(IdClient) ON DELETE CASCADE;

ALTER TABLE Forfait 
	ADD FOREIGN KEY (IdClient) REFERENCES Client(IdClient) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdPaiement) REFERENCES Paiement(IdPaiement) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdTypeForfait) REFERENCES TypeForfait(IdTypeForfait) ON DELETE CASCADE;

ALTER TABLE Diplome 
	ADD FOREIGN KEY (IdMoniteur) REFERENCES CompteEmploye(IdCompte) ON DELETE CASCADE;

ALTER TABLE PermisBateau 
	ADD FOREIGN KEY (IdPermis) REFERENCES PermisBateau(IdPermis) ON DELETE CASCADE;

ALTER TABLE Client
	ADD FOREIGN KEY (IdCertificat) REFERENCES CertificatMedical(IdCertificat) ON DELETE CASCADE;

ALTER TABLE CompteEmploye 
	ADD FOREIGN KEY (IdDiplome) REFERENCES Diplome(IdDiplome) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdPermis) REFERENCES PermisBateau(IdPermis) ON DELETE CASCADE;

ALTER TABLE Catamaran
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel) ON DELETE CASCADE;

ALTER TABLE Flotteur
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile) ON DELETE CASCADE;

ALTER TABLE Pedalo
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel) ON DELETE CASCADE;

ALTER TABLE PiedDeMat
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile) ON DELETE CASCADE;

ALTER TABLE PlancheAVoile
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel) ON DELETE CASCADE;

ALTER TABLE StandUpPaddle
	ADD FOREIGN KEY (IdPrixMateriel) REFERENCES PrixMateriel(IdPrixMateriel) ON DELETE CASCADE;
	
ALTER TABLE Voile
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile) ON DELETE CASCADE;

ALTER TABLE Location
	ADD FOREIGN KEY (IdClient) REFERENCES Client(IdClient) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdPaiement) REFERENCES Paiement(IdPaiement) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdStandUpPaddle) REFERENCES StandUpPaddle(IdStandUpPaddle) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdPedalo) REFERENCES Pedalo(IdPedalo) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdCatamaran) REFERENCES Catamaran(IdCatamaran) ON DELETE CASCADE;
	
ALTER TABLE CoursPlancheVoile
	ADD FOREIGN KEY (IdCompte) REFERENCES CompteEmploye(IdCompte) ON DELETE CASCADE;
	
ALTER TABLE Reservation
	ADD FOREIGN KEY (IdCours) REFERENCES CoursPlancheVoile(IdCours) ON DELETE CASCADE,
	ADD FOREIGN KEY (IdPlancheVoile) REFERENCES PlancheAVoile(IdPlancheVoile) ON DELETE CASCADE;
	
ALTER TABLE Participation
	ADD FOREIGN Key (IdClient) REFERENCES Client(IdClient) ON DELETE CASCADE,
	ADD FOREIGN Key (IdCours) REFERENCES CoursPlancheVoile(IdCours) ON DELETE CASCADE;
	
-- check constraints de Participation
SELECT conname AS constraint_name, 
contype AS constraint_type
FROM pg_catalog.pg_constraint cons
JOIN pg_catalog.pg_class t ON t.oid = cons.conrelid
WHERE t.relname ='participation';
