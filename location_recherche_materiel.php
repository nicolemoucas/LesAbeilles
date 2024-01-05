<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/inscription.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">   
        <title>Profil client</title>
        <script>
            
            function redirectionProprietaire() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }

            function redirectionMoniteur() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilMoniteur.php';
            }

            function redirection(role){
                switch (role) {
                    case 'Propriétaire':
                        redirectionProprietaire();
                        break;
                    case 'Moniteur':
                        redirectionMoniteur();
                        break;
                }
            }
            function alertClientExists(role) {
                alert("Ce client n'existe pas. Vous serez redirigé sur l'écran d'accueil.");
                switch (role) {
                    case 'Propriétaire':
                        redirectionProprietaire();
                        break;
                    case 'Moniteur':
                        redirectionMoniteur();
                        break;
                }
            }
        </script>
    </head>
    <body>
        <header>
            <?php include('header.php')?>
        </header>
        
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

            $nomClient = $_POST["NomClient"];
            $prenomClient = $_POST["PrenomClient"];
            $dateNaissClient = $_POST["DateNaissanceClient"];
    
            $recupClient = pg_prepare($connexion, "recup_client", 'SELECT * FROM recherche_client($1,$2,$3)');
            $recupClient = pg_execute($connexion, "recup_client", array($nomClient, $prenomClient, $dateNaissClient)); 

            if(pg_num_rows($recupClient) == 0) {
                echo '<script type="text/javascript"> alertClientExists("'.$_SESSION["role"].'"); </script>';
            } else {
                $row = pg_fetch_object($recupClient);
                
            }

            //pour la combobox des capacités de flotteurs
            $requete="SELECT unnest(enum_range(NULL::ECapaciteFlotteur)) AS Ecap";
            $listeCapacite = pg_query($connexion, $requete);
            $capacite_combobox_php= "";
            while ($option = pg_fetch_object($listeCapacite)) {
                $capacite_combobox_php .= '<option value="' . $option->ecap . '">' . $option->ecap . '</option>';
            }

             //pour la combobox des capacités de flotteurs
             $requete="SELECT unnest(enum_range(NULL::ETailleVoile)) AS etv";
             $listeTailleVoile = pg_query($connexion, $requete);
             $taille_combobox_php= "";
             while ($option = pg_fetch_object($listeTailleVoile)) {
                 $taille_combobox_php .= '<option value="' . $option->etv . '">' . $option->etv . '</option>';
             }
        ?>
<div class="form-row">
    <div class="form-column">
        <h1>Profil client : <?php echo $row->prenomcl . ' ' .$row->nomcl?></h1>
         
    <label for="NomClient" class="label">NOM</label><br>
        <input readonly type="text" id="NomClient" name="NomClient" value= "<?php echo $row->nomcl ?>" required/>
        <br><br>
        <label for="PrenomClient">Prénom</label><br>
        <input readonly type="text" id="PrenomClient" name="PrenomClient" placeholder="Ex : Jean Michel" value= "<?php echo $row->prenomcl ?>" required/>
        <br><br>

        <label for="DateNaissanceClient">Date de naissance</label><br>
        <input readonly type="text" id="DateNaissanceClient" name= "DateNaissanceClient" value= "<?php echo $row->datenaissancecl ?>" required/><br><br>

        <label for="MailClient"> Email </label><br>
        <input readonly type="text" id="MailClient" name="MailClient"value= "<?php echo $row->mailcl ?>" /><br><br>

        <label for="TelClient" pattern="0[0-9]{9}"  >Numéro de téléphone</label><br>
        <input readonly type="text" id="TelClient" name="TelClient" value="<?php echo $row->numtelephonecl ?>"/><br><br>

        <label for="PrefContactClient">Préférence de contact</label><br>
        <input readonly type="text" id="PrefContactClient" name="PrefContactClient" value="<?php echo $row->preferencecontactcl?>" /><br><br>

    
        <label for="CampingClient">Camping</label><br>
        <input readonly type="text" id="CampingClient" name="CampingClient" value="<?php echo $row->campingcl?>" /><br><br>

        <label for="TailleClient">Taille (en cm)</label>
        <input readonly type="text"  id="TailleClient" name="TailleClient" value= "<?php echo $row->taillecl ?>" /><br><br>
        
        <label for="PoidsClient">Poids (en kg)</label>
        <input readonly type="text" id="PoidsClient" name="PoidsClient" value="<?php echo $row->poidscl ?>" /><br><br>

        <label for="StatutClient">Niveau sportif</label><br>
        <input readonly type="text" id="CampingClient" name="CampingClient" value="<?php echo $row->statutcl?>" /><br><br>

        </div>
        <div class="form-column">
        <h1>Choix du type de matériel</h1>
        <form method="post" name="formulaire" novalidate="" class="form" action="enregistrer_location.php">
            <label for="typeMatériel"> Type de matériel</label><br>
                <select name="typeMatériel" class="form-control" id="typeMatériel" required >
                    <option disabled selected value> -- Sélectionnez une option -- </option>
                    <option value="Catamaran"> Catamaran</option>
                    <option value="Pédalo"> Pédalo </option>
                    <option value="Planche à voile"> Planche à voile </option>
                    <option value="Stand-up Paddle"> Stand-up Paddle </option>
                </select>
                <div id="typeError" class="error"></div><br>




            <label for="CapaciteFlotteur">Capacité du flotteur</label><br>
            <select name="CapaciteFlotteur" class="form-control" id="CapaciteFlotteur">
            <option disabled selected value> -- Sélectionnez une option -- </option>
                <?php echo $capacite_combobox_php ?>
            </select>
            <div id="capaciteError" class="error"></div><br>


            <label for="TailleVoile">Taille de la Voile</label><br>
            <select name="TailleVoile" class="form-control" id="TailleVoile">
            <option disabled selected value> -- Sélectionnez une option -- </option>
                <?php echo $taille_combobox_php ?>
            </select>
            <div id="tailleError" class="error"></div><br>



            <h1> Choix de l'horaire</h1>
        <label for="HoraireLoc" class="label">Horaire :</label><br>
        <input type="datetime-local" id="HoraireLoc" name="HoraireLoc" required/>
        <div id="horaireError" class="error"></div><br>
        
        <label for="NbHeure" class="label">Nombre d'heures de location</label><br>
        <input type="number" id="NbHeure" name="NbHeure" required/>
        <div id="nbError" class="error"></div><br>
        <button class = "button">Enregistrer Location</button>
            </form>
            
        </div>
