<!DOCTYPE html>
<html>
    <link rel="stylesheet" type="text/css" href="css/inscription.css" />
    <link rel="stylesheet" href="css/styles.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css" /> <!--icon for password-->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title> Création d'un profil propriétaire</title>
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
            session_start(); 
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
            <h1>Formulaire de création du profil propriétaire :</h1>
            <p>* Champs obligatoires</p>
            <form method="post" name="formulaire" novalidate="" class="form" action="creationProfilMoniteur.php">

                <label for="NomMoniteur" class="label">NOM *</label><br>
                <input type="text" id="NomMoniteur" name="NomMoniteur" placeholder="Ex : BOULANGER" required/>
                <div id="nomError" class="error"></div><br>
                    
                <label for="PrenomMoniteur">Prénom *</label><br>
                <input type="text" id="PrenomMoniteur" name="PrenomMoniteur" placeholder="Ex : Jean Michel" required/>
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

                <label for="DateNaissanceMoniteur">Date de naissance *</label><br>
                <input type="date" id="DateNaissanceMoniteur" name= "DateNaissanceMoniteur" placeholder="Ex : 08/01/1975" required/>
                <div id="dateNaisError" class="error"></div><br>

                <label for="MailMoniteur">Email</label><br>
                <input type="email" id="MailMoniteur" name="MailMoniteur" placeholder="Ex : boulangerjm@free.fr"/><br><br>

                <label for="TelMoniteur" pattern="0[0-9]{9}">Numéro de téléphone</label><br>
                <input type="text" id="TelMoniteur" name="TelMoniteur" placeholder="Ex : 0777764231"/><br><br>

                <div class="preferenceContactEmploye">
                    <label for="PrefContactMoniteur">Préférence de contact *</label><br>
                    <select name="PrefContactMoniteur" class="form-control" id="PrefContactMoniteur" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $prefContact_combobox_php; ?>
                    </select>
                    <div id="prefContactError" class="error"></div>
                </div><br>

                <div class="DocumentPDFEmploye">
                    <label>Diplôme</label><br><br>

                    <label for="DateObtentionDiplome">Date d'obtention du diplôme *</label><br>
                    <input type="date" id="DateObtentionDiplome" name= "DateObtentionDiplome" placeholder="Ex : 08/01/1975" required/>
                    <div id="dateObtentionDipError" class="error"></div><br>
                    
                    <label for="LienURLDiplome">Lien URL *</label>
                    <p>Veuillez uploader le document PDF dans le <a href="https://drive.google.com/drive">compte Drive Les Abeilles</a> puis insérer le lien ci-dessous</p>
                    <input type="text" id="LienURLDiplome" name="LienURLDiplome" placeholder="Ex : lien" required/>
                    <div id="lienDiplomeError" class="error"></div>
                </div>    
                <br><br>

                <div>
                    <button class = "button">Créer le moniteur</button>
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

        if((!formulaire.MailMoniteur.value) && (!formulaire.TelMoniteur.value)) {
            alert("Il faut renseigner un email ou un numéro de téléphone.");
            formulaire.MailMoniteur.className="invalid";
            formulaire.TelMoniteur.className="invalid";
            isValid = false;
        }

        const nomError = document.getElementById("nomError");
        if(formulaire.NomMoniteur.validity.valid) {
            nomError.textContent = "";
            nomError.className = "error";
            formulaire.NomMoniteur.className= "valid";
        } else {
            nomError.textContent = "Veuillez renseigner le nom du moniteur.";
            nomError.className = "error active";
            formulaire.NomMoniteur.className= "invalid";
            isValid = false;
        }

        const prenomError = document.getElementById("prenomError")
        if(formulaire.PrenomMoniteur.validity.valid) {
            prenomError.textContent = "";
            prenomError.className = "error";
            formulaire.PrenomMoniteur.className= "valid";
        } else {
            prenomError.textContent = "Veuillez renseigner le prénom du moniteur."
            prenomError.className = "error active"
            formulaire.PrenomMoniteur.className= "invalid"
            isValid = false;
        }

        const dateNaisError = document.getElementById("dateNaisError")
        if(formulaire.DateNaissanceMoniteur.validity.valid) {
            dateNaisError.textContent = "";
            dateNaisError.className = "error";
            formulaire.DateNaissanceMoniteur.className= "valid";
        } else {
            dateNaisError.textContent = "Veuillez renseigner la date de naissance du moniteur.";
            dateNaisError.className = "error active";
            formulaire.DateNaissanceMoniteur.className= "invalid";
            isValid = false;
        }

        const dateObtentionDipError = document.getElementById("dateObtentionDipError")
        if(formulaire.DateObtentionDiplome.validity.valid) {
            dateObtentionDipError.textContent = "";
            dateObtentionDipError.className = "error";
            formulaire.DateObtentionDiplome.className= "valid";
        } else {
            dateObtentionDipError.textContent = "Veuillez renseigner la date d'obtention du diplôme du moniteur.";
            dateObtentionDipError.className = "error active";
            formulaire.DateObtentionDiplome.className= "invalid";
            isValid = false;
        }

        const lienDiplomeError = document.getElementById("lienDiplomeError")
        if(formulaire.LienURLDiplome.validity.valid) {
            lienDiplomeError.textContent = "";
            lienDiplomeError.className = "error";
            formulaire.LienURLDiplome.className= "valid";
        } else {
            lienDiplomeError.textContent = "Veuillez renseigner le lien pour récupérer le diplôme du moniteur.";
            lienDiplomeError.className = "error active";
            formulaire.LienURLDiplome.className= "invalid";
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