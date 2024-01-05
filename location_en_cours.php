<?php
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulter Location</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        button {
            padding: 5px 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <?php $current_url = 'location_en_cours.php'; ?>
    <header>
        <?php include('header.php') ?>
    </header>

    <div class="corps" id="container_cours">
        <h2>Location en cours</h2>

        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);

            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
            $result = pg_query($connexion, "SELECT idlocation, dateheurelocation, duree, idclient, etatlocation, nomclient, prenomclient, numtelephone, mail FROM afficher_locations()");

            if (!$result) {
                echo "Erreur lors de l'exécution de la fonction.";
            } else {
                echo "<table>
                        <tr>
                            <th>Date et Heure</th>
                            <th>Durée</th>
                            <th>État</th>
                            <th>Nom Client</th>
                            <th>Prénom Client</th>
                            <th>Numéro de Téléphone</th>
                            <th>Mail</th>";
                
                if ($_SESSION["role"] == 'Propriétaire') {
                    echo "<th>Action</th>";
                }
                
                echo "</tr>";

                while ($row = pg_fetch_assoc($result)) {
                    echo "<tr>
                            <td>".$row['dateheurelocation']."</td>
                            <td>".$row['duree']."</td>
                            <td>".$row['etatlocation']."</td>
                            <td>".$row['nomclient']."</td>
                            <td>".$row['prenomclient']."</td>
                            <td>".$row['numtelephone']."</td>
                            <td>".$row['mail']."</td>";
                    
                    if ($_SESSION["role"] == 'Propriétaire') {
                        echo "<td><button onclick=\"annulerLocation(" . $row['idlocation'] . ")\">Annuler</button></td>";
                    }
                    
                    echo "</tr>";
                }
                echo "</table>";
            }
            pg_free_result($result);
            pg_close($connexion);
        ?>
    </div> 

    <footer>
        <?php include('footer.php') ?>
    </footer>
    <script>
        function annulerLocation(idLocation) {
                if(confirm("Voulez-vous vraiment annuler la location n°" + idLocation + " ?")) {
                window.location.href = 'annuler_location.php?idLocation=' + idLocation;
            }
        }
    </script>
</body>
</html>
