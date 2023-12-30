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
        <title> Suppression profil client</title>
        <script>
            function confirmerClientSupprime() {
                alert("Le profil du client a bien été supprimé");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }
        </script>
    </head>
    
    <body>
        <div>
            <h1>Suppression profil client</h1>
        </div>
        <?php
        ini_set('display_errors', 1);
        ini_set('display_startup_errors', 1);
        
        $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

        $nomClient = $_GET["nom"];
        $prenomClient = $_GET["prenom"];
        $dateNaissClient = $_GET["dateNaiss"];

        $deleteClient = $recupClient = pg_prepare($connexion, "delete_client", 'CALL supprimer_client($1,$2,$3)');
        $deleteClient = pg_execute($connexion, "delete_client", array($nomClient, $prenomClient, $dateNaissClient)); 

        if($deleteClient) {
            echo '<script type="text/javascript"> confirmerClientSupprime(); </script>';
        }
        ?>
    </body>
</html>