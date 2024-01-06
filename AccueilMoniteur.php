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
        <?php $current_url = 'AccueilMoniteur.php'; ?>
        <header>
            <?php include('header.php')?>
        </header>

        <div class="corps">
            <h2>Bienvenue au Club Nautique Les Abeilles, <?php echo $_SESSION["identifiant"]?></h2>
            <div class="fonctionnalites">
                <a href="inscriptionClient.php" class="button">Créer un profil client</a>
                <a href="rechercherClient.php" class="button">Rechercher un client</a>
                <a href="consulter_locations.php" class="button">Consulter les locations</a>
                <a href="Location.php" class="button">Louer du materiel à un client</a>
                <a href="location_en_cours.php" class="button">Consulter les locations en cours</a>
            

            </div>

            <br><br>

            <img id="photoSurf" src="images/surf.jpg" alt="Personne qui fait du surf">

        </div> <!-- end corps -->

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
