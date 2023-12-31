<?php 
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Les Abeilles</title>
        <link rel="stylesheet" href="css/header.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>
    </head>
    <script>
        function redirectionPropriétaire() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }

            function redirectionMoniteur() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilMoniteur.php';
            }

            function redirectionGarconPlage() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilGarconPlage.php';
            }

            function redirection(role){
                switch (role) {
                    case 'Propriétaire':
                        redirectionPropriétaire();
                        break;
                    case 'Moniteur':
                        redirectionMoniteur();
                        break;
                    case 'Garçon de Plage':
                        redirectionGarconPlage();
                        break;
                }
            }
    </script>
    <body>
        <div class="header">
        <h1>Club Nautique Les Abeilles</h1>
            <br><br>
            <div class="header-links">
                <ul>
                    <li <?php if($current_url == 'index.php'){ echo 'class="current"';}?>>
                        <a href="javascript:redirection('<?php echo $_SESSION["role"]?>')" class="logo-home"><i class="fa fa-home"></i>&nbsp; Les Abeilles</a>
                    </li>
                    <li <?php if($current_url == 'planning.php'){ echo 'class="current"';}?>>
                        <a href="#.php">Planning</a>
                    </li>
                    <li <?php if($current_url == 'cours_de_voile.php'){ echo 'class="current"';}?>>
                        <a href="menu_cours_voile.php">Cours de Voile</a>
                    </li>
                    <li <?php if($current_url == 'gestion_materiel.php'){ echo 'class="current"';}?>>
                        <a href="gestion_materiel.php">Gestion du Matériel</a>
                    </li>
                    <li>
                        <a href="index.php">Déconnexion</a>
                    </li>
                </ul>
            </div>
        </div>
    </body>
<html>
