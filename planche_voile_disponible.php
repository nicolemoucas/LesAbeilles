
<!DOCTYPE html>
<html lang="fr">


<script>
        function louerConfirmation(idMatos, nomMatos, prixHeure, prixHeureSupp, idClient, timeStampLoc, dureeLoc) {
            var choixPaiement = document.getElementById("choixPaiement").value;

            if (confirm("Confirmez-vous la location de " + nomMatos + " pour " + prixHeure + " € par heure avec un paiement par " + choixPaiement + " ?")) {
                window.location.href = "location_action.php?idMatos=" + idMatos + "&nomMatos=" + nomMatos + "&prixHeure=" + prixHeure + "&prixHeureSupp=" + prixHeureSupp+ "&idClient=" + idClient + "&choixPaiement=" + choixPaiement +"&timestampLocation=" + timeStampLoc+ "&dureeLocation=" + dureeLoc;
            }
        }

        function alertNonDisponible(idClient) {
            alert("Pas de planche a voile disponible avec pour ces critères.")
            window.location.href = "planche_voile_disponible.php?idClient=" + idClient;
        }
    </script>

<?php
session_start();

$connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

$dateLocation = $heureLocation = $dureeLocation = $timestampLocation = $timestampLocationFormatted = $capaciteFlotteur = $tailleVoile = "";
$result = null;

$idClient = isset($_GET['idClient']) ? $_GET['idClient'] : null;
    $requete="SELECT unnest(enum_range(NULL::ECapaciteFlotteur)) AS Ecap";
            $listeCapacite = pg_query($connexion, $requete);
            $capacite_combobox_php= "";
            while ($option = pg_fetch_object($listeCapacite)) {
                $capacite_combobox_php .= '<option value="' . $option->ecap . '">' . $option->ecap . '</option>';
            }

    //pour la combobox des capacités de flotteurs
    $requete="SELECT unnest(enum_range(NULL::ETailleVoile)) AS etv";
    $listeTailleVoile = pg_query($connexion, $requete);
    $taille_combobox_php= "";
    while ($option = pg_fetch_object($listeTailleVoile)) {
        $taille_combobox_php .= '<option value="' . $option->etv . '">' . $option->etv . '</option>';
    }   
?>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vérifications de disponibilité</title>
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
        <h1>Vérifications de disponibilité</h1>
        <form action="" method="post">
            <label for="dateLocation">Date de Location :</label>
            <input type="date" id="dateLocation" name="dateLocation" required value="<?php echo $dateLocation; ?>"><br><br>

            <label for="heureLocation">Heure de Location :</label>
            <input type="time" id="heureLocation" name="heureLocation" required value="<?php echo $heureLocation; ?>"><br><br>

            <label for="dureeLocation">Durée de Location :</label>
            <input type="number" id="dureeLocation" name="dureeLocation" required value="<?php echo $dureeLocation; ?>"> heures<br><br>

            <label for="CapaciteFlotteur">Capacité du flotteur</label><br>
            <select name="CapaciteFlotteur" class="form-control" id="CapaciteFlotteur">
            <option disabled selected value> -- Sélectionnez une option -- </option>
                <?php echo $capacite_combobox_php ?>
            </select>
            <div id="capaciteError" class="error"></div><br>

            <label for="TailleVoile">Taille de la Voile</label><br>
            <select name="TailleVoile" class="form-control" id="TailleVoile">
            <option disabled selected value> -- Sélectionnez une option -- </option>
                <?php echo $taille_combobox_php ?>
            </select><br><br>

            <label for="choixPaiement">Mode de paiement :</label>
            <select id="choixPaiement" name="choixPaiement" required>
                <option value="Carte">Carte</option>
                <option value="Espece">Espèces</option>
            </select>
            <br>
            <div id="tailleError" class="error"></div><br>
            <button type="submit">Louer</button>
        </form>

        <?php
        $idClient = isset($_GET['idClient']) ? $_GET['idClient'] : null;
        ?>
    </div>

    <footer>
        <?php include('footer.php') ?>
    </footer>

    <?php 
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $dateLocation = $_POST["dateLocation"];
    $heureLocation = $_POST["heureLocation"];
    $dureeLocation = $_POST["dureeLocation"];
    $capaciteFlotteur = $_POST["CapaciteFlotteur"];
    $tailleVoile = $_POST["TailleVoile"];
    $choixPaiement = isset($_POST['choixPaiement']) ? $_POST['choixPaiement'] : ''; 

    if ($dateLocation != "" && $heureLocation != "" && $dureeLocation != "") {
        $timestampLocation = strtotime("$dateLocation $heureLocation");
        if ($timestampLocation !== false) {
            $timestampLocationFormatted = date('Y-m-d H:i:s', $timestampLocation);

            $query = "SELECT * FROM f_rechercher_planchevoile(timestamp '$timestampLocationFormatted', INTERVAL '$dureeLocation HOUR', '$capaciteFlotteur', '$tailleVoile')";
            $result = pg_query($connexion, $query);
            $result = pg_fetch_object($result);

            if($result->idfloteur == null || $result->idpiedmat == null || $result->iddevoile == null) {
                echo '<script type="text/javascript"> alertNonDisponible('.$idClient.'); </script>';
            } else {
                $queryPlanche = "SELECT * FROM creer_planche_voile($result->idfloteur, $result->idpiedmat, $result->iddevoile)";

                $plancheAVoile = pg_query($connexion, $queryPlanche);
                $idPlanche = pg_fetch_object($plancheAVoile)->idplanche;

                $queryPrix = "SELECT * FROM prixmateriel where idprixmateriel = 2";
                $resulPrixMat = pg_query($connexion, $queryPrix);
                $prixMat = pg_fetch_object($resulPrixMat);
                $prixHeure = $prixMat->prixheure;
                $prixHeureSupp = $prixMat->prixheuresupp;
                $nomMatos = 'PlancheAVoile'; 
                echo '<script type="text/javascript"> louerConfirmation('.$idPlanche .', "'.$nomMatos.'", '.$prixHeure.','.$prixHeureSupp.', '.$idClient.', "'.$timestampLocationFormatted.'", '. $dureeLocation.'); </script>';
            }

        } 
    }
}
    
    ?>

</body>

</html>