</div>

        <footer>
            <?php include('footer.php')?>
        </footer>


        <script>
    document.addEventListener("DOMContentLoaded", function() {
        const typeMatérielSelect = document.getElementById("typeMatériel");
        const capaciteFlotteurDiv = document.getElementById("capaciteFlotteurDiv");
        const tailleVoileDiv = document.getElementById("tailleVoileDiv");

        typeMatérielSelect.addEventListener("change", function() {
            const selectedValue = typeMatérielSelect.value;

            // Afficher ou masquer les onglets en fonction du type de matériel sélectionné
            capaciteFlotteurDiv.style.display = (selectedValue === "Planche à voile") ? "block" : "none";
            tailleVoileDiv.style.display = (selectedValue === "Planche à voile") ? "block" : "none";
        });
    });

    
    </script>

    </body>
</html>
<script>
    const formulaire = document.formulaire;
    formulaire.addEventListener("submit", (event) => {
        let isValid = true;
  console.log('coucou');
        const typeError = document.getElementById("typeError")

        if(formulaire.typeMatériel.validity.valid) {
            typeError.textContent = "";
            typeError.className = "error"
            formulaire.typeMatériel.className= "valid"
        } else {
            typeError.textContent = "Veuillez renseigner le type de matériel."
            typeError.className = "error active"
            formulaire.typeMatériel.className= "invalid"
            isValid = false;
        }

        const capaciteError = document.getElementById("capaciteError")

        if(formulaire.typeMatériel.value === "Planche à voile" && formulaire.CapaciteFlotteur.value && formulaire.CapaciteFlotteur.value.valid) {
            capaciteError.textContent = "";
            capaciteError.className = "error"
            formulaire.CapaciteFlotteur.className= "valid"
        } else {
            capaciteError.textContent = "Veuillez renseigner la capacité du flotteur souhaitée."
            capaciteError.className = "error active"
            formulaire.CapaciteFlotteur.className= "invalid"
            isValid = false;
        }

        const tailleError = document.getElementById("tailleError")

        if(formulaire.typeMatériel.value === "Planche à voile" && formulaire.TailleVoile.value && formulaire.TailleVoile.value.valid) {
            tailleError.textContent = "";
            tailleError.className = "error"
            formulaire.TailleVoile.className= "valid"
        } else {
            tailleError.textContent = "Veuillez renseigner la taille de la voile souhaitée."
            tailleError.className = "error active"
            formulaire.TailleVoile.className= "invalid"
            isValid = false;
        }

        const horaireError = document.getElementById("horaireError")

        if(formulaire.HoraireLoc.value.valid) {
            horaireError.textContent = "";
            horaireError.className = "error"
            formulaire.HoraireLoc.className= "valid"
        } else {
            horaireError.textContent = "Veuillez renseigner l'horaire de la location."
            horaireError.className = "error active"
            formulaire.HoraireLoc.className= "invalid"
            isValid = false;
        }
        const nbError = document.getElementById("nbError")

        if(formulaire.NbHeure.value.valid) {
            nbError.textContent = "";
            nbError.className = "error"
            formulaire.TailleVoile.className= "valid"
        } else {
            nbError.textContent = "Veuillez renseigner le nombre d'heures de location souhaités."
            nbError.className = "error active"
            formulaire.NbHeure.className= "invalid"
            isValid = false;
        }

        if(!isValid) {
            event.preventDefault();
        }
});

