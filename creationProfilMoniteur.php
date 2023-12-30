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
    
            $nomUtilisateur = $_POST["NomUtilisateur"];
            $motDePasse = $_POST["MotDePasse"];
            $nomMoniteur = $_POST["NomMoniteur"];
            $prenomMoniteur = $_POST["PrenomMoniteur"];
            $dateNaissMoniteur = $_POST["DateNaissanceMoniteur"];
            $mailMoniteur = $_POST["MailMoniteur"];
            $telMoniteur = $_POST["TelMoniteur"];
            $prefContactMoniteur = $_POST["PrefContactMoniteur"];
            $dateObtentionDiplome = $_POST["DateObtentionDiplome"];
            $lienURLDiplome = $_POST["LienURLDiplome"];
    
            $verifMoniteur = pg_prepare($connexion, "verif_moniteur", "SELECT f_rechercher_employe('Moniteur',$1,$2,$3,$4,$5)");
            $verifMoniteur = pg_execute($connexion, "verif_moniteur", array($nomMoniteur, $prenomMoniteur, $dateNaissMoniteur, $mailMoniteur, $telMoniteur)); 
            
            if(pg_num_rows($verifMoniteur) > 0) {
                echo '<script type="text/javascript"> alertMoniteurExists(); </script>';
;
            } else {
                // echo '<script>console.log("before moniteur created"); </script>';
                // insérer nouveau moniteur et récupérer son idCompte
                $requete = pg_prepare($connexion, "inserer_moniteur", 'SELECT f_creer_moniteur($1, $2, $3, $4, $5, $6, $7)');
                $result = pg_execute($connexion, "inserer_moniteur", array(
                    $nomUtilisateur,
                    $motDePasse,
                    $nomMoniteur, 
                    $prenomMoniteur, 
                    $dateNaissMoniteur,  
                    $mailMoniteur, 
                    $telMoniteur
                ));
                $row = pg_fetch_row($result);
                // echo '<script>console.log("id compte : ' . $row[0] . '"); </script>'; // idCompte

                $requete = pg_prepare($connexion, "inserer_diplome", 'CALL p_creer_diplome($1, $2, $3)');
                $result = pg_execute($connexion, "inserer_diplome", array(
                    $dateObtentionDiplome,
                    $lienURLDiplome,
                    $row[0]
                ));
                // alert("Le compte moniteur pour $prenomMoniteur $nomMoniteur a été créé.");
                header('Location: http://localhost/LesAbeilles/AccueilPropriétaire.php');
            }
        ?>
    </body>
</html>