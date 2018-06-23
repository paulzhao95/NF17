<html>
<head>
    <title>Affichage des informations de l'usager</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <?php
    //récupération des informations
    $prenom = $_POST['prenom'];
    $nom = $_POST['nom'];

    //connexion à la BDD
    require_once('../model/db.php');
    global $db;

    //on vérifie si le compte existe déjà
    $result = $db->query("SELECT Id, Adresse, TypeVoyageur, NumeroCarte FROM Voyageur WHERE Nom LIKE '$nom' AND Prenom LIKE '$prenom'");
    $voyageurs = $result->fetchAll();

    if ($voyageurs == null) { //s'il n'y a pas de résultat pour cette recherche
        echo "<p>Vous n'êtes pas dans notre base de données. <a href='creer_compte.html'>Créez un compte</a>.</p>";
    } else {
        echo "<p>Voici le résultat de la recherche $prenom $nom&nbsp:</p>";
        echo "<table><tr><td>Id</td>";
        echo "<td>Adresse</td>";
        echo "<td>Statut</td>";
        echo "<td>Numéro de carte de fidélité</td></tr>";
        foreach ($voyageurs as $voyageur) {
            echo "<tr><td>$voyageur[0]</td>";
            echo "<td>$voyageur[1]</td>";
            echo "<td>$voyageur[2]</td>";
            echo "<td>$voyageur[3]</td></tr>";
        }
        echo "</table>";
    }
    ?>

<br><a href='accueil.html'>Retour</a>
</body>
</html>
