<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Planning des locations</title>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            .container {
                text-align: center;
                max-width: 800px;
                margin: 20px auto; 
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px; 
            }
        </style>
    </head>
    <body>
        
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start();

            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

            if(isset($_GET['id']) && is_numeric($_GET['id'])) {
                $idLocation = $_GET['id'];
                $result = pg_query($connexion, "CALL annuler_location($idLocation)");

                if (!$result) {
                    echo "Erreur lors de l'annulation de la location.";
                } else {
                    echo "<div style='text-align:center;'><h2>Location annulée avec succès.</h2></div>";
                }
            } else {
                echo "<div style='text-align:center;'><h2>Paramètre ID manquant ou non valide.</h2></div>";
            }

            pg_close($connexion);
        ?>

    </body>
</html>
