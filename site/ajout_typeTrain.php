<html>
<head>
	<title>Créer un nouveau type de train</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php
        include "../model/db.php";
        include '../model/auth.php';
        $db->query("INSERT INTO TypeTrain (Nom, nbPlacesPrem, nbPlacesSec, vitesseMax) VALUES ('".$_POST['nom']."',".$_POST['nb_prem'].",".$_POST['nb_sec'].",".$_POST['vitesse'].")");

        echo "<h1>Vous avez bien créé le type de train</h1>";
    ?>
	<a href='ajouter_typeTrain.php'> Retour </a>
</body>
</html>
