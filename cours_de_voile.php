<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulter Cours Voile</title>
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
    <script>
        function afficherParticipants(dateHeureCours) {
            var confirmation = confirm("Voulez-vous afficher les participants à ce cours le " + dateHeureCours + " ?");
            if (confirmation) {
                window.location.href = 'consulter_liste_participants.php?dateheure=' + encodeURIComponent(dateHeureCours);
            }
        }
    </script>
</head>
<body>
    <?php $current_url = 'cours_de_voile.php'; ?>
    <header>
        <?php include('header.php') ?>
    </header>

    <div class="container">
        <h2>Cours de Voile</h2>

        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start();

            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
            $result = pg_query($connexion, 'SELECT * FROM consulter_cours_voile()');

            if (!$result) {
                echo "Erreur lors de l'exécution de la fonction.";
            } else {
                echo "<table border='1'>
                        <tr>
                            <th>Date et Heure</th>
                            <th>Niveau</th>
                            <th>Nom Moniteur</th>
                            <th>Action</th>
                        </tr>";

                while ($row = pg_fetch_assoc($result)) {
                    // Déclaration et initialisation de $dateHeure à l'intérieur de la boucle
                    $dateHeure = $row['dateheure'];

                    echo "<tr>
                            <td>".$dateHeure."</td>
                            <td>".$row['niveau']."</td>
                            <td>".$row['nommoniteur']."</td>
                            <td><button class='button' onclick='afficherParticipants(\"".$dateHeure."\")'>Afficher les participants</button></td>
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
