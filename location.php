<?php
    // Start the session
    session_start();
?>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/inscription.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">   
        <title>Location de matériel</title>
        <script>
            function alertClientDoesntExists() {
                alert("Ce client n'existe pas. Veuillez l'inscrire.");
                window.location.href= 'http://localhost/LesAbeilles/inscriptionClient.php';
                
            }
          
            document.addEventListener("DOMContentLoaded", function() {
                var ouiButton = document.querySelector(".button:first-of-type");
                var formContainer= document.querySelector(".form-container");

                ouiButton.addEventListener("click", function() {
                    formContainer.style.display = "block";
                })
            });
        </script>
    </head>
    <body>
        <?php $index_url = ''; $current_url = 'location.php'; ?>
        <header>
            <?php include('header.php')?>
        </header>
        
    <div>
        <h1>Location de matériel</h1>
    </div>
        <div class="corps">
        
            <div class="buttons-container">
                <h3>La personne est-elle déjà cliente?</h3>
                
                <div>  
                    <button class="button">Oui</button>
                    <button class="button" onclick="javascript:alertClientDoesntExists();">Non</button> 
                </div>
        </div>
        
        <div class="form-container">
        <h2>Rechercher un client</h2><br>
               <form method="post" name="formulaire" novalidate="" class="form" action="location_recherche_materiel.php">
                              
                    <label for="NomClient" class="label">NOM</label><br>
                    <input type="text" id="NomClient" name="NomClient" placeholder="Ex : BOULANGER" required/>
                    <div id="nomError" class="error"></div><br>
                        
                    <label for="PrenomClient">Prénom</label><br>
                    <input type="text" id="PrenomClient" name="PrenomClient" placeholder="Ex : Jean Michel" required/>
                    <div id="prenomError" class="error"></div><br>
    
                    <label for="DateNaissanceClient">Date de naissance</label><br>
                    <input type="date" id="DateNaissanceClient" name= "DateNaissanceClient" placeholder="Ex : 08/01/1975" required/>
                    <div id="dateNaisError" class="error"></div><br>
                
                    <div>
                        <button class="button">Rechercher</button>
                    </div>
                </form>
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
        console.log(formulaire);
        const nomError = document.getElementById("nomError")

        if(formulaire.NomClient.validity.valid) {
            nomError.textContent = "";
            nomError.className = "error"
            formulaire.NomClient.className= "valid"
        } else {
            nomError.textContent = "Veuillez renseigner le nom du client."
            nomError.className = "error active"
            formulaire.NomClient.className= "invalid"
            isValid = false;
        }

        const prenomError = document.getElementById("prenomError")

        if(formulaire.PrenomClient.validity.valid) {
            prenomError.textContent = "";
            prenomError.className = "error"
            formulaire.PrenomClient.className= "valid"
        } else {
            prenomError.textContent = "Veuillez renseigner le prénom du client."
            prenomError.className = "error active"
            formulaire.PrenomClient.className= "invalid"
            isValid = false;
        }

        const dateNaisError = document.getElementById("dateNaisError")

        if(formulaire.DateNaissanceClient.validity.valid) {
            dateNaisError.textContent = "";
            dateNaisError.className = "error"
            formulaire.DateNaissanceClient.className= "valid"
        } else {
            dateNaisError.textContent = "Veuillez renseigner la date de naissance du client."
            dateNaisError.className = "error active"
            formulaire.DateNaissanceClient.className= "invalid"
            isValid = false;
        }

        if(!isValid) {
            event.preventDefault();
        }
});
</script>