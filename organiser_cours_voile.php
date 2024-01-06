<?php
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cours de voile</title>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body>
        <?php $index_url = ''; $current_url = 'organiser_cours_voile.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>
        <?php
            // débogage, mettre en 1 pour afficher les erreurs, 0 pour les cacher
            header('Access-Control-Allow-Origin: *');
          
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));
            
            //pour la combobox des statuts de clients
            $requete="SELECT unnest(enum_range(NULL::EStatutClient)) AS EStatut";
            $listeStatutClient = pg_query($connexion, $requete);
            $statut_combobox_php= "";
            while ($row = pg_fetch_object($listeStatutClient)) {
                $statut_combobox_php .= '<option value="' . $row->estatut . '">' . $row->estatut . '</option>';
            }

            $nomsMoniteurs= pg_prepare($connexion, "my_moniteurs", 'SELECT * FROM fetch_nom_moniteur()');
            $nomsMoniteurs= pg_execute($connexion, "my_moniteurs", array());
            $moniteurs_combobox_php= "";
            while ($row = pg_fetch_object($nomsMoniteurs)) {
                $moniteurs_combobox_php .= '<option value="' . $row->id_moniteur .'">' . $row->prenom_moniteur . ' ' . $row->nom_moniteur. ' ('. $row->date_moniteur . ') </option>';
            }

        ?>
      
        <div class="corps">
            <h1>Organiser un cours de planche à voile : </h1>
            <form method="post" name="formulaire" novalidate="" class="form" action="creationCours.php">
                
                <label for="HoraireCours" class="label">Horaire :</label><br>
                <input type="datetime-local" id="HoraireCours" name="HoraireCours" required/>
                <div id="horaireError" class="error"></div><br>
                    
                <label for="NiveauCours">Niveau :</label><br>
                <select name="NiveauCours" class="form-control" id="NiveauCours" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $statut_combobox_php; ?>
                </select>
                <div id="niveauError" class="error"></div><br>

                <label for="Moniteur">Niveau :</label><br>
                <select name="Moniteur" class="form-control" id="Moniteur" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $moniteurs_combobox_php; ?>
                </select>
                <div id="moniteurError" class="error"></div><br>

                <div>
                    <button class = "button">Créer le cours</button>
                </div>
            </form>
        </div>
    </body>
</html>
<script>
    const formulaire = document.formulaire;
    formulaire.addEventListener("submit", (event) => {
        let isValid = true;

        const horaireError = document.getElementById("horaireError")

        if(formulaire.HoraireCours.validity.valid) {
            horaireError.textContent = "";
            horaireError.className = "error"
            formulaire.HoraireCours.className= "valid"
        } else {
            horaireError.textContent = "Veuillez renseigner un horaire pour le cours."
            horaireError.className = "error active"
            formulaire.HoraireCours.className= "invalid"
            isValid = false;
        }

        const niveauError = document.getElementById("niveauError")

        if(formulaire.NiveauCours.validity.valid) {
            niveauError.textContent = "";
            niveauError.className = "error"
            formulaire.NiveauCours.className= "valid"
        } else {
            niveauError.textContent = "Veuillez renseigner le prénom du client."
            niveauError.className = "error active"
            formulaire.NiveauCours.className= "invalid"
            isValid = false;
        }

        const moniteurError = document.getElementById("moniteurError")

        if(formulaire.Moniteur.validity.valid) {
            moniteurError.textContent = "";
            moniteurError.className = "error"
            formulaire.Moniteur.className= "valid"
        } else {
            moniteurError.textContent = "Veuillez renseigner la date de naissance du client."
            moniteurError.className = "error active"
            formulaire.Moniteur.className= "invalid"
            isValid = false;
        }

        if(!isValid) {
            event.preventDefault();
        }
    });
</script>