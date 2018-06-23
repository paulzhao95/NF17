<html>
<head>
    <title>Suppression de compte</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <?php
    //récupération des informations
    $usager = $_POST['id_voy'];

    //connexion à la BDD
    require_once('../model/db.php');
    global $db;


    //on exécute la requête
    $result = $db->query("SELECT * FROM supprimerVoyageur($usager)");
    $reussite = $result->fetch();

    if ($reussite == true) { //si la fonction s'est exécutée correctement
        echo "<h1>Votre compte a bien été supprimé</h1>";
    } else {
        echo "<h1>Il y a eu une erreur</h1>";
    }
    ?>

<br><a href='accueil.html'>Retour</a>
</body>
</html>
