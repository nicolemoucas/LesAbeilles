<!DOCTYPE html>
<html>
    <link rel="stylesheet" type="text/css" href="css/inscription.css" />
    <link rel="stylesheet" href="css/styles.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title> Création d'un profil moniteur </title>
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
        ?>
      
        <div class="corps">
            <h1>Formulaire de création du profil moniteur :</h1>
            <p>* Champs obligatoires</p>
            <form method="post" name="formulaire" novalidate="" class="form" action="creationProfilMoniteur.php">

                <label for="NomMoniteur" class="label">NOM *</label><br>
                <input type="text" id="NomMoniteur" name="NomMoniteur" placeholder="Ex : BOULANGER" required/>
                <div id="nomError" class="error"></div><br>
                    
                <label for="PrenomMoniteur">Prénom *</label><br>
                <input type="text" id="PrenomMoniteur" name="PrenomMoniteur" placeholder="Ex : Jean Michel" required/>
                <div id="prenomError" class="error"></div><br>

                <label for="DateNaissanceMoniteur">Date de naissance *</label><br>
                <input type="date" id="DateNaissanceMoniteur" name= "DateNaissanceMoniteur" placeholder="Ex : 08/01/1975" required/>
                <div id="dateNaisError" class="error"></div><br>

                <label for="MailMoniteur">Email</label><br>
                <input type="email" id="MailMoniteur" name="MailMoniteur" placeholder="Ex : boulangerjm@free.fr"/><br><br>

                <label for="TelMoniteur" pattern="0[0-9]{9}">Numéro de téléphone</label><br>
                <input type="text" id="TelMoniteur" name="TelMoniteur" placeholder="Ex : 0777764231"/><br><br>
                
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
    const formulaire = document.formulaire;
    formulaire.addEventListener("submit", (event) => {
        let isValid = true;

        if((!formulaire.MailMoniteur.value) &&(!formulaire.TelMoniteur.value)) {
            alert("Il faut renseigner un email ou un numéro de téléphone.")
            formulaire.MailMoniteur.className="invalid"
            formulaire.TelMoniteur.className="invalid"
            isValid = false;
        }

        const nomError = document.getElementById("nomError")

        if(formulaire.NomMoniteur.validity.valid) {
            nomError.textContent = "";
            nomError.className = "error"
            formulaire.NomMoniteur.className= "valid"
        } else {
            nomError.textContent = "Veuillez renseigner le nom du moniteur."
            nomError.className = "error active"
            formulaire.NomMoniteur.className= "invalid"
            isValid = false;
        }

        const prenomError = document.getElementById("prenomError")

        if(formulaire.PrenomMoniteur.validity.valid) {
            prenomError.textContent = "";
            prenomError.className = "error"
            formulaire.PrenomMoniteur.className= "valid"
        } else {
            prenomError.textContent = "Veuillez renseigner le prénom du moniteur."
            prenomError.className = "error active"
            formulaire.PrenomMoniteur.className= "invalid"
            isValid = false;
        }

        const dateNaisError = document.getElementById("dateNaisError")

        if(formulaire.DateNaissanceMoniteur.validity.valid) {
            dateNaisError.textContent = "";
            dateNaisError.className = "error"
            formulaire.DateNaissanceMoniteur.className= "valid"
        } else {
            dateNaisError.textContent = "Veuillez renseigner la date de naissance du moniteur."
            dateNaisError.className = "error active"
            formulaire.DateNaissanceMoniteur.className= "invalid"
            isValid = false;
        }
    }

    if(!isValid) {
        event.preventDefault();
    }
);
</script>