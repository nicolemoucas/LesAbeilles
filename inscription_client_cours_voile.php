
<?php
session_start();
$showForm = isset($_POST['recherche_client']) && $_POST['recherche_client'] === 'Oui';
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
    </style>
</head>

<body>
    <?php $current_url = 'inscription_client_cours_voile.php'; ?>
    <header>
        <?php include('header.php') ?>
    </header>

    <div class="container">
        <h2>Inscription Cours de Voile</h2>

        <div class="buttons-container">
                
            <h3>La personne est-elle déjà cliente?</h3>

            <form method="post" action="">
                <button class="button" name="recherche_client" value="Oui">Oui</button>
            </form>

            <button class="button" onclick="window.location.href='InscriptionClient.php';">Non</button>
        </div>

        <div class="form-container">
            <?php
            if ($showForm) {
                echo '
                <form method="post" name="formulaire" novalidate="" class="form" action="afficherProfilClient.php">
                    <label for="NomClient" class="label">NOM</label><br>
                    <input type="text" id="NomClient" name="NomClient" placeholder="Ex : BOULANGER" required/>
                    <div id="nomError" class="error"></div><br>

                    <label for="PrenomClient">Prénom</label><br>
                    <input type="text" id="PrenomClient" name="PrenomClient" placeholder="Ex : Jean Michel" required/>
                    <div id="prenomError" class="error"></div><br>

                    <label for="DateNaissanceClient">Date de naissance</label><br>
                    <input type="date" id="DateNaissanceClient" name= "DateNaissanceClient" placeholder="Ex : 08/01/1975" required/>
                    <div id="dateNaisError" class="error"></div><br>

                    <div>
                        <button class="button">Rechercher</button>
                    </div>
                </form>';
            }
            ?>
        </div>

        <?php
        ini_set('display_errors', 1);
        ini_set('display_startup_errors', 1);
      

        $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
        $result = pg_query($connexion, 'SELECT * FROM consulter_cours_voile_pour_inscription()');

        if (!$result) {
            echo "Erreur lors de l'exécution de la fonction.";
        } else {
            echo "<table>
                    <tr>
                        <th>Date et Heure</th>
                        <th>Niveau</th>
                        <th>Nom Moniteur</th>
                        <th>Nb Places Restantes</th>
                        <th class='button-col'></th>
                    </tr>";

            while ($row = pg_fetch_assoc($result)) {
                echo "<tr>
                        <td>" . $row['dateheure'] . "</td>
                        <td>" . $row['niveau'] . "</td>
                        <td>" . $row['nommoniteur'] . "</td>
                        <td>" . $row['nbplacesrestantes'] . "</td>
                        <td class='button-col'><button class='button'>Inscrire à ce cours</button></td>
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
