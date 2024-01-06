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
        <?php $index_url = ''; $current_url = 'menu_cours_de_voile.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>
    
        <div class="container corps">
            <h2>Cours de voile</h2>
            <div class="fonctionnalites">
                <?php 
                    if ($_SESSION["role"] === 'Propriétaire') 
                    echo '<a href="organiser_cours_voile.php" class="button">Organiser un cours de voile</a>' 
                ?>
                <a href="cours_de_voile.php" class="button">Consulter les cours de voile</a>
            </div>

        <br><br>

         <img id="photoSurf" src="images/surf.jpg" alt="Personne qui fait du surf">
        </div>
    
        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
</html>
