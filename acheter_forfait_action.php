<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Achat d'un forfait</title>
    <link rel="stylesheet" href="css/styles.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<body>
    <header>
        <?php include('header.php'); ?>
    </header>

    <div class="container">
        <h1>Achat d'un forfait</h1>

        <?php

            $idClient = $_POST['client'];
            $idFofait = $_POST['forfait'];
            $moyenPaiement = $_POST['paiement'];

            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));


            $inscrireCoursQuery = "CALL acheter_forfait($idClient, $idFofait, '$moyenPaiement')";
            $result = pg_query($connexion, $inscrireCoursQuery);

            if ($result) {
                echo "Achat enregistré avec succès.";
                header('Location: http://localhost/LesAbeilles/inscription_client_cours_voile.php?idClient='. $idClient);
            } else {
                echo "Erreur lors de l'achat.";
            }

            pg_close($connexion);

            
        ?>
    </div>

    <footer>
        <?php include('footer.php'); ?>
    </footer>
</body>

</html>
