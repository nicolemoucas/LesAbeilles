<?php
// Start the session
session_start();
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Louer un pédalo</title>
    <link rel="stylesheet" href="css/styles.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<body>

    <?php
    // Include the database connection
    $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

    // Declare variables
    $id_client = $date_heure_reservation = $duree = '';
    $erreur = '';

    // Form processing
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // Validation and retrieval of form data
        $id_client = test_input($_POST["id_client"]);
        $date_heure_reservation = test_input($_POST["date_heure_reservation"]);
        $duree = test_input($_POST["duree"]);

        // Check the availability of the pedal boat
        $queryCheckPedalBoat = "SELECT * FROM VerifierDisponibilitePedalo('$date_heure_reservation', '$duree')";
        $resultCheckPedalBoat = pg_query($connexion, $queryCheckPedalBoat);

        $rowPedalBoat = pg_fetch_assoc($resultCheckPedalBoat);

        if ($rowPedalBoat !== false) {
            $pedalBoatAvailable = $rowPedalBoat['disponible'];

            if (!$pedalBoatAvailable) {
                $erreur = "Le pédalo est indisponible pour la période spécifiée.";
            } else {
                // Rent the pedal boat
                $query = "SELECT * FROM LouerPedalo(
                    p_id_client := $id_client,
                    p_date_heure_reservation := '$date_heure_reservation',
                    p_duree := '$duree'
                )";

                $result = pg_query($connexion, $query);

                if ($result) {
                    $rowLocation = pg_fetch_assoc($result);
                    $id_location = $rowLocation['id_location'];
                    echo "La location du pédalo a été effectuée avec succès. ID de la location : $id_location";
                } else {
                    $erreur = "Erreur lors de la location du pédalo.";
                }
            }
        } else {
            $erreur = "Erreur lors de la vérification de la disponibilité du pédalo.";
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

    <div class="corps">
        <h2>Louer un pédalo</h2>
        <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
            <label for="id_client">ID du client :</label>
            <input type="text" name="id_client" required>

            <label for="date_heure_reservation">Date et heure de réservation :</label>
            <input type="datetime-local" name="date_heure_reservation" required>

            <label for="duree">Durée de la location (en heures) :</label>
            <input type="number" name="duree" required>

            <input type="submit" value="Louer le pédalo">
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
