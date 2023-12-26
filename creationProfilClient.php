<!DOCTYPE html>
<html>
    <head>
        <title> Création du profil client </title>
        <script>
            function alertClientExists() {
                alert("Ce client existe déjà.");
                window.location.href= 'http://localhost/LesAbeilles';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de création du profil client :</h1>
    </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start(); 
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            $nomClient = $_POST["NomClient"];
            $prenomClient = $_POST["PrenomClient"];
            $dateNaissClient = $_POST["DateNaissanceClient"];
            $mailClient = $_POST["MailClient"];
            $telClient = $_POST["TelClient"];
            $campingClient = $_POST["CampingClient"];
            $statutClient = $_POST["StatutClient"];
            $poidsClient = $_POST["PoidsClient"];
            $tailleClient = $_POST["TailleClient"];
            $prefContactClient = $_POST["PrefContactClient"];

            $verifClient = pg_prepare($connexion, "my_verif", 'SELECT recherche_client($1,$2,$3)');
            $verifClient = pg_execute($connexion, "my_verif", array($nomClient, $prenomClient, $dateNaissClient)); 
            
            if(pg_num_rows($verifClient) > 0) {
                echo '<script type="text/javascript"> alertClientExists(); </script>';
;
            } else {
                $requete = pg_prepare($connexion, "my_query", 'CALL creer_client($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)');
                $result = pg_execute($connexion, "my_query", array(
                    $nomClient, 
                    $prenomClient, 
                    $dateNaissClient,  
                    $mailClient, 
                    $telClient, 
                    $campingClient, 
                    $statutClient, 
                    $poidsClient, 
                    $tailleClient, 
                    $prefContactClient
                )); 
                header('Location: http://localhost/LesAbeilles');
            }
        ?>
    </body>
</html>
