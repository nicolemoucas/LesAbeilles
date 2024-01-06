<!DOCTYPE html>
<html>
<?php
    // Start the session
    session_start();
?>
    <link rel="stylesheet" type="text/css" href="css/inscription.css" />
    <link rel="stylesheet" href="css/styles.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- pour jQuery -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inscription de matériel</title>
    </head>
    <body>
        <?php $index_url = ''; $current_url = 'inscriptionMateriel.php'; ?>
        <header>
            <?php include('header.php')?>
        </header>
        <?php
            // débogage, mettre en 1 pour afficher les erreurs, 0 pour les cacher
            header('Access-Control-Allow-Origin: *');
          
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));
            
            //pour la combobox des rôles des employés
            $listeMateriel = pg_query($connexion, "SELECT DISTINCT \"Nom matériel\" AS nommat FROM v_stock_materiel;");
            if(!$listeMateriel) {
                echo "Le type de matériel n'a pas pu être récupéré.";
            }
            else {
                $materiel_combobox_php = "";
                while ($row = pg_fetch_object($listeMateriel)) {
                    $materiel_combobox_php .= '<option value="' . $row->nommat . '">' . $row->nommat . '</option>';
                }
            }

            //pour la combobox des tailles des voiles
            $requete = "SELECT unnest(enum_range(NULL::ETailleVoile)) AS EVoile";
            $listeTailleVoiles = pg_query($connexion, $requete);
            $taille_voiles_combobox_php = "";
            while ($option = pg_fetch_object($listeTailleVoiles)) {
                $selected = $option->evoile == $row->taillevoile ? ' selected' : '';
                $taille_voiles_combobox_php .= '<option value="' . $option->evoile . '"' . $selected . '>' . $option->evoile . '</option>';
            }

            //pour la combobox des capacités des flotteurs
            $requete = "SELECT unnest(enum_range(NULL::ECapaciteFlotteur)) AS ECapFlot";
            $listeCapacitesFlotteurs = pg_query($connexion, $requete);
            $capacite_flotteur_combobox_php = "";
            while ($option = pg_fetch_object($listeCapacitesFlotteurs)) {
                $selected = $option->ecapflot == $row->capaciteflot ? ' selected' : '';
                $capacite_flotteur_combobox_php .= '<option value="' . $option->ecapflot . '"' . $selected . '>' . $option->ecapflot . '</option>';
            }

            
        ?>
      
        <div class="corps">
            <h1>Formulaire de création du profil client :</h1>
            <p>* Champs obligatoires</p>
            <form method="post" name="live_form" id="live_form" novalidate="" class="form" action="creationMateriel.php">
                
                <div>
                    <label for="TypeMateriel">Type Matériel *</label><br>
                    <select name="TypeMateriel" class="form-control" id="TypeMateriel" required>
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $materiel_combobox_php; ?>
                        <div id="typeMaterielError" class="error"></div>
                    </select>
                </div>
                <br>
                <div class="formHiddenField form-group" id="NbPlacesDiv">
                    <label for="NbPlaces" class="label">Nombre de places *</label><br>
                    <input type="text" id="NbPlaces" name="NbPlaces" placeholder="Ex : 1, 2, 3, ..."/>
                    <div id="nbPlacesError" class="error"></div>
                </div>
                <br>

                <div class="formHiddenField form-group" id="CapaciteSUPDiv">
                    <label for="CapaciteSUP" class="label">Capacité * (entre 100 et 999 l)</label><br>
                    <input type="text" id="CapaciteSUP" name="CapaciteSUP" placeholder="Ex : 150l, 250l, ..." pattern="[0-9]{3}l"/>
                    <div id="capaciteSUPError" class="error"></div>
                </div>
                <br>
                
                <div class="formHiddenField form-group" id="CapaciteFlotteurDiv">
                <label for="CapaciteFlotteur">Capacité *</label><br>
                    <select name="CapaciteFlotteur" class="form-control" id="CapaciteFlotteur" value= "<?php echo $row->capaciteflot ?>" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $capacite_flotteur_combobox_php; ?>
                    </select>
                    <div id="capaciteFlotteurError" class="error"></div><br>
                </div>
                <br>

                <div class="formHiddenField form-group" id="TailleVoileDiv">
                <label for="TailleVoile">Taille *</label><br>
                    <select name="TailleVoile" class="form-control" id="TailleVoile" value= "<?php echo $row->taillevoile ?>" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $taille_voiles_combobox_php; ?>
                    </select>
                    <div id="tailleVoileError" class="error"></div><br>
                </div>
                <br>

                <div>
                    <button class = "button">Enregistrer le matériel</button>
                </div>
            </form>
        </div>

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
<script>
    $( document ).ready(function() {
        var typeMateriel = document.getElementById("TypeMateriel");
        var nbPlaces = document.getElementById("NbPlacesDiv");
        var capaciteSUP = document.getElementById("CapaciteSUPDiv");
        var capaciteFlotteur = document.getElementById("CapaciteFlotteurDiv");
        var tailleVoile = document.getElementById("TailleVoileDiv");

        $("#TypeMateriel").on('change', function (e) {
            var value=this.value;
            console.log("val "+value);
            if (value == 'Catamaran' || value == 'Pédalo' || value == 'Stand Up Paddle'){
                nbPlaces.classList.remove('formHiddenField');
            }
            if (value == 'Stand Up Paddle'){
                capaciteSUP.classList.remove('formHiddenField');
            }
            if (value == 'Flotteur'){
                capaciteFlotteur.classList.remove('formHiddenField');
            }
            if (value == 'Voile'){
                tailleVoile.classList.remove('formHiddenField');
            }
        });
    });

    const formulaire = document.live_form;
    console.log("form"+formulaire);
    formulaire.addEventListener("submit", (event) => {
        let isValid = true;
        console.log(isValid);

        const typeMaterielError = document.getElementById("typeMaterielError");
        if(formulaire.TypeMateriel.validity.valid) {
            typeMaterielError.textContent = "";
            typeMaterielError.className = "error";
            formulaire.TypeMateriel.className= "valid";
        } else {
            typeMaterielError.textContent = "Veuillez renseigner le type de matériel.";
            typeMaterielError.className = "error active";
            formulaire.TypeMateriel.className= "invalid";
            isValid = false;
        }

        const nbPlacesError = document.getElementById("nbPlacesError");
        if(formulaire.NbPlaces.validity.valid) {
            nbPlacesError.textContent = "";
            nbPlacesError.className = "error";
            formulaire.NbPlaces.className= "valid";
        } else {
            nbPlacesError.textContent = "Veuillez renseigner le nombre de places.";
            nbPlacesError.className = "error active";
            formulaire.NbPlaces.className= "invalid";
            isValid = false;
        }

        const capaciteSUPError = document.getElementById("capaciteSUPError");
        if(formulaire.CapaciteSUP.validity.valid) {
            capaciteSUPError.textContent = "";
            capaciteSUPError.className = "error";
            formulaire.CapaciteSUP.className= "valid";
        } else {
            capaciteSUPError.textContent = "Veuillez renseigner la capacité du Stand Up Paddle.";
            capaciteSUPError.className = "error active";
            formulaire.CapaciteSUP.className= "invalid";
            isValid = false;
        }

        const capaciteFlotteurError = document.getElementById("capaciteFlotteurError");
        if(formulaire.CapaciteSUP.validity.valid) {
            capaciteFlotteurError.textContent = "";
            capaciteFlotteurError.className = "error";
            formulaire.CapaciteFlotteur.className= "valid";
        } else {
            capaciteFlotteurError.textContent = "Veuillez renseigner la capacité du Flotteur.";
            capaciteFlotteurError.className = "error active";
            formulaire.CapaciteFlotteur.className= "invalid";
            isValid = false;
        }

        const tailleVoileError = document.getElementById("tailleVoileError");
        if(formulaire.TailleVoile.validity.valid) {
            tailleVoileError.textContent = "";
            tailleVoileError.className = "error";
            formulaire.TailleVoile.className= "valid";
        } else {
            tailleVoileError.textContent = "Veuillez renseigner la taille de la Voile.";
            tailleVoileError.className = "error active";
            formulaire.CapaTailleVoileciteSUP.className= "invalid";
            isValid = false;
        }

        if(!isValid) {
            event.preventDefault();
        }
    }, true);
</script>