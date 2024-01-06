<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Employés</title>
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
    <?php $index_url = ''; $current_url = 'afficher_liste_employes.php'; ?>

    <header>
        <?php include('header.php') ?>
    </header>

    <div class="corps">
        <h2>Liste des Employés</h2>

        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start();

            // Connexion à la base de données
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            // Préparation et exécution de la requête SQL pour récupérer la liste des employés
            $result_employes = pg_query($connexion, 'SELECT * FROM Consulterlisteemploye()');

            // Affichage des résultats dans un tableau
            echo "<table border='1'>
                    <tr>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Mail</th>
                        <th>Numéro de Téléphone</th>
                        <th>Date de Naissance</th>
                        <th>Type d'Employé</th>
                    </tr>";

            while ($row = pg_fetch_assoc($result_employes)) {
                echo "<tr>
                        <td>".$row['nom']."</td>
                        <td>".$row['prenom']."</td>
                        <td>".$row['mail']."</td>
                        <td>".$row['numtelephone']."</td>
                        <td>".$row['datenaissance']."</td>
                        <td>".$row['typeemploye']."</td>
                      </tr>";
            }

            echo "</table>";

            pg_close($connexion);
        ?>
    </div>

    <footer>
        <?php include('footer.php') ?>
    </footer>
</body>
</html>
