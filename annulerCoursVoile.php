<!DOCTYPE html>
<html>
    <head>
    <link rel="stylesheet" type="text/css" href="css/inscription.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">   
        <title>Suppression cours de voile</title>
    </head>
    
    <body>
        <div>
            <h1>Suppression cours de voile</h1>
        </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start(); 
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            $idCours = $_GET["IdCours"];

            $suppCours = pg_prepare($connexion, "annuler_cours", 'CALL p_annuler_cours($1)');
            $suppCours = pg_execute($connexion, "annuler_cours", array($idCours));

            // Redirection après suppression
            header('Location: http://localhost/LesAbeilles/cours_de_voile.php');
            exit();
        ?>
    </body>
</html>