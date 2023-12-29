/* Constraintes unique */



/* Constraintes check */

/* Nombre de séances restantes <= nb séances du forfait */
CREATE OR REPLACE FUNCTION check_forfait_nbseances()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.NbSeancesRestantes < 0 OR NEW.NbSeancesRestantes > (SELECT NbSeances FROM TypeForfait WHERE IdTypeForfait = NEW.IdTypeForfait) THEN
        RAISE EXCEPTION 'Erreur : le nombre de séances restante doit être compris entre 0 et le nombre total de séances du forfait.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger avant chaque insertion ou updte de la table Forfait
CREATE TRIGGER check_forfait_nbseances_trigger
BEFORE INSERT OR UPDATE
ON Forfait
FOR EACH ROW
EXECUTE FUNCTION check_forfait_nbseances();
