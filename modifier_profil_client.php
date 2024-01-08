<?php
    session_start(); 
?>
<!DOCTYPE html>
<html>
    <head>
        <title> Modifier Profil Client </title>
        <script>
            function alertMoniteurExists() {
                alert("Ce client existe déjà.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de Modification du profil client :</h1>
    </div>
        <?php
            ini_set('display_errors', 0);
            ini_set('display_startup_errors', 0);

            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));
            

            $idClient = $_GET["idClient"];
            $NomClient = $_GET["NomClient"];
            $PrenomClient = $_GET["PrenomClient"];
            $DateNaissClient = $_GET["DateNaissClient"];
            $MailClient = $_GET["MailClient"];
            $TelClient = $_GET["TelClient"];
            $PrefContactClient = $_GET["PrefContactClient"];
            $CampingClient = $_GET["CampingClient"];
            $TailleClient = $_GET["TailleClient"];
            $PoidsClient = $_GET["PoidsClient"];
            $StatutClient = $_GET["StatutClient"];

            $requete = pg_prepare($connexion, "modifier_client", 'CALL modifier_profil_client($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)');
                $result = pg_execute($connexion, "modifier_client", array(
                    $idClient,
                    $NomClient,
                    $PrenomClient,
                    $DateNaissClient,
                    $MailClient,
                    $TelClient,
                    $PrefContactClient,
                    $CampingClient,
                    $TailleClient,
                    $PoidsClient,
                    $StatutClient
                ));
                $row = pg_fetch_row($result);
                header('Location: http://localhost/LesAbeilles/AccueilProprietaire.php');
    
?>
