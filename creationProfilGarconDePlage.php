<!DOCTYPE html>
<html>
    <head>
        <title> Création du profil garçon de plage </title>
        <script>
            function alertGarconExists() {
                alert("Ce garçon de plage existe déjà.");
                window.location.href= 'http://localhost/LesAbeilles';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de création du profil garçon de plage :</h1>
    </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start(); 
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));

            $nomGarcon = $_POST["NomGarcon"];
            $prenomGarcon = $_POST["PrenomGarcon"];
            $dateNaissanceGarcon = $_POST["DateNaissanceGarcon"];
            $mailGarcon = $_POST["MailGarcon"];
            $telGarcon = $_POST["TelGarcon"];
            

            $verifGarcon = pg_prepare($connexion, "my_verif", 'SELECT recherche_garcon_de_plage($1,$2,$3)');
            $verifGarcon = pg_execute($connexion, "my_verif", array($nomGarcon, $prenomGarcon, $dateNaissanceGarcon)); 
            
            if(pg_num_rows($verifGarcon) > 0) {
                echo '<script type="text/javascript"> alertGarconExists(); </script>';
;
            } else {
                $requete = pg_prepare($connexion, "my_query", 'CALL creer_profil_garcon_de_plage($1, $2, $3, $4, $5)');
                $result = pg_execute($connexion, "my_query", array(
                    $nomGarcon, 
                    $prenomGarcon, 
                    $dateNaissGarcon,  
                    $mailGarcon, 
                    $telGarcon
                )); 
                header('Location: http://localhost/LesAbeilles');
            }
        ?>
    </body>
</html>
