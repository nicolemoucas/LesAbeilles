<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription du client au Cours de Voile</title>
    <link rel="stylesheet" href="css/styles.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<body>
    <?php $index_url = ''; $current_url = 'inscription_client_cours_action.php'; ?>
    <header>
        <?php include('header.php'); ?>
    </header>

    <div class="corps">
        <h1>Inscription au cours</h1>

        <?php
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        if (isset($_POST['inscrireCours'])) {
            $idClient = $_POST['idClient'];
            $idCours = $_POST['idCours'];
            $idForfait = $_POST['idForfait'];

            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14")
                or die("Impossible de se connecter : " . pg_result_error($connexion));

            $inscrireCoursQuery = "SELECT InscrireClientauCours($idClient, $idCours, $idForfait)";
            $result = pg_query($connexion, $inscrireCoursQuery);

            if ($result) {
                echo "Client inscrit au cours avec succès.";
            } else {
                echo "Erreur lors de l'inscription au cours.";
            }

            pg_close($connexion);
        } else {
            header("Location: index.php");
            exit();
        }
        ?>
    </div>

    <footer>
        <?php include('footer.php'); ?>
    </footer>
</body>

</html>
