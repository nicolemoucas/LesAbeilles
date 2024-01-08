<!DOCTYPE html>
<html>
<?php
    // Start the session
    session_start();
?>
    <link rel="stylesheet" type="text/css" href="css/inscription.css" />
    <link rel="stylesheet" href="css/styles.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title> Création d'un profil client </title>
    </head>
    <body>
        <header>
            <?php include('header.php')?>
        </header>
        <?php
            // débogage, mettre en 1 pour afficher les erreurs, 0 pour les cacher
            header('Access-Control-Allow-Origin: *');
          
            ini_set('display_errors', 0);
            ini_set('display_startup_errors', 0);
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));
            
            //pour la combobox des noms de campings
            $requete = "SELECT unnest(enum_range(NULL::ECamping)) AS ECamp";
            $listeCampings = pg_query($connexion, $requete);
            $campings_combobox_php = "";
            while ($row = pg_fetch_object($listeCampings)) {
                $campings_combobox_php .= '<option value="' . $row->ecamp . '">' . $row->ecamp . '</option>';
            }

            //pour la combobox des préférences de contact
            $requete="SELECT unnest(enum_range(NULL::EPreferenceContact)) AS EPrefContact";
            $listePrefContact = pg_query($connexion, $requete);
            $prefContact_combobox_php= "";
            while ($row = pg_fetch_object($listePrefContact)) {
                $prefContact_combobox_php .= '<option value="' . $row->eprefcontact . '">' . $row->eprefcontact . '</option>';
            }
            
            //pour la combobox des statuts de clients
            $requete="SELECT unnest(enum_range(NULL::EStatutClient)) AS EStatut";
            $listeStatutClient = pg_query($connexion, $requete);
            $statut_combobox_php= "";
            while ($row = pg_fetch_object($listeStatutClient)) {
                $statut_combobox_php .= '<option value="' . $row->estatut . '">' . $row->estatut . '</option>';
            }
        ?>
      
        <div class="corps">
            <h1>Formulaire de création du profil client :</h1>
            <p>* Champs obligatoires</p>
            <form method="post" name="formulaire" novalidate="" class="form" action="creationProfilClient.php">

                <label for="NomClient" class="label">NOM *</label><br>
                <input type="text" id="NomClient" name="NomClient" placeholder="Ex : BOULANGER" required/>
                <div id="nomError" class="error"></div><br>
                    
                <label for="PrenomClient">Prénom *</label><br>
                <input type="text" id="PrenomClient" name="PrenomClient" placeholder="Ex : Jean Michel" required/>
                <div id="prenomError" class="error"></div><br>

                <label for="DateNaissanceClient">Date de naissance *</label><br>
                <input type="date" id="DateNaissanceClient" name= "DateNaissanceClient" placeholder="Ex : 08/01/1975" required/>
                <div id="dateNaisError" class="error"></div><br>

                <label for="MailClient">Email</label><br>
                <input type="email" id="MailClient" name="MailClient" placeholder="Ex : boulangerjm@free.fr"/><br><br>

                <label for="TelClient" pattern="0[0-9]{9}">Numéro de téléphone</label><br>
                <input type="text" id="TelClient" name="TelClient" placeholder="Ex : 0777764231"/><br><br>
                
                <div>
                    <label for="PrefContactClient">Préférence de contact *</label><br>
                    <select name="PrefContactClient" class="form-control" id="PrefContactClient" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $prefContact_combobox_php; ?>
                    </select>
                    <div id="prefContactError" class="error"></div><br>
                </div>
                
                <div>
                <label for="CampingClient">Camping *</label><br>
                    <select name="CampingClient" class="form-control" id="CampingClient" required>
                    <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $campings_combobox_php; ?>
                    </select><br><br>
                </div>

                <label for="TailleClient">Taille (en cm) *</label>
                <input type="number" min=0 id="TailleClient" name="TailleClient" placeholder="Ex : 170" required/>
                <div id="tailleError" class="error"></div><br>

                <label for="PoidsClient">Poids (en kg) *</label>
                <input type="number" min=0 id="PoidsClient" name="PoidsClient" placeholder="Ex : 80" required/>
                <div id="poidsError" class="error"></div><br>

                <div>
                <label for="StatutClient">Niveau sportif *</label><br>
                    <select name="StatutClient" class="form-control" id="StatutClient" required>
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $statut_combobox_php; ?>
                    </select> 
                    <div id="statutError" class="error"></div><br>
                </div>
                <div>
                    <button class = "button">Créer le client</button>
                </div>
            </form>
        </div>

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
<script>
    const formulaire = document.formulaire;
    formulaire.addEventListener("submit", (event) => {
        let isValid = true;

        if((!formulaire.MailClient.value) &&(!formulaire.TelClient.value)) {
            alert("Il faut renseigner un email ou un numéro de téléphone.")
            formulaire.MailClient.className="invalid"
            formulaire.TelClient.className="invalid"
            isValid = false;
        }

        const nomError = document.getElementById("nomError")

        if(formulaire.NomClient.validity.valid) {
            nomError.textContent = "";
            nomError.className = "error"
            formulaire.NomClient.className= "valid"
        } else {
            nomError.textContent = "Veuillez renseigner le nom du client."
            nomError.className = "error active"
            formulaire.NomClient.className= "invalid"
            isValid = false;
        }

        const prenomError = document.getElementById("prenomError")

        if(formulaire.PrenomClient.validity.valid) {
            prenomError.textContent = "";
            prenomError.className = "error"
            formulaire.PrenomClient.className= "valid"
        } else {
            prenomError.textContent = "Veuillez renseigner le prénom du client."
            prenomError.className = "error active"
            formulaire.PrenomClient.className= "invalid"
            isValid = false;
        }

        const dateNaisError = document.getElementById("dateNaisError")

        if(formulaire.DateNaissanceClient.validity.valid) {
            dateNaisError.textContent = "";
            dateNaisError.className = "error"
            formulaire.DateNaissanceClient.className= "valid"
        } else {
            dateNaisError.textContent = "Veuillez renseigner la date de naissance du client."
            dateNaisError.className = "error active"
            formulaire.DateNaissanceClient.className= "invalid"
            isValid = false;
        }

        const tailleError = document.getElementById("tailleError")

        if(formulaire.TailleClient.validity.valid) {
            tailleError.textContent = "";
            tailleError.className = "error"
            formulaire.TailleClient.className= "valid"
        } else {
            tailleError.textContent = "Veuillez renseigner la taille du client."
            tailleError.className = "error active"
            formulaire.TailleClient.className= "invalid"
            isValid = false;
        }

        const poidsError = document.getElementById("poidsError")

        if(formulaire.PoidsClient.validity.valid) {
            poidsError.textContent = "";
            poidsError.className = "error"
            formulaire.PoidsClient.className= "valid"
        } else {
            poidsError.textContent = "Veuillez renseigner le poids du client."
            poidsError.className = "error active"
            formulaire.PoidsClient.className= "invalid"
            isValid = false;
        }

        const statutError = document.getElementById("statutError")

        if(formulaire.StatutClient.validity.valid) {
            statutError.textContent = "";
            statutError.className = "error"
            formulaire.StatutClient.className= "valid"
        } else {
            statutError.textContent = "Veuillez sélectionner un niveau sportif."
            statutError.className = "error active"
            formulaire.StatutClient.className= "invalid"
            isValid = false;
        }

        const prefContactError = document.getElementById("prefContactError")

        if(formulaire.PrefContactClient.validity.valid) {
            prefContactError.textContent = "";
            prefContactError.className = "error"
            formulaire.PrefContactClient.className= "valid"
        } else {
            prefContactError.textContent = "Veuillez sélectionner une option."
            prefContactError.className = "error active"
            formulaire.PrefContactClient.className= "invalid"
            isValid = false;
        }

        if(!isValid) {
            event.preventDefault();
        }
});
</script>