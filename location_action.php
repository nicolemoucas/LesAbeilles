
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
    <header>
        <?php include('header.php'); ?>
    </header>

    <div class="container">
        <h1>Location du matériel</h1>

        <?php
            session_start();

            if (
                isset($_GET['idMatos']) && isset($_GET['nomMatos']) && isset($_GET['prixHeure']) &&
                isset($_GET['idClient']) && isset($_GET['choixPaiement']) &&
                isset($_GET['timestampLocation']) && isset($_GET['dureeLocation'])
            ) {
                $idMatos = $_GET['idMatos'];
                $nomMatos = $_GET['nomMatos'];
                $prixHeure = $_GET['prixHeure'];
                $idClient = $_GET['idClient'];
                $choixPaiement = $_GET['choixPaiement'];
                $timestampLocation = $_GET['timestampLocation'];
                $dureeLocation = $_GET['dureeLocation'];

                $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14")
                    or die("Impossible de se connecter : " . pg_result_error($connexion));

                $result = pg_query_params(
                    $connexion,
                    'CALL ajouter_location($1, $2, $3, $4, $5, $6, $7, $8, $9)',
                    array(
                        $idClient, $idMatos, $nomMatos, $timestampLocation,
                        $dureeLocation, $prixHeure, null, 'En cours', $choixPaiement
                    )
                );

                if ($result) {
                    echo "Location créée avec succès!";
                } else {
                    echo "Erreur lors de la création de la location.";
                }
            } else {
                echo "Paramètres manquants dans l'URL.";
            }
            ?>

    </div>

    <footer>
        <?php include('footer.php'); ?>
    </footer>
</body>

</html>

