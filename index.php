<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Les Abeilles</title>
        <link rel="stylesheet" href="css/connexion.css"/>
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>
    </head>
    <body>
        <?php $current_url = 'index.php'; ?>
        <header>
            <?php include('header_index.php')?>
        </header>
        <div class="corps">
                <h1>Connexion</h1>
                <div>
                    <form method="post" name="formulaire" novalidate="" class="form" action="verifConnexion.php">

                        <label for="identifiant" class="label">Identifiant</label><br>
                        <input type="text" id="identifiant" name="identifiant"  required/>
                        <div id="idError" class="error"></div><br>
                        
                        <label for="mdp" class="label">Mot de passe</label><br>
                        <input type="password" id="mdp" name="mdp"  required/>
                        <div id="mdpError" class="error"></div><br>

                        <div>
                            <button class = "button">Connexion</button>
                        </div>
                    </form>
                </div>
                <div class="image-div">
                    <img id="photoSurf" src="images/surf.jpg" alt="Personne qui fait du surf">
                </div>
        </div>
        
        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
<script>
    const formulaire = document.formulaire;
    formulaire.addEventListener("submit", (event) => {
        let isValid = true;

        if((!formulaire.identifiant.value) &&(!formulaire.mdp.value)) {
            alert("Il faut renseigner votre identifiant et votre mot de passe.")
            formulaire.identifiant.className="invalid"
            formulaire.mdp.className="invalid"
            isValid = false;
        }

        const idError = document.getElementById("idError")

        if(formulaire.identifiant.validity.valid) {
            idError.textContent = "";
            idError.className = "error"
        } else {
            idError.textContent = "Veuillez renseigner votre identifiant."
            idError.className = "error active"
            formulaire.identifiant.className= "invalid"
            isValid = false;
        }

        const mdpError = document.getElementById("mdpError")

        if(formulaire.mdp.validity.valid) {
            mdpError.textContent = "";
            mdpError.className = "error"
        } else {
            mdpError.textContent = "Veuillez renseigner votre mot de passe."
            mdpError.className = "error active"
            formulaire.mdp.className= "invalid"
            isValid = false;
        }

        if(!isValid) {
            event.preventDefault();
        }
});
</script>