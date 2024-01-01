<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <link rel="stylesheet" type="text/css" href="css/inscription.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">   
        <title>Gestion du matériel</title>
        <script>
            function redirectionProprietaire() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }

            function redirectionMoniteur() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilMoniteur.php';
            }

            function redirectionGarconDePlage() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilGarconPlage.php';
            }

            function alertTableNotFound(role) {
                alert("La table n'a pas pu être récupérée. Vous serez redirigé sur l'écran d'accueil.");
                switch (role) {
                    case 'Propriétaire':
                        redirectionProprietaire();
                        break;
                    case 'Moniteur':
                        redirectionMoniteur();
                        break;
                    case 'Garçon de plage':
                        redirectionGarconDePlage();
                        break;
                }
            }
        </script>
    </head>
    <body>
        <?php $current_url = 'gestionMateriel.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>
    
        <div class="corps">
            <div class="fonctionnalites">
                    <a href="#.php" class="button">Recevoir du matériel</a>
                    <a href="changer_etat_materiel.php" class="button">Gestion de l'état du matériel</a>
            </div>
            <?php 
                ini_set('display_errors', 1);
                ini_set('display_startup_errors', 1);
                
                $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

            ?>
            
            <h2>Stock de matériel</h2>

            <div class='table_stock_materiel'>
                <form action="" method="post">
                    <select name="filter">
                        <option value="">Choisir...</option>
                        <option value="tout">Tout</option>
                        <option value="Catamaran">Catamaran</option>
                        <option value="Flotteur">Flotteur</option>
                        <option value="Pédalo">Pédalo</option>
                        <option value="Pied de mat">Pied de mat</option>
                        <option value="Stand Up Paddle">Stand Up Paddle</option>
                        <option value="Voile">Voile</option>
                        <option value="En location">En location</option>
                        <option value="Reçu">Reçu</option>
                        <option value="Fonctionnel">Fonctionnel</option>
                        <option value="Hors service">Hors service</option>
                        <option value="Mis au rebut">Mis au rebut</option>
                    </select>
                    <input type="submit" name="submit" value="Filtrer">
                </form>
                <?php
                    if (isset($_POST['submit'])) {
                        $filterValue = $_POST['filter'];

                        // récupérer table stock matériel selon filtre
                        switch ($filterValue) {
                            case "tout":
                                $query = 'SELECT * FROM v_stock_materiel';
                                break;
                            case "Catamaran":
                            case "Flotteur":
                            case "Pédalo":
                            case "Pied de mat":
                            case "Stand Up Paddle":
                            case "Voile":
                                $query = 'SELECT * FROM v_stock_materiel WHERE "Nom matériel" = \''.$filterValue.'\'';
                                break;
                            case "En location":
                            case "Reçu":
                            case "Fonctionnel":
                            case "Hors service":
                            case "Mis au rebut":
                                $query = 'SELECT * FROM v_stock_materiel WHERE "Statut" = \''.$filterValue.'\'';
                                break;
                        }
                    }
                    else {
                        $query = 'SELECT * FROM v_stock_materiel';
                    }
                    $result = pg_query($connexion, $query);
                    if(!$result) {
                        echo '<script type="text/javascript"> alertTableNotFound("'.$_SESSION["role"].'"); </script>';
                    }
                    $col=0;
                    // table header
                    echo "<table border='1'";
                    echo "<tr>";

                    // get column names
                    while ($col < pg_num_fields($result))
                    {
                        $fieldName = pg_field_name($result, $col);
                        echo '<td>' . $fieldName . '</td>';
                        $col = $col + 1;
                    }
                    echo '</tr>';
                    $col = 0;
                    
                    while ($row = pg_fetch_row($result)) 
                    {
                        echo '<tr>';
                        $count = count($row);
                        $y = 0;
                        while ($y < $count)
                        {
                            $c_row = current($row);
                            echo '<td>' . $c_row . '</td>';
                            next($row);
                            $y = $y + 1;
                        }
                        echo '</tr>';
                        $col = $col + 1;
                    }
                    echo "</table>";
                    // Free resultset
                    pg_free_result($result);
                ?>

            </div>
            

            
            </div>
        </div>
    
        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
</html>
