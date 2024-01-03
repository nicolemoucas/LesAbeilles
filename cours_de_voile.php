<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Consulter Cours Voile</title>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- pour jQuery -->
    </head>
    <body>
        <?php $current_url = 'cours_de_voile.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>

        <div class="corps" id="container_cours">
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
                    echo "<table border='1' id='table_cours'>
                            <tr>
                                <th>ID Cours</th>
                                <th>Date et Heure</th>
                                <th>Niveau</th>
                                <th>Nom Moniteur</th>
                                <th>Etat Cours</th>";
                    if ($_SESSION["role"] == 'Propriétaire') {
                        echo "<th>Action</th>";
                    }
                    echo "</tr>";

                    while ($row = pg_fetch_assoc($result)) {
                        echo "<tr>
                                <td>".$row['idcours']."</td>
                                <td>".$row['dateheure']."</td>
                                <td>".$row['niveau']."</td>
                                <td>".$row['nommoniteur']."</td>
                                <td>".$row['etatcours']."</td>";
                        if ($_SESSION["role"] == 'Propriétaire') {
                            echo "<td><button class='btnAnnulerCours'>Annuler</button></td>";
                        } 
                        echo "</tr>";
                    }
                    echo "</table>";
                }
                // Free resultset
                pg_free_result($result);
                pg_close($connexion);
            ?>
        </div>

        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
<script>
    $(document).ready(function(){

        // code to read selected table row cell data (values)
        $("#table_cours").on('click','.btnAnnulerCours',function(){

            // get the current row
            var currentRow=$(this).closest("tr"); 
            var IdCours = currentRow.find("td:eq(0)").text(); // get current row 1st TD value

            if(confirm("Voulez-vous vraiment annuler le cours n°" + IdCours + " ?")) {
                location.replace('http://localhost/LesAbeilles/annulerCoursVoile.php?IdCours=' + IdCours);
            }
        });
    });
</script>
</html>
