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
        <img id="logo_les_abeilles" src="images/les_abeilles_logo.png" alt="Logo du Club Nautique Les Abeilles">
        <h1>Club Nautique Les Abeilles</h1>
        <div class="header">
            <br><br><br><br>
        </div>
    </body>
<html>
