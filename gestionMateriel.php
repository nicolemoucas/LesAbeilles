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
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- pour jQuery -->
        <script>
            function redirectionProprietaire() {
                // window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
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
    <section>
        <?php $current_url = 'gestionMateriel.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>
    
        <article class="corps">
            <div class="fonctionnalites">
                    <a href="inscriptionMateriel.php" class="button">Recevoir du matériel</a>
                    <a href="changer_etat_materiel.php" class="button">Gestion de l'état du matériel</a>
            </div>
            <?php 
                ini_set('display_errors', 1);
                ini_set('display_startup_errors', 1);
                
                $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

            ?>
            
            <h2>Stock de matériel</h2>

            <div class='div_stock_materiel'>
                <form action="" method="post">
                    <select name="filter">
                        <option value="">Choisir...</option>
                        <option value="tout">Tout</option>
                        <option value="Catamaran">Catamaran</option>
                        <option value="Flotteur">Flotteur</option>
                        <option value="Pédalo">Pédalo</option>
                        <option value="Planche à voile">Planche à voile</option>
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
                            case "Planche à voile":
                                $query ='SELECT * FROM v_Planche_a_voile_compo;';
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
                    echo "<table border='1' class='table_cours_stock'";
                    echo "<tr>";

                    // get column names
                    while ($col < pg_num_fields($result))
                    {
                        $fieldName = pg_field_name($result, $col);
                        echo '<td>' . $fieldName . '</td>';
                        $col = $col + 1;
                    }
                    echo '<td>Action</td></tr>';
                    $col = 0;
                    
                    while ($row = pg_fetch_row($result)) 
                    {
                        $count = count($row);
                        $y = 0;
                        echo '<tr>';
                        while ($y < $count)
                        {
                            $c_row = current($row);
                            echo '<td>' . $c_row . '</td>';
                            next($row);
                            $y = $y + 1;
                        }
                        echo '<td><button class="btnModifMateriel">Modifier</button></td>';
                        echo '</tr>';
                        $col = $col + 1;
                    }
                    echo "</table>";
                    // Free resultset
                    pg_free_result($result);
                ?>            
            </div>
                </article>
    
        <footer>
            <?php include('footer.php') ?>
        </footer>
    </section>
<script>
    $(document).ready(function(){

        // code to read selected table row cell data (values)
        $("#table_stock").on('click','.btnModifMateriel',function(){

            // get the current row
            var currentRow=$(this).closest("tr"); 
            
            var IdMateriel = currentRow.find("td:eq(0)").text(); // get current row 1st TD value
            var TypeMateriel = currentRow.find("td:eq(1)").text(); // get current row 2nd TD
            var EtatMateriel = currentRow.find("td:eq(6)").text(); // get current row 6th TD

            // modif d'équipement au rebut possible que si propio
            if (EtatMateriel == 'Mis au rebut' && '<?php echo $_SESSION["role"]?>' != 'Propriétaire') {
                alert("Vous n'avez pas le droit de modifier cet équipement.");
            }
            else {
                //var data=IdMateriel+""+TypeMateriel+""+EtatMateriel;
                //alert(data);
                // redirection to modifier matériel
                window.location.href= '';
                const url = 'http://localhost/LesAbeilles/changer_etat_materiel.php?IdMateriel=' + IdMateriel + '&TypeMateriel=' + TypeMateriel + '&EtatMateriel=' + EtatMateriel;
                document.location = url;
            }
            
        });
    });
</script>
</html>
