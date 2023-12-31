<?php            
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
        <title>Rechercher un employé</title>
    </head>
    
    <body>
        <header>
            <?php include('header.php')?>
        </header>

        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            //pour la combobox des rôles des employés
            $requete = "SELECT unnest(enum_range(NULL::ERoleEmploye)) AS ERole";
            $listeRolesEmployes = pg_query($connexion, $requete);
            $employes_combobox_php = "";
            while ($row = pg_fetch_object($listeRolesEmployes)) {
                $employes_combobox_php .= '<option value="' . $row->erole . '">' . $row->erole . '</option>';
            }
        ?>
        <div class="corps">
            <h1>Rechercher un employé</h1>
            <p>* Champs obligatoires</p>
            <form method="post" name="formulaire" novalidate="" class="form" action="afficherProfilEmploye.php">

                <div>
                    <label for="RoleEmploye">Role employé</label><br>
                    <select name="RoleEmploye" class="form-control" id="RoleEmploye" required>
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $employes_combobox_php; ?>
                    </select>
                    <div id="roleError" class="error"></div>
                </div>
                <br>

                <label for="NomEmploye" class="label">NOM *</label><br>
                <input type="text" id="NomEmploye" name="NomEmploye" placeholder="Ex : BOULANGER" required/>
                <div id="nomError" class="error"></div><br>

                <label for="PrenomEmploye">Prénom *</label><br>
                <input type="text" id="PrenomEmploye" name="PrenomEmploye" placeholder="Ex : Jean Michel" required/>
                <div id="prenomError" class="error"></div><br>

                <label for="DateNaissanceEmploye">Date de naissance *</label><br>
                <input type="date" id="DateNaissanceEmploye" name= "DateNaissanceEmploye" placeholder="Ex : 08/01/1975" required/>
                <div id="dateNaisError" class="error"></div><br>

                <label for="MailEmploye">Email</label><br>
                <input type="email" id="MailEmploye" name="MailEmploye" placeholder="Ex : boulangerjm@free.fr"/><br><br>

                <label for="TelEmploye" pattern="0[0-9]{9}">Numéro de téléphone</label><br>
                <input type="text" id="TelEmploye" name="TelEmploye" placeholder="Ex : 0777764231"/><br><br>

                <div>
                    <button class="button">Rechercher</button>
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
        console.log(formulaire);

        const roleError = document.getElementById("roleError")
        if(formulaire.RoleEmploye.validity.valid) {
            roleError.textContent = "";
            roleError.className = "error"
            formulaire.RoleEmploye.className= "valid"
        } else {
            roleError.textContent = "Veuillez renseigner le rôle de l'employé."
            roleError.className = "error active"
            formulaire.RoleEmploye.className= "invalid"
            isValid = false;
        }

        const nomError = document.getElementById("nomError")
        if(formulaire.NomEmploye.validity.valid) {
            nomError.textContent = "";
            nomError.className = "error"
            formulaire.NomEmploye.className= "valid"
        } else {
            nomError.textContent = "Veuillez renseigner le nom de l'employé."
            nomError.className = "error active"
            formulaire.NomEmploye.className= "invalid"
            isValid = false;
        }

        const prenomError = document.getElementById("prenomError")
        if(formulaire.PrenomEmploye.validity.valid) {
            prenomError.textContent = "";
            prenomError.className = "error"
            formulaire.PrenomEmploye.className= "valid"
        } else {
            prenomError.textContent = "Veuillez renseigner le prénom de l'employé."
            prenomError.className = "error active"
            formulaire.PrenomEmploye.className= "invalid"
            isValid = false;
        }

        const dateNaisError = document.getElementById("dateNaisError")
        if(formulaire.DateNaissanceEmploye.validity.valid) {
            dateNaisError.textContent = "";
            dateNaisError.className = "error"
            formulaire.DateNaissanceEmploye.className= "valid"
        } else {
            dateNaisError.textContent = "Veuillez renseigner la date de naissance de l'employé."
            dateNaisError.className = "error active"
            formulaire.DateNaissanceEmploye.className= "invalid"
            isValid = false;
        }

        if(!isValid) {
            event.preventDefault();
        }
});
</script>