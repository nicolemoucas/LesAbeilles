<!DOCTYPE html>
<html>
    <head>
    <link rel="stylesheet" type="text/css" href="css/inscription.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">   
        <title>Suppression profil employé</title>
        <script>
            function redirectionProprietaire() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }

            function confirmerEmployeSupprime() {
                alert("Le profil de l'employé a bien été supprimé.");
                redirectionProprietaire();
            }
        </script>
    </head>
    
    <body>
        <div>
            <h1>Suppression profil employé</h1>
        </div>
        <?php
        ini_set('display_errors', 1);
        ini_set('display_startup_errors', 1);
        session_start(); 
        
        $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

        $roleEmploye = $_GET["RoleEmploye"];
        $nomEmploye = $_GET["NomEmploye"];
        $prenomEmploye = $_GET["PrenomEmploye"];
        $dateNaissEmploye = $_GET["DateNaissEmploye"];
        $mailEmploye = $_GET["MailEmploye"];
        $telEmploye = $_GET["TelEmploye"];

        $deleteEmploye = pg_prepare($connexion, "delete_employe", "CALL p_supprimer_employe($1,$2,$3,$4,$5,$6)");
        $deleteEmploye = pg_execute($connexion, "delete_employe", array($roleEmploye, $nomEmploye, $prenomEmploye, $dateNaissEmploye, $mailEmploye, $telEmploye)); 

        if($deleteEmploye) {
            echo '<script type="text/javascript"> confirmerEmployeSupprime(); </script>';
        }
?>
    </body>
</html>