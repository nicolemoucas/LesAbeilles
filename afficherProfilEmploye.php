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
        <title>Profil employé</title>
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

            function alertEmployeNotExists(role) {
                alert("Cet employé n'existe pas. Vous serez redirigé sur l'écran d'accueil.");
                switch (role) {
                    case 'Propriétaire':
                        console.log('propio')
                        redirectionProprietaire();
                        break;
                    case 'Moniteur':
                        console.log('moni')
                        redirectionMoniteur();
                        break;
                }
            }
        </script>
    </head>
    <body>
        <?php $index_url = ''; $current_url = 'afficherProfilEmploye.php'; ?>
        <header>
            <?php include('header.php')?>
        </header>
        
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);

            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            $roleEmploye = $_POST["RoleEmploye"];
            $nomEmploye = $_POST["NomEmploye"];
            $prenomEmploye = $_POST["PrenomEmploye"];
            $dateNaissEmploye = $_POST["DateNaissanceEmploye"];
            $mailEmploye = $_POST["MailEmploye"];
            $telEmploye = $_POST["TelEmploye"];
    
            $recupEmploye = pg_prepare($connexion, "recup_employe", 'SELECT * FROM f_rechercher_employe($1,$2,$3,$4,$5,$6)');
            $recupEmploye = pg_execute($connexion, "recup_employe", array($roleEmploye, $nomEmploye, $prenomEmploye, $dateNaissEmploye, $mailEmploye, $telEmploye)); 
            // echo '/n/n--'.$roleEmploye.', '.$nomEmploye.', '.$prenomEmploye.', '.$dateNaissEmploye.', '.$mailEmploye.', '.$telEmploye.'--/n/n';

            if(pg_num_rows($recupEmploye) == 0) {
                echo 'employee not found';
                echo '<script type="text/javascript"> alertEmployeNotExists("'.$_SESSION["role"].'"); </script>';
            } else {
                $row = pg_fetch_object($recupEmploye);
            }

            //pour la combobox des rôles des employés
            $requete = "SELECT unnest(enum_range(NULL::ETypeEmploye)) AS ERole";
            $listeRolesEmployes = pg_query($connexion, $requete);
            $employes_combobox_php = "";
            while ($row_emp = pg_fetch_object($listeRolesEmployes)) {
                $employes_combobox_php .= '<option value="' . $row_emp->erole . '">' . $row_emp->erole . '</option>';
            }
        ?>
    <div class="corps">
        <h1>Profil employé : <?php echo $row->prenomemp . ' ' .$row->nomemp?></h1>
        <form method="post" name="formulaire" novalidate="" class="form">
            <div>
                <button class="button" formaction="javascript:redirection('<?php echo $_SESSION["role"]?>')">Retour</a>
                <button class="button" formaction="javascript:confirmerModification('<?php echo $row->idemp ?>')"> Modifier le profil</button>
                <button class= "button" formaction="javascript:confirmerSuppression('<?php echo $roleEmploye ?>')">Supprimer le profil</button>
            </div>

            <div>
                <label for="RoleEmploye">Role employé</label><br>
                <select name="RoleEmploye" class="form-control" id="RoleEmploye" required>
                    <option value="<?php echo $roleEmploye; ?>"><?php echo $roleEmploye; ?></option>
                    <?php echo $employes_combobox_php; ?>
                </select>
            </div>
            <br>
            
            <label for="NomEmploye" class="label">NOM : </label><br>
            <input type="text" id="NomEmploye" name="NomEmploye" value= "<?php echo $row->nomemp ?>" required/>
            <div id="nomError" class="error"></div>
            <br>

            <label for="PrenomEmploye">Prénom</label><br>
            <input type="text" id="PrenomEmploye" name="PrenomEmploye" value= "<?php echo $row->prenomemp ?>" required/>
            <div id="prenomError" class="error"></div>
            <br>

            <label for="DateNaissanceEmploye">Date de naissance</label><br>
            <input type="date" id="DateNaissanceEmploye" name= "DateNaissanceEmploye" value= "<?php echo $dateNaissEmploye ?>" required/>
            <div id="dateNaisError" class="error"></div>
            <br>

            <label for="MailEmploye"> Email </label><br>
            <input type="email" id="MailEmploye" name="MailEmploye" value= "<?php echo $row->mailemp ?>"/>
            <br><br>

            <label for="TelEmploye" pattern="0[0-9]{9}">Numéro de téléphone</label><br>
            <input type="text" id="TelEmploye" name="TelEmploye" value="<?php echo $row->numtelemp ?>"/>
            <br><br>
            
            </form>
        </div>

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
<script>
    function confirmerSuppression(role) {
        const formulaire = document.formulaire;
        if(confirm("Voulez-vous vraiment supprimer le profil de cet employé ?")) {
            const url = 'supprimerProfilEmploye.php?NomEmploye=' + formulaire.NomEmploye.value + '&PrenomEmploye=' + formulaire.PrenomEmploye.value + '&DateNaissEmploye=' + formulaire.DateNaissanceEmploye.value + '&MailEmploye=' + formulaire.MailEmploye.value  + '&TelEmploye=' + formulaire.TelEmploye.value + '&RoleEmploye=' + role ;
            document.location = url;
        }
    }
    function confirmerModification(idEmploye) {
        if(verifFormulaire()) {
            const formulaire = document.formulaire;
            if(confirm("Voulez-vous vraiment modifier le profil de cet employé ?")) {
                const url = 'modifierProfileEmploye.php?idEmploye=' + idEmploye + '&NomEmploye=' + formulaire.NomEmploye.value + '&PrenomEmploye=' + formulaire.PrenomEmploye.value + '&DateNaissEmploye=' + formulaire.DateNaissanceEmploye.value + '&MailEmploye=' + formulaire.MailEmploye.value  + '&TelEmploye=' + formulaire.TelEmploye.value;
                document.location = url;
            }
        }
    }

    function verifFormulaire() {
        let isValid = true;

        if((!formulaire.MailEmploye.value) && (!formulaire.TelEmploye.value)) {
            alert("Il faut renseigner un email ou un numéro de téléphone.");
            formulaire.MailMoniteur.className="invalid";
            formulaire.TelMoniteur.className="invalid";
            isValid = false;
        }

        const nomError = document.getElementById("nomError");
        if(formulaire.NomEmploye.validity.valid) {
            nomError.textContent = "";
            nomError.className = "error";
            formulaire.NomEmploye.className= "valid";
        } else {
            nomError.textContent = "Veuillez renseigner le nom de l'employé(e).";
            nomError.className = "error active";
            formulaire.NomEmploye.className= "invalid";
            isValid = false;
        }

        const prenomError = document.getElementById("prenomError")
        if(formulaire.PrenomEmploye.validity.valid) {
            prenomError.textContent = "";
            prenomError.className = "error";
            formulaire.PrenomEmploye.className= "valid";
        } else {
            prenomError.textContent = "Veuillez renseigner le prénom de l'employé(e)."
            prenomError.className = "error active"
            formulaire.PrenomEmploye.className= "invalid"
            isValid = false;
        }

        const dateNaisError = document.getElementById("dateNaisError")
        if(formulaire.DateNaissanceEmploye.validity.valid) {
            dateNaisError.textContent = "";
            dateNaisError.className = "error";
            formulaire.DateNaissanceEmploye.className= "valid";
        } else {
            dateNaisError.textContent = "Veuillez renseigner la date de naissance de l'employé(e).";
            dateNaisError.className = "error active";
            formulaire.DateNaissanceEmploye.className= "invalid";
            isValid = false;
        }

        return isValid;
        }
    
</script>