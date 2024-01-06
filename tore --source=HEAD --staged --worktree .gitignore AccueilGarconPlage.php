[1mdiff --git a/.gitignore b/.gitignore[m
[1mindex 3b8f1b2..c357dcf 100644[m
[1m--- a/.gitignore[m
[1m+++ b/.gitignore[m
[36m@@ -1,5 +1,6 @@[m
 backup.css[m
[31m-OFL.txt[m
[32m+[m[32mbookmarklets/*[m
 CertificatMedical.pdf[m
[32m+[m[32mOFL.txt[m
 test.sql[m
[31m-bookmarklets/*[m
\ No newline at end of file[m
[32m+[m[32mtest_propio.sql[m
\ No newline at end of file[m
[1mdiff --git a/AccueilGarconPlage.php b/AccueilGarconPlage.php[m
[1mindex 387b069..4fc96fb 100644[m
[1m--- a/AccueilGarconPlage.php[m
[1m+++ b/AccueilGarconPlage.php[m
[36m@@ -18,9 +18,10 @@[m
         </header>[m
 [m
         <div class="corps">[m
[31m-            <h2>Bienvenue au Club Nautique Les Abeilles</h2>[m
[32m+[m[32m            <h2>Bienvenue au Club Nautique Les Abeilles <?php echo $_SESSION["identifiant"]?></h2>[m
             <div class="fonctionnalites">[m
[31m-                <a href="#" class="button">Rechercher un cours</a>[m
[32m+[m[32m                <a href="cours_de_voile.php" class="button">Rechercher un cours</a>[m
[32m+[m[32m                <a href="gestionMateriel.php" class="button">Consulter le stock de matériel</a>[m
             </div>[m
 [m
             <br><br>[m
[1mdiff --git a/AccueilMoniteur.php b/AccueilMoniteur.php[m
[1mindex 645336a..0b8101c 100644[m
[1m--- a/AccueilMoniteur.php[m
[1m+++ b/AccueilMoniteur.php[m
[36m@@ -12,28 +12,25 @@[m
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>[m
     </head>[m
     <body>[m
[31m-        <?php $index_url = ''; $current_url = 'index.php'; ?>[m
[32m+[m[32m        <?php $index_url = ''; $current_url = 'AccueilMoniteur.php'; ?>[m
         <header>[m
             <?php include('header.php')?>[m
         </header>[m
 [m
         <div class="corps">[m
[31m-            <h2>Bienvenue au Club Nautique Les Abeilles</h2>[m
[32m+[m[32m            <h2>Bienvenue au Club Nautique Les Abeilles <?php echo $_SESSION["identifiant"]?></h2>[m
             <div class="fonctionnalites">[m
[32m+[m[32m                <a href="gestionMateriel.php" class="button">Consulter le stock de matériel</a>[m
                 <a href="inscriptionClient.php" class="button">Créer un profil client</a>[m
                 <a href="rechercherClient.php" class="button">Rechercher un client</a>[m
[31m-                <a href="#" class="button">Rechercher un cours</a>[m
[31m-                <a href="inscription_client_cours_voile.php" class="button">Inscription d'un Client à un cours</a>[m
[31m-                <a href="Louer_materiel_a_client.php" class="button">Louer du materiel à un client</a>[m
[31m-[m
[32m+[m[32m                <a href="inscription_client_cours_voile.php" class="button">Inscrire un client à un cours</a>[m
             </div>[m
 [m
             <br><br>[m
 [m
             <img id="photoSurf" src="images/surf.jpg" alt="Personne qui fait du surf">[m
 [m
[31m-            <p></p>[m
[31m-        </div>[m
[32m+[m[32m        </div> <!-- end corps -->[m
 [m
         <footer>[m
             <?php include('footer.php')?>[m
[1mdiff --git a/AccueilProprietaire.php b/AccueilProprietaire.php[m
[1mindex e76c077..a18a573 100644[m
[1m--- a/AccueilProprietaire.php[m
[1m+++ b/AccueilProprietaire.php[m
[36m@@ -18,25 +18,24 @@[m
         </header>[m
 [m
         <div class="corps">[m
[31m-            <h2>Bienvenue au Club Nautique Les Abeilles</h2>[m
[32m+[m[32m            <h2>Bienvenue au Club Nautique Les Abeilles <?php echo $_SESSION["identifiant"]?></h2>[m
             <div class="fonctionnalites">[m
[32m+[m[32m                <a href="gestionMateriel.php" class="button">Consulter le stock de matériel</a>[m
                 <a href="inscriptionProprietaire.php" class="button">Créer un profil propriétaire</a>[m
                 <a href="inscriptionMoniteur.php" class="button">Créer un profil moniteur</a>[m
[31m-                <a href="creationProfilGarconDePlage.php" class="button">Créer un profil garçon de plage</a>[m
[32m+[m[32m                <a href="inscriptionGarcon.php" class="button">Créer un profil garçon de plage</a>[m
                 <a href="inscriptionClient.php" class="button">Créer un profil client</a>[m
[32m+[m[32m                <a href="inscription_client_cours_voile.php" class="button">Inscrire un client à un cours</a>[m
                 <a href="rechercherClient.php" class="button">Rechercher un client</a>[m
[32m+[m[32m                <a href="cours_de_voile.php" class="button">Consulter les cours</a>[m
                 <a href="rechercherEmploye.php" class="button">Rechercher un employé</a>[m
[31m-                <a href="afficher_liste_employes.php" class="button">Afficher la liste des employés</a>[m
[31m-                <a href="#" class="button">Rechercher un cours</a>[m
[31m-                <a href="inscription_client_cours_voile.php" class="button">Inscription d'un client à un cours</a>[m
             </div>[m
 [m
             <br><br>[m
 [m
             <img id="photoSurf" src="images/surf.jpg" alt="Personne qui fait du surf">[m
 [m
[31m-            <p></p>[m
[31m-        </div>[m
[32m+[m[32m        </div> <!-- end corps -->[m
 [m
         <footer>[m
             <?php include('footer.php')?>[m
[1mdiff --git a/afficher_liste_employes.php b/afficher_liste_employes.php[m
[1mdeleted file mode 100644[m
[1mindex ff13a9d..0000000[m
[1m--- a/afficher_liste_employes.php[m
[1m+++ /dev/null[m
[36m@@ -1,76 +0,0 @@[m
[31m-<!DOCTYPE html>[m
[31m-<html lang="fr">[m
[31m-<head>[m
[31m-    <meta charset="UTF-8">[m
[31m-    <meta name="viewport" content="width=device-width, initial-scale=1.0">[m
[31m-    <title>Liste des Employés</title>[m
[31m-    <link rel="stylesheet" href="css/styles.css"/>[m
[31m-    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">[m
[31m-    <style>[m
[31m-        .container {[m
[31m-            text-align: center;[m
[31m-            max-width: 800px;[m
[31m-            margin: 20px auto; [m
[31m-        }[m
[31m-[m
[31m-        table {[m
[31m-            width: 100%;[m
[31m-            border-collapse: collapse;[m
[31m-            margin-top: 20px; [m
[31m-        }[m
[31m-    </style>[m
[31m-</head>[m
[31m-<body>[m
[31m-    <?php $index_url = ''; $current_url = 'Afficher_liste_employes.php'; ?>[m
[31m-[m
[31m-    <header>[m
[31m-        <?php include('header.php') ?>[m
[31m-    </header>[m
[31m-[m
[31m-    <div class="container">[m
[31m-        <h2>Liste des Employés</h2>[m
[31m-[m
[31m-        <?php[m
[31m-            ini_set('display_errors', 1);[m
[31m-            ini_set('display_startup_errors', 1);[m
[31m-            session_start();[m
[31m-[m
[31m-            // Connexion à la base de données[m
[31m-            $connexion = pg_connect("host=plg-broker.ad.univ-lorraine.fr port=5432 dbname=m1_circuit_nnsh user=m1user1_14 password=m1user1_14") or die("Impossible de se connecter : " . pg_result_error($connexion));[m
[31m-[m
[31m-            // Préparation et exécution de la requête SQL pour récupérer la liste des employés[m
[31m-            $result_employes = pg_query($connexion, 'SELECT * FROM Consulterlisteemploye()');[m
[31m-[m
[31m-            // Affichage des résultats dans un tableau[m
[31m-            echo "<table border='1'>[m
[31m-                    <tr>[m
[31m-                        <th>Nom</th>[m
[31m-                        <th>Prénom</th>[m
[31m-                        <th>Mail</th>[m
[31m-                        <th>Numéro de Téléphone</th>[m
[31m-                        <th>Date de Naissance</th>[m
[31m-                        <th>Type d'Employé</th>[m
[31m-                    </tr>";[m
[31m-[m
[31m-            while ($row = pg_fetch_assoc($result_employes)) {[m
[31m-                echo "<tr>[m
[31m-                        <td>".$row['nom']."</td>[m
[31m-                        <td>".$row['prenom']."</td>[m
[31m-                        <td>".$