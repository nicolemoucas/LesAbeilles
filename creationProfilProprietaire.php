<!DOCTYPE html>
<html>
    <head>
        <title> Création du profil propriétaire </title>
        <script>
            function alertProprietaireExists() {
                alert("Ce propriétaire existe déjà. Vous allez être redirigé vers l'accueil.");
                window.location.href= 'http://localhost/LesAbeilles';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de création du profil propriétaire :</h1>
    </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            session_start(); 
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
    
            $nomUtilisateur = $_POST["NomUtilisateur"];
            $motDePasse = $_POST["MotDePasse"];
            $nomProprietaire = $_POST["NomProprietaire"];
            $prenomProprietaire = $_POST["PrenomProprietaire"];
            $dateNaissProprietaire = $_POST["DateNaissanceProprietaire"];
            $mailProprietaire = $_POST["MailProprietaire"];
            $telProprietaire = $_POST["TelProprietaire"];
            $prefContactProprietaire = $_POST["PrefContactProprietaire"];
            $dateObtentionPermis = $_POST["DateObtentionPermis"];
            $lienURLPermis = $_POST["LienURLPermis"];
    
            $verifProprietaire = pg_prepare($connexion, "verif_proprietaire", "SELECT f_rechercher_employe('Propriétaire',$1,$2,$3,$4,$5)");
            $verifProprietaire = pg_execute($connexion, "verif_proprietaire", array($nomProprietaire, $prenomProprietaire, $dateNaissProprietaire, $mailProprietaire, $telProprietaire)); 
            // echo 'nomUtilisateur : '.$nomUtilisateur.', '.$nomProprietaire.', '.$prenomProprietaire.', '.$dateNaissProprietaire.', '.$mailProprietaire.', '.$telProprietaire;
            if(pg_num_rows($verifProprietaire) != 0) {
                echo '<script type="text/javascript"> alertProprietaireExists(); </script>';
            } else {
                echo 'not exists:'.pg_num_rows($verifProprietaire).'--';
                // insérer nouveau propriétaire et récupérer son idCompte
                $requete = pg_prepare($connexion, "inserer_proprietaire", 'SELECT f_creer_proprietaire($1, $2, $3, $4, $5, $6, $7)');
                $result = pg_execute($connexion, "inserer_proprietaire", array(
                    $nomUtilisateur,
                    $motDePasse,
                    $nomProprietaire, 
                    $prenomProprietaire, 
                    $dateNaissProprietaire,  
                    $mailProprietaire, 
                    $telProprietaire
                ));
                $row = pg_fetch_row($result);
                // echo "$row[0]"; // idCompte

                $requete = pg_prepare($connexion, "inserer_permis", 'CALL p_creer_permis($1, $2, $3)');
                $result = pg_execute($connexion, "inserer_permis", array(
                    $dateObtentionPermis,
                    $lienURLPermis,
                    $row[0]
                ));
                // alert("Le compte propriétaire pour $prenomProprietaire $nomProprietaire a été créé.");
                header('Location: http://localhost/LesAbeilles');
            }
        ?>
        <p></p>
    </body>
</html>
