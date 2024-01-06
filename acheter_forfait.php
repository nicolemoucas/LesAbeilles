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

            $idClient = $_GET["idClient"];

            $requete = "SELECT possede_remise($idClient)";
            $query = pg_query($connexion, $requete);
            $remise = pg_fetch_object($query)->possede_remise;
            
            //pour la combobox ddes forfaits
            $requete = "SELECT * FROM typeforfait";
            $listeForfait = pg_query($connexion, $requete);
            $forfait_combobox_php= "";
            while ($forfait = pg_fetch_object($listeForfait)) {

                $montant = $remise ? $forfait->prix * 0.9 : $forfait->prix;
                $text = $forfait->idtypeforfait . ' seance(s) pour ' . $montant . '€';
                $forfait_combobox_php .= '<option value="' . $forfait->idtypeforfait . '">' . $text . '</option>';
            }

            //pour la combobox des préférences de contact
            $requete="SELECT unnest(enum_range(NULL::EMoyenPaiement)) AS EPaiement";
            $listePaiement = pg_query($connexion, $requete);
            $paiement_combobox_php= "";
            while ($paiement = pg_fetch_object($listePaiement)) {
                $paiement_combobox_php .= '<option value="' . $paiement->epaiement . '">' . $paiement-> epaiement . '</option>';
            }
        ?>
    <div>
        <h1>Ajouter un forfait au client</h1>
    </div>
        <div class="corps">
            <form method="post" name="formulaire" novalidate="" class="form" action="acheter_forfait_action.php">
                <input type="hidden" id="client" name="client" value="<?php echo $idClient; ?>" />
                <div>
                    <label for="forfait">Forfait</label><br>
                    <select name="forfait" class="form-control" id="forfait" required>
                        <?php echo $forfait_combobox_php; ?>
                    </select>
                </div>
                <div>
                    <label for="paiement">Moyen de Payement</label><br>
                    <select name="paiement" class="form-control" id="paiement" required>
                        <?php echo $paiement_combobox_php; ?>
                    </select>
                </div>
                <div>
                    <button class = "button">Valider l'encaissement</button>
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
        if(!confirm("Valider l'encaissement ?")) {
            event.preventDefault();
        }
    });

</script>
