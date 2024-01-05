<?php
session_start();
$showForm = isset($_POST['recherche_client']) && $_POST['recherche_client'] === 'Oui';
$previousPage = isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : '';
$showQuestionAndButtons = strpos($previousPage, 'rechercher_client.php') !== false;
$idClientFromURL = isset($_GET['idClient']) ? $_GET['idClient'] : '';
$connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14")
    or die("Impossible de se connecter : " . pg_result_error($connexion));

$result = pg_query($connexion, 'SELECT * FROM consulter_cours_voile_pour_inscription()');
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulter Cours Voile</title>
    <link rel="stylesheet" href="css/styles.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        .container {
            max-width: 800px;
            margin: 20px auto;
        }

        table {
            width: 100%;
            margin-top: 30px;
            border: 1px solid #ddd;
        }

        .buttons-container {
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
        }

        .form-container {
            display: <?php echo $showForm ? 'block' : 'none'; ?>;
            text-align: left;
        }

        td:first-child {
            display: none;
        }
    </style>
</head>

<body>
    <header>
        <?php include('header.php') ?>
    </header>

    <div class="container">
        <h1>Inscription à un cours</h1>

        <?php if ($showQuestionAndButtons): ?>
            <div class="buttons-container">
                <h3>La personne est-elle déjà cliente?</h3>
                <button class="button" onclick="window.location.href='rechercherClient.php';" value="Oui">Oui</button>
                <button class="button" onclick="window.location.href='InscriptionClient.php';">Non</button>
            </div>
        <?php endif; ?>

        <?php

        if (!$result) {
            echo "Erreur lors de l'exécution de la fonction.";
        } else {
            echo "<table>
                    <tr>
                        <th>ID Cours</th>
                        <th>Date et Heure</th>
                        <th>Niveau</th>
                        <th>Nom Moniteur</th>
                        <th>Nb Places Restantes</th>
                        <th class='button-col'></th>
                    </tr>";

                    while ($row = pg_fetch_assoc($result)) {
                        echo "<tr>
                                <td></td>
                                <td>" . $row['idcours'] . "</td>
                                <td>" . $row['dateheure'] . "</td>
                                <td>" . $row['niveau'] . "</td>
                                <td>" . $row['nommoniteur'] . "</td>
                                <td>" . $row['nbplacesrestantes'] . "</td>
                                <td class='button-col'>
                                    <form method='post' action='inscription_client_cours_action.php'>
                                        <input type='hidden' name='idClient' value='$idClientFromURL'>
                                        <input type='hidden' name='idCours' value='" . $row['idcours'] . "'>
                                        <button type='submit' class='button' name='inscrireCours'>Inscrire à ce cours</button>
                                    </form>
                                </td>
                              </tr>";
                    }
                    
                    

            echo "</table>";
        }

        pg_close($connexion);
        ?>
    </div>

    <footer>
        <?php include('footer.php') ?>
    </footer>
</body>

</html>
