<?php
    session_start(); 
?>
<!DOCTYPE html>
<html>
    <head>
        <title> Modifier Profil Employe </title>
        <script>
            function alertMoniteurExists() {
                alert("Ce moniteur existe déjà.");
                window.location.href= 'http://localhost/LesAbeilles/AccueilProprietaire.php';
            }
        </script>
    </head>
    <body>
    <div>
        <h1>Formulaire de Modification du profil employe :</h1>
    </div>
        <?php
            ini_set('display_errors', 1);
            ini_set('display_startup_errors', 1);

            
            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=" .$_SESSION["identifiant"]." password=" . $_SESSION["motdepasse"]) or die("Impossible de se connecter : " . pg_result_error($connexion));
            

            $idEmploye = $_GET["idEmploye"];
            $NomEmploye = $_GET["NomEmploye"];
            $PrenomEmploye = $_GET["PrenomEmploye"];
            $DateNaissEmploye = $_GET["DateNaissEmploye"];
            $MailEmploye = $_GET["MailEmploye"];
            $TelEmploye = $_GET["TelEmploye"];


            $requete = pg_prepare($connexion, "modifier_employe", 'CALL modifier_employe($1, $2, $3, $4, $5, $6)');
                $result = pg_execute($connexion, "modifier_employe", array(
                    $idEmploye,
                    $NomEmploye,
                    $PrenomEmploye, 
                    $DateNaissEmploye, 
                    $MailEmploye,  
                    $TelEmploye
                ));
                $row = pg_fetch_row($result);
                // echo '<script>console.log("id compte : ' . $row[0] . '"); </script>'; // idCompte
                // alert("Le compte moniteur pour $prenomMoniteur $nomMoniteur a été créé.");
                header('Location: http://localhost/LesAbeilles/AccueilProprietaire.php');
    
?>