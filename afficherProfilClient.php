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
        <title>Profil client</title>
        <script>
            function redirectionProprietaire() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }

            function redirectionMoniteur() {
                window.location.href= 'http://localhost/LesAbeilles/AccueilMoniteur.php';
            }

            function redirection(role){
                switch (role) {
                    case 'Propriétaire':
                        redirectionProprietaire();
                        break;
                    case 'Moniteur':
                        redirectionMoniteur();
                        break;
                }
            }
            function alertClientExists(role) {
                alert("Ce client n'existe pas. Vous serez redirigé sur l'écran d'accueil.");
                switch (role) {
                    case 'Propriétaire':
                        redirectionProprietaire();
                        break;
                    case 'Moniteur':
                        redirectionMoniteur();
                        break;
                }
            }
        </script>
    </head>
    <body>
        <header>
            <?php include('header.php')?>
        </header>
        
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);
            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));

            $nomClient = $_POST["NomClient"];
            $prenomClient = $_POST["PrenomClient"];
            $dateNaissClient = $_POST["DateNaissanceClient"];
    
            $recupClient = pg_prepare($connexion, "recup_client", 'SELECT * FROM recherche_client($1,$2,$3)');
            $recupClient = pg_execute($connexion, "recup_client", array($nomClient, $prenomClient, $dateNaissClient)); 

            if(pg_num_rows($recupClient) == 0) {
                echo '<script type="text/javascript"> alertClientExists("'.$_SESSION["role"].'"); </script>';
            } else {
                $row = pg_fetch_object($recupClient);
                
            }
            //pour la combobox des noms des campings
            $requete = "SELECT unnest(enum_range(NULL::ECamping)) AS ECamp";
            $listeCampings = pg_query($connexion, $requete);
            $campings_combobox_php = "";
            while ($option = pg_fetch_object($listeCampings)) {
                $cselected = $option->ecamp == $row->campingcl ? ' selected' : '';
                $campings_combobox_php .= '<option value="' . $option->ecamp . '"' .$cselected . '>' . $option->ecamp . '</option>';
            }

            //pour la combobox des préférences de contact
            $requete="SELECT unnest(enum_range(NULL::EPreferenceContact)) AS EPrefContact";
            $listePrefContact = pg_query($connexion, $requete);
            $prefContact_combobox_php= "";
            while ($option = pg_fetch_object($listePrefContact)) {
                $pselected = $option->eprefcontact == $row->preferencecontactcl ? ' selected' : '';
                $prefContact_combobox_php .= '<option value="' . $option->eprefcontact . '"' .$pselected . '>' . $option->eprefcontact . '</option>';
            }
            
            //pour la combobox des statuts des clients
            $requete="SELECT unnest(enum_range(NULL::EStatutClient)) AS EStatut";
            $listeStatutClient = pg_query($connexion, $requete);
            $statut_combobox_php= "";
            while ($option = pg_fetch_object($listeStatutClient)) {
                $selected = $option->estatut == $row->statutcl ? ' selected' : '';
                $statut_combobox_php .= '<option value="' . $option->estatut . '"' .$selected . '>' . $option->estatut . '</option>';
            }
        ?>
    <div>
        <h1>Profil client : <?php echo $row->prenomcl . ' ' .$row->nomcl?></h1>
    </div>
        <div class="corps">
            <form method="post" name="formulaire" novalidate="" class="form">
            <div>
                <button class="button" formaction="javascript:redirection('<?php echo $_SESSION["role"]?>')">Retour</a>
                <button class="button" formaction="#">Modifier le profil</button>
                <?php if ($_SESSION["role"] === 'Propriétaire') 
                echo '<button class= "button" formaction="javascript:confirmerSuppression()">Supprimer le profil</button>'?>
            </div>
                <label for="NomClient" class="label">NOM</label><br>
                <input type="text" id="NomClient" name="NomClient" placeholder="Ex : BOULANGER" value= "<?php echo $row->nomcl ?>" required/>
                <div id="nomError" class="error"></div><br>
                    
                <label for="PrenomClient">Prénom</label><br>
                <input type="text" id="PrenomClient" name="PrenomClient" placeholder="Ex : Jean Michel" value= "<?php echo $row->prenomcl ?>" required/>
                <div id="prenomError" class="error"></div><br>

                <label for="DateNaissanceClient">Date de naissance</label><br>
                <input type="date" id="DateNaissanceClient" name= "DateNaissanceClient" placeholder="Ex : 08/01/1975" value= "<?php echo $row->datenaissancecl ?>" required/>
                <div id="dateNaisError" class="error"></div><br>

                <label for="MailClient"> Email </label><br>
                <input type="email" id="MailClient" name="MailClient" placeholder="Ex : boulangerjm@free.fr"value= "<?php echo $row->mailcl ?>" /><br><br>

                <label for="TelClient" pattern="0[0-9]{9}" value="<?php echo $row->numtelephonecl ?>" >Numéro de téléphone</label><br>
                <input type="text" id="TelClient" name="TelClient" placeholder="Ex : 0777764231"/><br><br>

                <div>
                <label for="PrefContactClient">Préférence de contact</label><br>
                    <select name="PrefContactClient" class="form-control" id="PrefContactClient" value= "<?php echo $row->preferencecontactcl ?>" required >
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $prefContact_combobox_php; ?>
                    </select>
                    <div id="prefContactError" class="error"></div><br>
                </div>

                <div>
                    <label for="CampingClient">Camping</label><br>
                    <select name="CampingClient" class="form-control" id="CampingClient" required>
                        <?php echo $campings_combobox_php; ?>
                    </select>
                </div>
                <br><br>

                <label for="TailleClient">Taille (en cm)</label>
                <input type="number" min=0 id="TailleClient" name="TailleClient" placeholder="Ex : 170" value= "<?php echo $row->taillecl ?>" required/>
                <div id="tailleError" class="error"></div><br>

                <label for="PoidsClient">Poids (en kg)</label>
                <input type="number" min=0 id="PoidsClient" name="PoidsClient" placeholder="Ex : 80" value="<?php echo $row->poidscl ?>" required/>
                <div id="poidsError" class="error"></div><br>

                <div>
                <label for="StatutClient">Niveau sportif</label><br>
                    <select name="StatutClient" class="form-control" id="StatutClient" value= "<?php echo $row->statutcl ?>" required>
                        <option disabled selected value> -- Sélectionnez une option -- </option>
                        <?php echo $statut_combobox_php; ?>
                    </select> 
                    <div id="statutError" class="error"></div><br>
                </div>
            
            </form>
        </div>

        <footer>
            <?php include('footer.php')?>
        </footer>
    </body>
</html>
<script>
    function confirmerSuppression() {
        const formulaire = document.formulaire;
        if(confirm("Voulez-vous vraiment supprimer le profil de ce client ?")) {
            const url = 'supprimerProfilClient.php?nom=' + formulaire.NomClient.value + '&prenom=' + formulaire.PrenomClient.value  + '&dateNaiss=' + formulaire.DateNaissanceClient.value ;
            document.location= url;
        }
    }
</script>