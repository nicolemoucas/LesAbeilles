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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
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
    <body class="header">
        <h1>Club Nautique Les Abeilles</h1>
        <a href="javascript:redirection('<?php echo $_SESSION["role"]?>')" class="logo">
            <img id="logo_les_abeilles" src="images/les_abeilles_logo.png" alt="Logo du Club Nautique Les Abeilles">
        </a>
        <div class="header-right">
            <a <?php if($current_url == 'AccueilProprietaire.php' || $current_url == 'AccueilMoniteur.php'  || $current_url == 'AccueilGarconPlage.php' ){ echo 'class="current"'; }?>
                href="javascript:redirection('<?php echo $_SESSION["role"]?>')" class="logo-home"><i class="fa fa-home"></i>&nbsp; Les Abeilles
            </a>

            <a <?php if($current_url == 'menu_cours_de_voile.php' || $current_url == 'cours_de_voile.php'){ echo 'class="current"'; }?>
                href="menu_cours_voile.php">Cours de Voile
            </a>

            <a <?php if($current_url == 'gestionMateriel.php'){ echo 'class="current"'; }?>
                href="gestionMateriel.php">Gestion du Matériel
            </a>
            
            <a href="index.php"><i class="fa fa-sign-out" aria-hidden="true"></i>&nbsp; Déconnexion</a>
            
            </nav>
        </div>
    </body>
<html>
