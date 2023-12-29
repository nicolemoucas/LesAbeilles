<?php
    session_start(); 
?>
<!DOCTYPE html>
<html>
    <head>
        <title> Création du profil moniteur </title>
        <script>
            function alertMoniteurExists() {
                alert("Ce moniteur existe déjà.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilPropriétaire.php';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de création du profil moniteur :</h1>
    </div>
        <?php
            
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);

            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
    
            $nomMoniteur = $_POST["NomMoniteur"];
            $prenomMoniteur = $_POST["PrenomMoniteur"];
            $dateNaissMoniteur = $_POST["DateNaissanceMoniteur"];
            $mailMoniteur = $_POST["MailMoniteur"];
            $telMoniteur = $_POST["TelMoniteur"];

    
            $verifMoniteur = pg_prepare($connexion, "my_verif", 'SELECT recherche_moniteur($1,$2,$3)');
            $verifMoniteur = pg_execute($connexion, "my_verif", array($nomMoniteur, $prenomMoniteur, $dateNaissMoniteur)); 
            
            if(pg_num_rows($verifMoniteur) > 0) {
                echo '<script type="text/javascript"> alertMoniteurExists(); </script>';
;
            } else {
                $requete = pg_prepare($connexion, "my_query", 'CALL creer_moniteur($1, $2, $3, $4, $5)');
                $result = pg_execute($connexion, "my_query", array(
                    $nomMoniteur, 
                    $prenomMoniteur, 
                    $dateNaissMoniteur,  
                    $mailMoniteur, 
                    $telMoniteur
                )); 
                header('Location: http://localhost/LesAbeilles/AccueilPropriétaire.php');
            }
        ?>
    </body>
</html>
