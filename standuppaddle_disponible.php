<?php
session_start();

$connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14")
    or die("Impossible de se connecter : " . pg_result_error($connexion));

$dateLocation = $heureLocation = $dureeLocation = $timestampLocation = $timestampLocationFormatted = "";
$result = null;

$idClient = isset($_GET['idClient']) ? $_GET['idClient'] : null;

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $dateLocation = $_POST["dateLocation"];
    $heureLocation = $_POST["heureLocation"];
    $dureeLocation = $_POST["dureeLocation"];

    $choixPaiement = isset($_POST['choixPaiement']) ? $_POST['choixPaiement'] : ''; 

    if ($dateLocation != "" && $heureLocation != "" && $dureeLocation != "") {
        $timestampLocation = strtotime("$dateLocation $heureLocation");

        if ($timestampLocation !== false) {
            $timestampLocationFormatted = date('Y-m-d H:i:s', $timestampLocation);

            $query = "SELECT * FROM f_rechercher_standuppaddle($1, INTERVAL '$2 hour')";
            $result = pg_query_params($connexion, $query, array($timestampLocationFormatted));

            if (!$result) {
                die("Erreur dans la requête SQL : " . pg_last_error($connexion));
            }
        } else {
            die("Erreur lors de la conversion de la date et de l'heure.");
        }
    }
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

            <label for="choixPaiement">Mode de paiement :</label>
            <select id="choixPaiement" name="choixPaiement" required>
                <option value="Carte">Carte</option>
                <option value="Espece">Espèces</option>
            </select><br>

            <button type="submit">Afficher Résultats</button>
        </form>

        <?php
        $idClient = isset($_GET['idClient']) ? $_GET['idClient'] : null;

        if ($timestampLocation != "") {
            echo "<p>Date de Location: $dateLocation</p>";
            echo "<p>Heure de Location: $heureLocation</p>";
            echo "<p>Format Timestamp: $timestampLocationFormatted</p>";
            echo "<p>Durée de Location: $dureeLocation</p>";
            echo "<p>ID Client: " . ($idClient !== null ? $idClient : "non spécifié") . "</p>";
        }

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
                        <td><button class='louer-button' onclick='louerConfirmation(" . $row['idmatos'] . ", \"" . $row['nommateriel'] . "\", " . $row['prixheure'] . ", " . $idClient . ")'>Louer</button></td>
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
                // Ajout des informations de location à la requête URL
                window.location.href = "location_action.php?idMatos=" + idMatos + "&nomMatos=" + nomMatos + "&prixHeure=" + prixHeure + "&idClient=" + idClient + "&choixPaiement=" + choixPaiement + "&timestampLocation=" + "<?php echo $timestampLocationFormatted; ?>"  + "&dureeLocation=" + <?php echo $dureeLocation; ?>;
            }
        }
    </script>

</body>

</html>
