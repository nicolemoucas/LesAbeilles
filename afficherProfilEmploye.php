<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/inscription.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">   
        <title> Profil employé </title>
        <script>
            function alertEmployeExists() {
                alert("Cet employé n'existe pas.");
                window.location.href= 'http://localhost/LesAbeilles';
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
            session_start(); 
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            $nomEmploye = $_POST["NomEmploye"];
            $prenomEmploye = $_POST["PrenomEmploye"];
            $dateNaissEmploye = $_POST["DateNaissanceEmploye"];
    
            $recupEmploye = pg_prepare($connexion, "recup_employe", 'SELECT * FROM recherche_employe($1,$2,$3)');
            $recupEmploye = pg_execute($connexion, "recup_employe", array($nomEmploye, $prenomEmploye, $dateNaissEmploye)); 

        
            if(pg_num_rows($recupEmploye) == 0) {
                echo '<script type="text/javascript"> alertEmployeExists(); </script>';
            } else {
                $row = pg_fetch_object($recupEmploye);
            }
        ?>
    <div>
        <h1>Profil employé : <?php echo $row->prenomcl . ' ' .$row->nomcl?></h1>
    </div>
        <div>
        <form method="post" name="formulaire" novalidate="" class="form">
            <div>
                <a href="index.php" class="button">Retour</a>
                <button class="button" formaction="#">Modifier le profil</button>
                <button class= "button" formaction="javascript:confirmerSuppression()">Supprimer le profil</button>
            </div>

            <label for="NomEmploye" class="label">Rôle</label><br>
            <?php echo $Post[RoleEmploye]; ?>
            <input type="text" id="NomEmploye" name="NomEmploye" placeholder="Ex : BOULANGER" value= "<?php echo $row->nomcl ?>" required/>
            <div id="nomError" class="error"></div><br>
            
            <label for="NomEmploye" class="label">NOM</label><br>
            <input type="text" id="NomEmploye" name="NomEmploye" placeholder="Ex : BOULANGER" value= "<?php echo $row->nomcl ?>" required/>
            <div id="nomError" class="error"></div><br>
                
            <label for="PrenomEmploye">Prénom</label><br>
            <input type="text" id="PrenomEmploye" name="PrenomEmploye" placeholder="Ex : Jean Michel" value= "<?php echo $row->prenomcl ?>" required/>
            <div id="prenomError" class="error"></div><br>

            <label for="DateNaissanceEmploye">Date de naissance</label><br>
            <input type="date" id="DateNaissanceEmploye" name= "DateNaissanceEmploye" placeholder="Ex : 08/01/1975" value= "<?php echo $row->datenaissancecl ?>" required/>
            <div id="dateNaisError" class="error"></div><br>

            <label for="MailEmploye"> Email </label><br>
            <input type="email" id="MailEmploye" name="MailEmploye" placeholder="Ex : boulangerjm@free.fr"value= "<?php echo $row->mailcl ?>" /><br><br>

            <label for="TelEmploye" pattern="0[0-9]{9}" value="<?php echo $row->numtelephonecl ?>" >Numéro de téléphone</label><br>
            <input type="text" id="TelEmploye" name="TelEmploye" placeholder="Ex : 0777764231"/><br><br>
            
            </form>
        </div>

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
<script>
    function confirmerSuppression() {
        const formulaire = document.formulaire;
        if(confirm("Voulez-vous vraiment supprimer le profil de cet employé ?")) {
            const url = 'supprimerProfilEmploye.php?nom=' + formulaire.NomEmploye.value + '&prenom=' + formulaire.PrenomEmploye.value  + '&dateNaiss=' + formulaire.DateNaissanceEmploye.value ;
            document.location = url;
        }
    }
</script>