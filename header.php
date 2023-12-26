<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Les Abeilles</title>
        <link rel="stylesheet" href="css/header.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>
    </head>
    <body>
        <div class="header">
        <h1>Club Nautique Les Abeilles</h1>
            <br><br>
            <div class="header-links">
                <ul>
                    <li <?php if($current_url == 'index.php'){ echo 'class="current"';}?>>
                        <a href="index.php" class="logo-home"><i class="fa fa-home"></i>&nbsp; Les Abeilles</a>
                    </li>
                    <li <?php if($current_url == 'planning.php'){ echo 'class="current"';}?>>
                        <a href="#.php">Planning</a>
                    </li>
                    <li <?php if($current_url == 'cours_de_voile.php'){ echo 'class="current"';}?>>
                        <a href="cours_de_voile.php">Cours de Voile</a>
                    </li>
                    <li <?php if($current_url == 'gestion_materiel.php'){ echo 'class="current"';}?>>
                        <a href="#.php">Gestion du Matériel</a>
                    </li>
                </ul>
            </div>
        </div>
    </body>
<html>