<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html>
    <link rel="stylesheet" type="text/css" href="css/inscription.css" />
    <link rel="stylesheet" href="css/styles.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css" /> <!--icon for password-->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title> Création d'un profil Garçon de plage</title>
    </head>
    <body>
        <?php $index_url = ''; $current_url = 'inscriptionGarcon.php'; ?>
        <header>
            <?php include('header.php')?>
        </header>
        <?php
            // débogage, mettre en 1 pour afficher les erreurs, 0 pour les cacher
            header('Access-Control-Allow-Origin: *');
            ini_set('display_errors', 0);
            ini_set('display_startup_errors', 0);
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            //pour la combobox des préférences de contact
            $requete="SELECT unnest(enum_range(NULL::EPreferenceContact)) AS EPrefContact";
            $listePrefContact = pg_query($connexion, $requete);
            $prefContact_combobox_php= "";
            while ($row = pg_fetch_object($listePrefContact)) {
                $prefContact_combobox_php .= '<option value="' . $row->eprefcontact . '">' . $row->eprefcontact . '</option>';
            }

        ?>
      
        <div class="corps">
            <h1>Formulaire de création du profil Garçon de plage :</h1>
            <p>* Champs obligatoires</p>
            <form method="post" name="formulaire" novalidate="" class="form" action="creationProfilGarconDePlage.php">-

                <label for="NomGarconPlage" class="label">NOM *</label><br>
                <input type="text" id="NomGarconPlage" name="NomGarconPlage" placeholder="Ex : BOULANGER" required/>
                <div id="nomError" class="error"></div><br>
                    
                <label for="PrenomGarconPlage">Prénom *</label><br>
                <input type="text" id="PrenomGarconPlage" name="PrenomGarconPlage" placeholder="Ex : Jean Michel" required/>
                <div id="prenomError" class="error"></div><br>
                    
                <label for="NomUtilisateur">Nom utilisateur *</label><br>
                <input type="text" id="NomUtilisateur" name="NomUtilisateur" placeholder="Ex : jmichel" required/>
                <div id="nomUtilisateurError" class="error"></div><br>
                
                <div id="inputMDP">
                    <label for="MotDePasse">Mot de passe *</label><br>
                    <input type="password" id="MotDePasse" name="MotDePasse" placeholder="Ex : monMotDePasse1" required></input>
                    <i class="bi bi-eye-slash" id="togglePassword"></i>
                    <div id="motDePasseError" class="error"></div><br>
                </div>

                <label for="DateNaissanceGarconPlage">Date de naissance *</label><br>
                <input type="date" id="DateNaissanceGarconPlage" name= "DateNaissanceGarconPlage" placeholder="Ex : 08/01/1975" required/>
                <div id="dateNaisError" class="error"></div><br>

                <label for="MailGarconPlage">Email</label><br>
                <input type="email" id="MailGarconPlage" name="MailGarconPlage" placeholder="Ex : boulangerjm@free.fr"/><br><br>

                <label for="TelGarconPlage" pattern="0[0-9]{9}">Numéro de téléphone</label><br>
                <input type="text" id="TelGarconPlage" name="TelGarconPlage" placeholder="Ex : 0777764231"/><br><br>

                <div class="preferenceContactEmploye">
                    <label for="PrefContactGarconPlage">Préférence de contact *</label><br>
                    <select name="PrefContactGarconPlage" class="form-control" id="PrefContactGarconPlage" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $prefContact_combobox_php; ?>
                    </select>
                    <div id="prefContactError" class="error"></div>
                </div><br>

                <div class="DocumentPDFEmploye">
                    
                </div>    
                <br><br>

                <div>
                    <button class = "button">Créer le garçon de plage</button>
                </div>
            </form>
        </div>

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
<script>
    // Show/hide password
    const togglePassword = document.querySelector("#togglePassword");
    const password = document.querySelector("#MotDePasse");

    togglePassword.addEventListener("click", function () {
        // toggle the type attribute
        const type = password.getAttribute("type") === "password" ? "text" : "password";
        password.setAttribute("type", type);
        
        // toggle the icon
        this.classList.toggle("bi-eye");
    });

    const formulaire = document.formulaire;
    formulaire.addEventListener("submit", (event) => {
        let isValid = true;

        if((!formulaire.MailGarconPlage.value) && (!formulaire.TelGarconPlage.value)) {
            alert("Il faut renseigner un email ou un numéro de téléphone.");
            formulaire.MailGarconPlage.className="invalid";
            formulaire.TelGarconPlage.className="invalid";
            isValid = false;
        }

        const nomError = document.getElementById("nomError");
        if(formulaire.NomGarconPlage.validity.valid) {
            nomError.textContent = "";
            nomError.className = "error";
            formulaire.NomGarconPlage.className= "valid";
        } else {
            nomError.textContent = "Veuillez renseigner le nom du garçon de plage.";
            nomError.className = "error active";
            formulaire.NomGarconPlage.className= "invalid";
            isValid = false;
        }

        const prenomError = document.getElementById("prenomError")
        if(formulaire.PrenomGarconPlage.validity.valid) {
            prenomError.textContent = "";
            prenomError.className = "error";
            formulaire.PrenomGarconPlage.className= "valid";
        } else {
            prenomError.textContent = "Veuillez renseigner le prénom du garçon de plage."
            prenomError.className = "error active"
            formulaire.PrenomGarconPlage.className= "invalid"
            isValid = false;
        }

        const motDePasseError = document.getElementById("motDePasseError")
        if(formulaire.MotDePasse.validity.valid) {
            motDePasseError.textContent = "";
            motDePasseError.className = "error";
            formulaire.MotDePasse.className= "valid";
        } else {
            motDePasseError.textContent = "Veuillez renseigner le mot de passe du garçon de plage."
            motDePasseError.className = "error active"
            formulaire.MotDePasse.className= "invalid"
            isValid = false;
        }

        const dateNaisError = document.getElementById("dateNaisError")
        if(formulaire.DateNaissanceGarconPlage.validity.valid) {
            dateNaisError.textContent = "";
            dateNaisError.className = "error";
            formulaire.DateNaissanceGarconPlage.className= "valid";
        } else {
            dateNaisError.textContent = "Veuillez renseigner la date de naissance du garçon de plage.";
            dateNaisError.className = "error active";
            formulaire.DateNaissanceGarconPlage.className= "invalid";
            isValid = false;
        }

        // console.log("SFVDF");
        
        if(!isValid) {
            // console.log("SFVDF");
            event.preventDefault();
        }
    }
    );
</script>
