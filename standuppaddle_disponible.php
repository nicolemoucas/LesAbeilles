<?php
session_start();

// Connexion à la base de données
$connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14")
    or die("Impossible de se connecter : " . pg_result_error($connexion));

// Initialiser les variables
$dateLocation = $heureLocation = $dureeLocation = $timestampLocation = "";
$result = null;

// Vérification si le formulaire est soumis
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Récupération des données du formulaire
    $dateLocation = $_POST["dateLocation"];
    $heureLocation = $_POST["heureLocation"];
    $dureeLocation = $_POST["dureeLocation"];

    // Vérifier si la date, l'heure et la durée sont définies
    if ($dateLocation != "" && $heureLocation != "" && $dureeLocation != "") {
        // Convertir la date et l'heure en timestamp
        $timestampLocation = strtotime("$dateLocation $heureLocation");

        // Requête pour rechercher le matériel disponible
        $result = pg_query_params($connexion, "SELECT * FROM f_rechercher_standuppaddle($timestampLocation::timestamp, INTERVAL '1 hour')", array($timestampLocation, $dureeLocation));
    }
    //'2023-05-17 14:30:00'::timestamp, INTERVAL '1 hour'
}
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stand Up Paddle Disponible</title>
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
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .louer-button {
            background-color: #4CAF50;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>

<body>
    <header>
        <?php include('header.php') ?>
    </header>

    <div class="container">
        <h1>Stand Up Paddle Disponible</h1>
        <form action="" method="post">
            <label for="dateLocation">Date de Location :</label>
            <input type="date" id="dateLocation" name="dateLocation" required value="<?php echo $dateLocation; ?>"><br>

            <label for="heureLocation">Heure de Location :</label>
            <input type="time" id="heureLocation" name="heureLocation" required value="<?php echo $heureLocation; ?>"><br>

            <label for="dureeLocation">Durée de Location :</label>
            <input type="number" id="dureeLocation" name="dureeLocation" required value="<?php echo $dureeLocation; ?>"> heures<br>

            <button type="submit">Afficher Résultats</button>
        </form>

        <?php
        // Afficher les informations de débogage
        if ($timestampLocation != "") {
            echo "<p>Date de Location: $dateLocation</p>";
            echo "<p>Heure de Location: $heureLocation</p>";
            echo "<p>Format Timestamp: " . date('Y-m-d H:i:s', $timestampLocation) . "</p>";
            echo "<p>Durée de Location: $dureeLocation</p>";
        }

        // Afficher les résultats si le formulaire est soumis
        if ($result) {
            echo "<table>
                    <thead>
                        <tr>
                            <th>ID Matériel</th>
                            <th>Nom Matériel</th>
                            <th>Statut</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>";

            while ($row = pg_fetch_assoc($result)) {
                echo "<tr>
                        <td>" . $row['idmatos'] . "</td>
                        <td>" . $row['nommateriel'] . "</td>
                        <td>" . $row['statut'] . "</td>
                        <td><button class='louer-button' onclick='louerConfirmation(" . $row['idmatos'] . ", \"" . $row['nommateriel'] . "\", " . $row['prixheure'] . ", " . $_SESSION['idClient'] . ")'>Louer</button></td>
                      </tr>";
            }

            echo "</tbody>
                </table>";
        }
        ?>
    </div>

    <footer>
        <?php include('footer.php') ?>
    </footer>

    <script>
        function louerConfirmation(idMatos, nomMatos, prixHeure, idClient) {
            var choixPaiement = document.getElementById("choixPaiement").value;

            if (confirm("Confirmez-vous la location de " + nomMatos + " pour " + prixHeure + " € par heure avec un paiement par " + choixPaiement + " ?")) {
                // Ajout du moyen de paiement à la requête URL
                window.location.href = "louer_materiel_client.php?idMatos=" + idMatos + "&nomMatos=" + nomMatos + "&prixHeure=" + prixHeure + "&idClient=" + idClient + "&choixPaiement=" + choixPaiement;
            }
        }
    </script>

</body>

</html>
