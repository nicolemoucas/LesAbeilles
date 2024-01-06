<!DOCTYPE html>
<html lang="fr">
<head>
       <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Participants</title>
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
    <?php $index_url = ''; $current_url = 'consulter_liste_participants.php'; ?>

    <header>
        <?php include('header.php') ?>
    </header>

    <div class="container">
        <h2>Liste des Participants</h2>

        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start();

            // Vérifie si la date et l'heure du cours sont passées en paramètre
            if (isset($_GET['dateheure'])) {
                $dateheure_cours = urldecode($_GET['dateheure']);

                // Connexion à la base de données
                $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

                // Préparation et exécution de la requête SQL pour récupérer la liste des participants
                $result_participants = pg_query_params($connexion, "SELECT * FROM listeInscritsCoursVoile($1)", array($dateheure_cours));

                // Affichage des résultats dans un tableau
                echo "<table border='1'>
                        <tr>
                            <th>ID Client</th>
                            <th>Nom Client</th>
                            <th>Prénom Client</th>
                        </tr>";

                while ($row = pg_fetch_assoc($result_participants)) {
                    echo "<tr>
                            <td>".$row['idclient']."</td>
                            <td>".$row['nomclient']."</td>
                            <td>".$row['prenomclient']."</td>
                          </tr>";
                }

                echo "</table>";

                pg_close($connexion);
            } else {
                // Si la date et l'heure du cours ne sont pas spécifiées, redirigez l'utilisateur vers la page précédente ou une page par défaut
                header("Location: cours_de_voile.php");
                exit();
            }
        ?>
    </div>

    <footer>
        <?php include('footer.php') ?>
    </footer>
</body>
</html>
