/* Constraintes unique */

/* 1- Contrainte d'unicité pour le nom, prénom et mail de CompteEmploye : */
ALTER TABLE CompteEmploye
ADD CONSTRAINT unique_nom_prenom_mail UNIQUE (Nom, Prenom, Mail);

/* 2- Contrainte d'unicité pour le nom, identifiant et mot de passe de CompteEmploye :*/
ALTER TABLE CompteEmploye
ADD CONSTRAINT unique_nom_identifiant_mdp UNIQUE (Nom, NomUtilisateur, MotDePasse);

/* 3- Contrainte d'unicité pour le nom, prénom et date de naissance de Client :*/
ALTER TABLE Client
ADD CONSTRAINT unique_nom_prenom_date_naissance UNIQUE (Nom, Prenom, DateNaissance);

/* 4- Contrainte qui vérifie que le client a au moins 8 ans */
ALTER TABLE Client
ADD CONSTRAINT check_date_naissance CHECK (DateNaissance <= CURRENT_DATE - INTERVAL '8 years');

/* 5- Vérification format Numéro */
/*ALTER TABLE telephone
ADD CONSTRAINT check_numero CHECK (numero ~ '^[0-9]{10}$');*/

/* 6- Contrainte UNIQUE sur l'email des clients : */
/*ALTER TABLE Client 
ADD CONSTRAINT unique_email CHECUNIQUE (Mail);*/



/* Contraintes check */

/* 1- Contrainte de vérification prix dans un type de forfait doit être positif :  */
ALTER TABLE TypeForfait
ADD CONSTRAINT check_prix_positive CHECK (Prix >= 0);

/* 2- Contrainte de vérification pour le nombre de séances dans un type de forfait : */
ALTER TABLE TypeForfait
ADD CONSTRAINT check_nb_seances_positive CHECK (NbSeances >= 0);

/* 3- Contrainte de vérification sur la plage de taille des clients */
ALTER TABLE Client 
ADD CONSTRAINT check_taille CHECK (Taille >= 0);

/* 4- Contrainte de vérification sur la date d'obtention des diplômes : */
ALTER TABLE Diplome 
ADD CONSTRAINT check_date_obtention CHECK (DateObtention <= CURRENT_DATE);

/* 5- Contrainte de vérification sur les dates de réservation des cours de planche à voile : */
/*ALTER TABLE CoursPlancheVoile 
ADD CONSTRAINT check_date_cours CHECK (DateHeure >= CURRENT_DATE);*/

/* 6- Contrainte vérification états des cours */
--SELECT * FROM CoursPlancheVoile;
--SELECT enum_range(null::EEtatCours); --"{Prévu,"En cours",Réalisé,Annulé}"
-- les cours passés sont soit réalisés, soit annulés
ALTER TABLE CoursPlancheVoile 
ADD CONSTRAINT check_etat_cours CHECK (
	(DateHeure >= CURRENT_DATE AND (etatCours = 'Réalisé' OR etatCours = 'Annulé'))
	OR
	(DateHeure < CURRENT_DATE));


/* Contraintes avec Trigger */

/* 1- Le Nombre de séances restantes doi être <= nb séances du forfait */
CREATE OR REPLACE FUNCTION check_forfait_nbseances()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.NbSeancesRestantes < 0 OR NEW.NbSeancesRestantes > (SELECT NbSeances FROM TypeForfait WHERE IdTypeForfait = NEW.IdTypeForfait) THEN
        RAISE EXCEPTION 'Erreur : le nombre de séances restante doit être compris entre 0 et le nombre total de séances du forfait.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger avant chaque insertion ou update de la table Forfait
CREATE TRIGGER check_forfait_nbseances_trigger
BEFORE INSERT OR UPDATE
ON Forfait
FOR EACH ROW
EXECUTE FUNCTION check_forfait_nbseances();

/* 2- Lorsqu’un materiel est au rebut ou hors service la location de ce matériel doit-être impossible:*/
CREATE OR REPLACE FUNCTION check_location_materiel()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.IdFlotteur IS NOT NULL AND EXISTS (
        SELECT 1
        FROM Flotteur f
        WHERE (f.IdFlotteur = NEW.IdFlotteur OR f.IdPlancheVoile = NEW.IdPlancheVoile)
          AND f.Statut IN ('Mis au rebut', 'Hors service')
    ) THEN
        RAISE EXCEPTION 'Le matériel Flotteur est au rebut ou hors service.';
    END IF;

    IF NEW.IdPiedDeMat IS NOT NULL AND EXISTS (
        SELECT 1
        FROM PiedDeMat pm
        WHERE pm.IdPiedDeMat = NEW.IdPiedDeMat
          AND pm.Statut IN ('Mis au rebut', 'Hors service')
    ) THEN
        RAISE EXCEPTION 'Le matériel Pied de mat est au rebut ou hors service.';
    END IF;

    IF NEW.IdVoile IS NOT NULL AND EXISTS (
        SELECT 1
        FROM Voile v
        WHERE v.IdVoile = NEW.IdVoile
          AND v.Statut IN ('Mis au rebut', 'Hors service')
    ) THEN
        RAISE EXCEPTION 'Le matériel Voile est au rebut ou hors service.';
    END IF;

    IF NEW.IdCatamaran IS NOT NULL AND EXISTS (
        SELECT 1
        FROM Catamaran c
        WHERE c.IdCatamaran = NEW.IdCatamaran
          AND c.Statut IN ('Mis au rebut', 'Hors service')
    ) THEN
        RAISE EXCEPTION 'Le matériel Catamaran est au rebut ou hors service.';
    END IF;

    IF NEW.IdStandUpPaddle IS NOT NULL AND EXISTS (
        SELECT 1
        FROM StandUpPaddle s
        WHERE s.IdStandUpPaddle = NEW.IdStandUpPaddle
          AND s.Statut IN ('Mis au rebut', 'Hors service')
    ) THEN
        RAISE EXCEPTION 'Le matériel Stand Up Paddle est au rebut ou hors service.';

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER location_materiel_trigger
BEFORE INSERT OR UPDATE
ON Location
FOR EACH ROW
EXECUTE FUNCTION check_location_materiel();

/* 3- L'état du cours ne peut passer à annulé que s'il est prévu */
CREATE OR REPLACE FUNCTION check_annulation_cours()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.etatCours != 'Prévu' AND NEW.etatCours = 'Annulé' THEN
        RAISE EXCEPTION 'Erreur : le cours ne peut pas être annulé.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger avant chaque update de la table Cours planche à voile
DROP TRIGGER IF EXISTS check_annulation_cours ON CoursPlancheVoile;
CREATE TRIGGER check_annulation_cours
BEFORE UPDATE
ON CoursPlancheVoile
FOR EACH ROW
EXECUTE FUNCTION check_annulation_cours();






