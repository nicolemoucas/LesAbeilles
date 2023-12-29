<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestion du matériel</title>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body>
        <?php $current_url = 'gestion_materiel.php'; ?>
        <header>
            <?php include('header.php') ?>
        </header>
    
        <div class="container">
            <h2>Gestion du matériel</h2>
            <div class="fonctionnalites">
                    <a href="#.php" class="button">Recevoir du matériel</a>
                    <a href="changer_etat_materiel.php" class="button">Gestion de l'état du matériel</a>
            </div>
        </div>
    
        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
</html>
