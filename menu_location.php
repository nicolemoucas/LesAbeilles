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
                <a href="#" class="button" onclick="redirectTo('location.php')">Louer Planche à voile</a>
                <a href="#" class="button" onclick="redirectTo('standuppaddle_disponible.php')">Louer Stand Up Paddle</a>
                <a href="#" class="button" onclick="redirectTo('location.php')">Louer Catamaran</a>
                <a href="#" class="button" onclick="redirectTo('location.php')">Louer Pédalo</a>
            </div>

            <script>
                function redirectTo(page) {
                    const urlParams = new URLSearchParams(window.location.search);
                    const idClient = urlParams.get('idClient');
                    window.location.href = `${page}?idClient=${idClient}`;
                }
            </script>
        </div>
    
        <footer>
            <?php include('footer.php') ?>
        </footer>
    </body>
</html>
