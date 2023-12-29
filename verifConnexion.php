<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Les Abeilles</title>
        <link rel="stylesheet" href="css/connexion.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>
    </head>
    <script>
        function connexionImpossible() {
                    alert("Votre identifiant ou votre mot de passe est erroné. Veuillez réessayer.");
                    window.location.href= 'http://localhost/LesAbeilles/NomProvisoire.php';
                }
        function redirectionPropriétaire() {
            window.location.href= 'http://localhost/LesAbeilles/AccueilPropriétaire.php';
        }

        function redirectionMoniteur() {
            window.location.href= 'http://localhost/LesAbeilles/AccueilMoniteur.php';
        }

        function redirectionGarconPlage() {
            window.location.href= 'http://localhost/LesAbeilles/AccueilGarconPlage.php';
        }

     </script>
    <body>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);

            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=connexion_user password=connexion") or die("Impossible de se connecter : " . pg_result_error($connexion));
            $idUtilisateur = $_POST["identifiant"];
            $mdpUtilisateur = $_POST["mdp"];

            $verifConnexion = pg_prepare($connexion, "my_verif", 'SELECT verification_utilisateur($1,$2)');
            $verifConnexion = pg_execute($connexion, "my_verif", array($idUtilisateur, $mdpUtilisateur));
 
            $response = pg_fetch_object($verifConnexion);
            if($response->verification_utilisateur === 't'){
                $roleEmploye = pg_prepare($connexion, "role_employe", 'SELECT fetch_role_utilisateur($1,$2)');
                $roleEmploye = pg_execute($connexion, "role_employe", array($idUtilisateur, $mdpUtilisateur));

                $role = pg_fetch_object($roleEmploye);
                $_SESSION["identifiant"] = $idUtilisateur;
                $_SESSION["motdepasse"] = $mdpUtilisateur;
                $_SESSION["role"]= $role->fetch_role_utilisateur;

               switch ($role->fetch_role_utilisateur) {
                    case 'Propriétaire':
                        echo '<script type="text/javascript"> redirectionPropriétaire(); </script>';
                        break;
                    case 'Moniteur':
                        echo '<script type="text/javascript"> redirectionMoniteur(); </script>';
                        break;
                    case 'Garçon de Plage':
                        echo '<script type="text/javascript"> redirectionGarconPlage(); </script>';
                        break;
                } 
            } else {
                echo '<script type="text/javascript"> connexionImpossible(); </script>';
            }
        ?>
    </body>
</html>