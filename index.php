<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Club Nautique</title
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f0f8ff; 
                color: #333;
            }

            header {
                background-color: #0066cc; 
                padding: 10px;
                margin: 0 10px;
                text-align: center;
                color: #fff; 
            }

            nav {
                background-color: #87ceeb; 
                padding: 10px;
                text-align: center;
            }

            nav a {
                text-decoration: none;
                color: #333;
                padding: 10px;
                margin: 0 10px;
                border-radius: 5px;
                background-color: #fff; 
            }

            nav a:hover {
                background-color: #add8e6; 
            }

            .container {
                max-width: 1200px;
                margin: 20px auto;
                padding: 20px;
                background-color: #fff; 
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); 
            }

            footer {
                background-color: #0066cc; 
                padding: 10px;
                text-align: center;
                color: #fff;
                position: fixed;
                bottom: 0;
                width: 100%;
            }

            .button {
                display: inline-block;
                padding: 10px 20px;
                font-size: 16px;
                text-align: center;
                text-decoration: none;
                background-color: #0066cc; 
                color: #fff; 
                border-radius: 5px;
                cursor: pointer;
                margin: 10px; 
            }

            .button:hover {
                background-color: #004080; 
            }
        </style>
    </head>
    <body>
        <header>
            <h1>Club Nautique</h1>
        </header>
        
        <nav>
            <a href="index.php">Accueil</a>
            <a href="cours_de_voile.php">Cours de Voile</a>
            <a href="#">Gestion du Matériel</a>
        </nav>

        <div class="container">
    
            <h2>Bienvenue au Club Nautique</h2>
            <p>Ce n'est qu'une proposition car je stress :D ...</p>

            <a href="#" class="button">Créer un employé</a>
            <a href="inscriptionClient.php" class="button">Créer un profil Client</a>
            <a href="#" class="button">Rechercher Client</a>
            <a href="#" class="button">Rechercher Cours</a>
        </div>

        <footer>
            &copy; 2023 Club Nautique
        </footer>
    </body>
</html>
