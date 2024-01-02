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
        <?php $current_url = 'location.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>
    
        <div class="container">
            <h2>Location de Matériel</h2>
            <div class="fonctionnalites">
            
            <a href="location.php" class="button">Louer du matériel</a>
            </div>
        </div>
    
        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
</html>
