<?php
    session_start(); 
?>
<!DOCTYPE html>
<html>
    <head>
        <title> Création du profil Garçon de Plage </title>
        <script>
            function alertGarconPlageExists() {
                alert("Ce Garçon de Plage existe déjà.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }

            function alertGarconPlageCree() {
                alert("Le Garçon de Plage a été créé. Vous serez redirigé vers l'accueil.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }

            function alertGarconPlageNonCree() {
                alert("Le Garçon de Plage n'a pas pu être créé. Vous serez redirigé vers l'accueil.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de création du profil Garçon de Plage :</h1>
    </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
    
            $nomUtilisateur = $_POST["NomUtilisateur"];
            $motDePasse = $_POST["MotDePasse"];
            $nomGarconPlage = $_POST["NomGarconPlage"];
            $prenomGarconPlage = $_POST["PrenomGarconPlage"];
            $dateNaissGarconPlage = $_POST["DateNaissanceGarconPlage"];
            $mailGarconPlage = $_POST["MailGarconPlage"];
            $telGarconPlage = $_POST["TelGarconPlage"];
            $prefContactGarconPlage = $_POST["PrefContactGarconPlage"];
    
            $verifGarconPlage = pg_prepare($connexion, "verif_garcon_plage", "SELECT f_rechercher_employe('Garçon de Plage',$1,$2,$3,$4,$5)");
            $verifGarconPlage = pg_execute($connexion, "verif_garcon_plage", array($nomGarconPlage, $prenomGarconPlage, $dateNaissGarconPlage, $mailGarconPlage, $telGarconPlage)); 
            
            if(pg_num_rows($verifGarconPlage) > 0) {
                echo '<script type="text/javascript"> alertGarconPlageExists(); </script>';
            } else {
                $requete = pg_prepare($connexion, "inserer_garcon_plage", 'SELECT creer_garcon($1, $2, $3, $4, $5, $6, $7)');
                $result = pg_execute($connexion, "inserer_garcon_plage", array(
                    $nomUtilisateur,
                    $motDePasse,
                    $nomGarconPlage, 
                    $prenomGarconPlage, 
                    $dateNaissGarconPlage,  
                    $mailGarconPlage, 
                    $telGarconPlage
                ));
                if(!$result) {
                    echo '<script type="text/javascript"> alertGarconPlageNonCree(); </script>';
                }
                else {
                    $row = pg_fetch_row($result);

                    //$requete = pg_prepare($connexion, "inserer_contrat_garcon_plage", 'CALL p_creer_contrat_garcon_plage($1, $2, $3)');
                    // $result = pg_execute($connexion, "inserer_contrat_garcon_plage", array(
                    //     $dateDebutContrat,
                    //     $dateFinContrat,
                    //     $row[0]
                    // ));
                    echo '<script type="text/javascript"> alertGarconPlageCree(); </script>';
                }                
            }
        ?>
    </body>
</html>
