<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion du matériel</title>
    <link rel="stylesheet" href="css/styles.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
    <?php $current_url = 'gestion_materiel.php'; ?>
    <header>
        <?php include('header.php') ?>
    </header>

    <div class="container">
        <h2>Changer l'état d'un matériel</h2>
    </div>

    <form action="changer_etat_materiel.php" method="post">
        <label for="materiel_id">ID du matériel :</label>
        <input type="text" name="materiel_id" required>

        <label for="type_materiel">Type de matériel :</label>
        <select name="type_materiel" required>
            <option value="Pedalo">Pedalo</option>
            <option value="StandUpPaddle">Stand Up Paddle</option>
            <option value="Catamaran">Catamaran</option>
            <option value="PlancheVoile">Planche à voile</option>
        </select>

        <label for="nouvel_etat">Nouvel état :</label>
        <select name="nouvel_etat" required>
            <option value="Reçu">Reçu</option>
            <option value="Fonctionnel">Fonctionnel</option>
            <option value="Hors service">Hors service</option>
            <?php if ($_SESSION["role"] === 'Propriétaire') 
            echo '<option value="Mis au rebut">Mis au rebut</option>' ?>
        </select>

        <button type="submit" style="background-color: #3498db; color: white;">Changer l'état</button>
    </form>

    <?php
        $conn = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_last_error());

        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $materiel_id = $_POST["materiel_id"];
            $type_materiel = $_POST["type_materiel"];
            $nouvel_etat = $_POST["nouvel_etat"];

            $sql = "CALL Changer_etat_materiel($1, $2, $3)";
            $stmt = pg_prepare($conn, "changer_etat_materiel", $sql);
            $result = pg_execute($conn, "changer_etat_materiel", array($materiel_id, $type_materiel, $nouvel_etat));

            if ($result) {
                echo "L'état du matériel a été changé avec succès.";
            } else {
                echo "Erreur lors du changement d'état du matériel : " . pg_last_error($conn);
            }
        }

        pg_close($conn);
    ?>


    <footer>
        <?php include('footer.php') ?>
    </footer>
</body>
</html>
