<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Les Abeilles</title>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>
    </head>
    <body>
        <?php $current_url = 'index.php'; ?>
        

        <div class="corps">
            <h2>Location d'un matériel</h2>
            <div class="fonctionnalites">
                <a href="louer_planche_a_voile.php" class="button">Louer une planche à voile</a>
                <a href="louer_catamaran.php" class="button">Louer un catamaran</a>
                <a href="louer_stand_up_paddle.php" class="button">Louer un stand up paddle</a>
                <a href="louer_pedalo.php" class="button">Louer un pédalo</a>
            

            </div>

            <br><br>

            <img id="photoSurf" src="images/surf.jpg" alt="Personne qui fait du surf">

            <p></p>
        </div>

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
