<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Consulter Locations</title>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- pour jQuery -->
    </head>
    <body>
        <?php $index_url = ''; $current_url = 'consulter_locations.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>

        <div class="corps">
            <h2>Locations de matériel</h2>

            <?php
                ini_set('display_errors', 1);
                ini_set('display_startup_errors', 1);
                session_start();


                $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
                $result = pg_query($connexion, 'SELECT * FROM v_planning_locations;');
            
                if (!$result) {
                    echo "Erreur lors de la récupération du planning.";
                } else {
                    echo "<table border='1' class='table_cours_stock_location'>
                            <tr>
                                <th>ID Location</th>
                                <th>Date et Heure</th>
                                <th>Durée</th>
                                <th>Tarif Location (€)</th>
                                <th>Nom matériel</th>
                                <th>État Location</th>
                                <th>ID Client</th>
                                <th>Nom Client</th>
                                <th>Prénom Client</th>
                                <th>Mail Client</th>
                                <th>Téléphone Client</th>
                            </tr>";
                    while ($row = pg_fetch_assoc($result)) {
                        echo "<tr>
                                <td>".$row['idlocation']."</td>
                                <td>".$row['dateheurelocation']."</td>
                                <td>".$row['duree']."</td>
                                <td>".$row['tariflocation']."</td>
                                <td>".$row['nommateriel']."</td>
                                <td>".$row['etatlocation']."</td>
                                <td>".$row['idclient']."</td>
                                <td>".$row['nomclient']."</td>
                                <td>".$row['prenomclient']."</td>
                                <td>".$row['mailclient']."</td>
                                <td>".$row['telephoneclient']."</td>
                            </tr>";
                    }
                    echo "</table>";

                    // Free resultset
                    pg_free_result($result);
                    pg_close($connexion);
                }
            ?>
        </div> <!-- end corps -->

        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
<script>
    // $(document).ready(function(){

        // code to read selected table row cell data (values)
        // $("#table_cours_stock_location_location").on('click','.btnAnnulerCours',function(){
            function annulerCours() {
                console.log("here");
                // get the current row
                var currentRow=$(this).closest("tr"); 
                var IdCours = currentRow.find("td:eq(0)").text(); // get current row 1st TD value

                if(confirm("Voulez-vous vraiment annuler le cours n°" + IdCours + " ?")) {
                    location.replace('http://localhost/LesAbeilles/annulerCoursVoile.php?IdCours=' + IdCours);
                }
            }
            
        // });
</script>
</html>
