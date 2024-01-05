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
        $result = pg_query($connexion, 'SELECT * FROM consulter_locations()');

        if (!$result) {
            echo "Erreur lors de l'exécution de la fonction.";
        } else {
            echo "<div class='container'>
                    <h2>Planning des locations</h2>
                    <table border='1'>
                        <tr>
                            <th>Date et Heure de Début</th>
                            <th>Date et Heure de Fin</th>
                            <th>Nom Client</th>
                            <th>Nom Moniteur</th>
                            <th>Statut</th>
                            <th>Action</th>
                        </tr>";

            while ($row = pg_fetch_assoc($result)) {
                echo "<tr>
                        <td>".$row['dateheuredebut']."</td>
                        <td>".$row['dateheurefin']."</td>
                        <td>".$row['nomclient']."</td>
                        <td>".$row['nommoniteur']."</td>
                        <td>".$row['statut']."</td>
                        <td>";
                
                if ($row['statut'] !== 'Annulée') {
                    echo "<button class='button' onclick='confirmerAnnulation(".$row['idlocation'].")'>Annuler location</button>";
                }

                echo "</td></tr>";
            }

            echo "</table></div>";
        }

        pg_close($connexion);
    ?>

    <script>
        function confirmerAnnulation(idLocation) {
            var confirmation = confirm("Êtes-vous sûr de vouloir annuler cette location ?");
            if (confirmation) {
                window.location.href = "Annuler_location.php?id=" + idLocation;
            }
        }
    </script>

</body>
</html>
