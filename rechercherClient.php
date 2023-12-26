<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="inscriptionClient.css" />
        <link rel="stylesheet" href="css/styles.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">    
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">    
        <title>Rechercher un client</title>
    </head>
    
    <body>
        <header>
            <?php include('header.php')?>
        </header>
        <div>
            <h1>Rechercher un client</h1>
            <form method="post" name="formulaire" novalidate="" class="form" action="afficherProfilClient.php">

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