<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html>
    <head>
        <title> Création du profil client </title>
        <script>
            function redirectionPropriétaire() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilPropriétaire.php';
            }

            function redirectionMoniteur() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilMoniteur.php';
            }
            function alertClientExists(role) {
                alert("Ce client existe déjà.");
                switch (role) {
                    case 'Propriétaire':
                        redirectionPropriétaire();
                        break;
                    case 'Moniteur':
                        redirectionMoniteur();
                        break;
                }
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de création du profil client :</h1>
    </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

            $nomClient = $_POST["NomClient"];
            $prenomClient = $_POST["PrenomClient"];
            $dateNaissClient = $_POST["DateNaissanceClient"];
            $mailClient = $_POST["MailClient"];
            $telClient = $_POST["TelClient"];
            $campingClient = $_POST["CampingClient"];
            $statutClient = $_POST["StatutClient"];
            $poidsClient = $_POST["PoidsClient"];
            $tailleClient = $_POST["TailleClient"];
            $prefContactClient = $_POST["PrefContactClient"];

            $verifClient = pg_prepare($connexion, "my_verif", 'SELECT recherche_client($1,$2,$3)');
            $verifClient = pg_execute($connexion, "my_verif", array($nomClient, $prenomClient, $dateNaissClient)); 
            
            if(pg_num_rows($verifClient) > 0) {
                echo '<script type="text/javascript"> alertClientExists("'.$_SESSION["role"].'"); </script>';
            } else {
                $requete = pg_prepare($connexion, "my_query", 'CALL creer_client($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)');
                $result = pg_execute($connexion, "my_query", array(
                    $nomClient, 
                    $prenomClient, 
                    $dateNaissClient,  
                    $mailClient, 
                    $telClient, 
                    $campingClient, 
                    $statutClient, 
                    $poidsClient, 
                    $tailleClient, 
                    $prefContactClient
                )); 

                 switch ($_SESSION["role"]) {
                    case 'Propriétaire':
                        echo '<script type="text/javascript"> redirectionPropriétaire(); </script>';
                        break;
                    case 'Moniteur':
                        echo '<script type="text/javascript"> redirectionMoniteur(); </script>';
                        break;
                    }
            }
        ?>
    </body>
</html>
