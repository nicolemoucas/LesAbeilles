<?php
    session_start();
?>
<!DOCTYPE html>
<html>
    <head>
        <title> Création du cours </title>
        <script>
            function redirection() {
                alert("Cours créé avec succès.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }
            function alertMoniteurNonDisponible() {
                alert("Ce moniteur n'est pas disponible pour cet horaire.");
                window.location.href= 'http://localhost/LesAbeilles/organiser_cours_voile.php';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Création du cours</h1>
    </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

            $horaireCours = $_POST["HoraireCours"];
            $niveauCours = $_POST["NiveauCours"];
            $idMoniteur = $_POST["Moniteur"];

            $verifMoniteur = pg_prepare($connexion, "my_verif", 'SELECT verification_moniteur_disponible($1, $2)');
            $verifMoniteur = pg_execute($connexion, "my_verif", array($idMoniteur, $horaireCours)); 
            
            $response= pg_fetch_object($verifMoniteur);
            if($response->verification_moniteur_disponible === 't') {
                $creationCours = pg_prepare($connexion, "cours", 'CALL creer_cours($1, $2, $3)');
                $creationCours = pg_execute($connexion, "cours", array($horaireCours, $niveauCours, $idMoniteur));
                echo '<script type="text/javascript"> redirection(); </script>';
            }
            else 
            echo '<script type="text/javascript"> alertMoniteurNonDisponible(); </script>';


        ?>
    </body>
</html>
