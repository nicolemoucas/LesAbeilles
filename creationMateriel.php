<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html>
    <head>
        <title> Création du matériel </title>
        <script>
            function redirection() {
                if(confirm("L'équipement a été ajouté au stock du Club Les Abeilles.")) {
                    document.location = 'http://localhost/LesAbeilles/gestionMateriel.php';
                }
            }
        </script>
    </head>
    <body>
        <div class="corps">
            <?php
                ini_set('display_errors', 1);
                ini_set('display_startup_errors', 1);            
                $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

                if(!empty($_POST["TypeMateriel"])) {$typeMateriel = $_POST["TypeMateriel"];}
                if(!empty($_POST["CapaciteFlotteur"])) {$capaciteFlotteur = $_POST["CapaciteFlotteur"];}
                if(!empty($_POST["NbPlaces"])) {$nbPlaces = $_POST["NbPlaces"];}
                if(!empty($_POST["CapaciteSUP"])) {$capaciteSUP = $_POST["CapaciteSUP"];}
                if(!empty($_POST["TailleVoile"])) {$tailleVoile = $_POST["TailleVoile"];}

                // insertion selon type matériel
                // attention modification prix matériel, on devrait récupérer d'abord l'id de prix matériel selon le type
                switch ($typeMateriel) {
                    case 'Catamaran':
                        $requete = pg_prepare($connexion, "insertion_catamaran", 'INSERT INTO Catamaran (NbPlaces, Statut, IdPrixMateriel) VALUES ($1, \'Reçu\', 1);');
                        $result = pg_execute($connexion, "insertion_catamaran", array($nbPlaces)); 
                        break;
                    case 'Flotteur':
                        $requete = pg_prepare($connexion, "insertion_flotteur", 'INSERT INTO Flotteur (IdPlancheVoile, Capacite, Statut) VALUES (1, $1, \'Reçu\');');
                        $result = pg_execute($connexion, "insertion_flotteur", array($capaciteFlotteur)); 
                        break;
                    case 'Pédalo':
                        $requete = pg_prepare($connexion, "insertion_pedalo", 'INSERT INTO Pedalo (NbPlaces, Statut, IdPrixMateriel) VALUES ($1, \'Reçu\', 4);');
                        $result = pg_execute($connexion, "insertion_pedalo", array($nbPlaces)); 
                        break;
                    case 'Pied de mat':
                        $result = pg_query($connexion, 'INSERT INTO PiedDeMat (IdPlancheVoile, Statut) VALUES (1, \'Reçu\');');
                        break;
                    case 'Stand Up Paddle':
                        $requete = pg_prepare($connexion, "insertion_stand_up_paddle", 'INSERT INTO StandUpPaddle (NbPlaces, Statut, Capacite, IdPrixMateriel) VALUES ($1, \'Reçu\', $2, 3);');
                        $result = pg_execute($connexion, "insertion_stand_up_paddle", array($nbPlaces, $capaciteSUP));
                        break;
                    case 'Voile':
                        $requete = pg_prepare($connexion, "insertion_voile", 'INSERT INTO Voile (IdPlancheVoile, Taille, Statut) VALUES (1, $1, \'Reçu\');');
                        $result = pg_execute($connexion, "insertion_voile", array($tailleVoile));
                        break;
                }
                echo '<script type="text/javascript"> redirection(); </script>';
            ?>
        </div>
    </body>
</html>
