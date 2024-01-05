<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Louer un catamaran</title>
    <link rel="stylesheet" href="css/styles.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<body>
    <?php 
        $current_url = 'consulter_locations.php';
        // Include the database connection
        $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

        // Declare variables
        $id_client = $date_heure_reservation = $duree = '';
        $erreur = '';

        $idClient = $_GET["idClient"];
        // Form processing
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            // Validation and retrieval of form data
            // $id_client = test_input($_POST["id_client"]);
            $idClient = $_GET["idClient"];
            $date_heure_reservation = test_input($_POST["date_heure_reservation"]);
            $duree = test_input($_POST["duree"]);

            // Check the availability of the catamaran
                        
            $requete = pg_prepare($connexion, "chercher_catamaran", "SELECT * FROM f_rechercher_catamaran ($1,$2)");
            $result = pg_execute($connexion, "chercher_catamaran", array($idClient)); 
            
            $resultCheckCatamaran = pg_query($connexion, $queryCheckCatamaran);

            if (!$resultCheckCatamaran) {
                die("Erreur lors de la requête : " . pg_last_error());
            }

            $rowCatamaran = pg_fetch_assoc($resultCheckCatamaran);

            if ($rowCatamaran !== false) {
                $id_location = $rowCatamaran['id_location'];
                echo "La location du catamaran a été effectuée avec succès. ID de la location : $id_location";
            } else {
                $erreur = "Erreur lors de la location du catamaran.";
            }

            // Close the database connection
            pg_close($connexion);
        }

        // Function for validating form data
        function test_input($data)
        {
            $data = trim($data);
            $data = stripslashes($data);
            $data = htmlspecialchars($data);
            return $data;
        }
        ?>
    <header>
        <?php include('header.php'); ?>
    </header>
        <div class="corps">
            <h2>Louer un catamaran</h2>
            <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                <label for="id_client">ID du client :</label>
                <input type="text" name="id_client" value="<?php echo $idClient ?>" required>

                <label for="date_heure_reservation">Date et heure de réservation :</label>
                <input type="datetime-local" name="date_heure_reservation" required>

                <label for="duree">Durée de la location (en heures) :</label>
                <input type="number" name="duree" required>

                <input type="submit" value="Louer le catamaran">
            </form>

            <?php
            // Display errors
            if ($erreur) {
                echo "<p class='erreur'>$erreur</p>";
            }
            ?>
        </div>

        <footer>
            <?php include('footer.php') ?>
        </footer>
</body>

</html>
