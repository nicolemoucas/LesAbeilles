<!DOCTYPE html>
session_start(); 
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/inscription.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">    
        <title>Création du profil garçon de plage</title>
        <script>
            function alertGarconDePlageExists() {
                alert("Ce garçon de plage existe déjà.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }
        </script>
        <style>
            label {
                display: block;
                margin-bottom: 10px;
            }
    
            input[type="submit"] {
                background-color: #4caf50;
                color: #fff;
                cursor: pointer;
                margin-top: 10px; 
            }
    
            input[type="submit"]:hover {
                background-color: #45a049;
            }
    
            p.error-message {
                color: red;
                margin-top: -10px;
                margin-bottom: 10px;
                text-align: center;
            }
    
            form {
                margin-left: 15px;
            }
        </style>
    </head>
    <body>
        <header>
            <?php include('header.php')?>
        </header>
        <div>
            <h1>Création du Garçon de Plage :</h1>
        </div>
    
        <form action="creationProfilGarconDePlage.php" method="post">
            <label for="NomGarconPlage">Nom :</label>
            <input type="text" name="NomGarconPlage" required><br>
    
            <label for="PrenomGarconPlage">Prénom :</label>
            <input type="text" name="PrenomGarconPlage" required><br>
    
            <label for="DateNaissanceGarconPlage">Date de naissance (Format : YYYY-MM-DD) :</label>
            <input type="text" name="DateNaissanceGarconPlage" required><br>
    
            <label for="MailGarconPlage">Adresse e-mail :</label>
            <input type="email" name="MailGarconPlage" required><br>
    
            <label for="TelGarconPlage">Numéro de téléphone :</label>
            <input type="tel" name="TelGarconPlage" required><br>
    
            <label for="IdentifiantGarconPlage">Identifiant :</label>
            <input type="text" name="IdentifiantGarconPlage" required><br>
    
            <label for="MotDePasseGarconPlage">Mot de passe :</label>
            <input type="password" name="MotDePasseGarconPlage" required><br>
    
            <input type="submit" value="Créer le profil">
        </form>
    
        <?php
        
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            
    
            // Récupération des valeurs du formulaire
            $nomGarconPlage = isset($_POST["NomGarconPlage"]) ? $_POST["NomGarconPlage"] : "";
            $prenomGarconPlage = isset($_POST["PrenomGarconPlage"]) ? $_POST["PrenomGarconPlage"] : "";
            $dateNaissanceGarconPlage = isset($_POST["DateNaissanceGarconPlage"]) ? $_POST["DateNaissanceGarconPlage"] : "";
            $mailGarconPlage = isset($_POST["MailGarconPlage"]) ? $_POST["MailGarconPlage"] : "";
            $telGarconPlage = isset($_POST["TelGarconPlage"]) ? $_POST["TelGarconPlage"] : "";
            $identifiantGarconPlage = isset($_POST["IdentifiantGarconPlage"]) ? $_POST["IdentifiantGarconPlage"] : "";
            $motDePasseGarconPlage = isset($_POST["MotDePasseGarconPlage"]) ? $_POST["MotDePasseGarconPlage"] : "";
    
            // Vérification du format de date
            if (!empty($dateNaissanceGarconPlage) && !preg_match("/^\d{4}-\d{2}-\d{2}$/", $dateNaissanceGarconPlage)) {
                echo '<p style="color: red;">Format de date incorrect. Utilisez le format YYYY-MM-DD.</p>';
                // ... Votre code pour gérer l'erreur ici, si nécessaire
            } else {
                // Connexion à la base de données
                $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));
    
                // Vérification de l'existence du garçon de plage
                $verifGarconDePlage = pg_prepare($connexion, "my_verif", 'SELECT f_rechercher_employe($1, $2, $3, $4, $5)');
                $verifGarconDePlage = pg_execute($connexion, "my_verif", array($nomGarconPlage, $prenomGarconPlage, $dateNaissanceGarconPlage, $mailGarconPlage, $telGarconPlage));
    
                // Vérification du succès de la requête
                if ($verifGarconDePlage === false) {
                    echo "Erreur lors de l'exécution de la requête.\n";
                    // ... Votre code pour gérer l'erreur ici, si nécessaire
                } else {
                    // Utilisation de pg_num_rows seulement si la requête a réussi
                    if (pg_num_rows($verifGarconDePlage) > 0) {
                        // Garçon de plage existe déjà
                        echo '<script type="text/javascript"> alertGarconDePlageExists(); </script>';
                    } else {
                        // Garçon de plage n'existe pas, vous pouvez procéder à l'insertion
                        $requete = pg_prepare($connexion, "my_query", 'CALL creer_garcon_de_plage($1, $2, $3, $4, $5, $6, $7, $8)');
                        $result = pg_execute($connexion, "my_query", array(
                            $nomGarconPlage,
                            $prenomGarconPlage,
                            $dateNaissanceGarconPlage,
                            $mailGarconPlage,
                            $telGarconPlage,
                            $identifiantGarconPlage,
                            $motDePasseGarconPlage
                        ));
    
                        // Redirection après l'insertion
                        header('Location: http://localhost/LesAbeilles/AccueilProprietaire.php');
                    }
                }
    
                // Fermeture de la connexion
                pg_close($connexion);
            }
        ?>
        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
