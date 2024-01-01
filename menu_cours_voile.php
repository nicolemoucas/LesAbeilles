<?php
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cours de voile</title>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body>
        <?php $current_url = 'cours_de_voile.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>
    
        <div class="container">
            <h2>Cours de voile</h2>
            <div class="fonctionnalites">
            <?php if ($_SESSION["role"] === 'Propriétaire') 
                    echo '<a href="organiser_cours_voile.php" class="button">Organiser un cours de voile</a>' ?>
                    <a href="cours_de_voile.php" class="button">Consulter les cours de voile</a>
            </div>
        </div>
    
        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
</html>
