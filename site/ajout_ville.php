<html>
<head>
	<title>Ajouter une ville</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php
        $nom = $_POST['nom'];

        include "../model/db.php";
        include '../model/auth.php';
        $db->query("INSERT INTO ville (nom,cp,zonehoraire) VALUES ('$nom',".$_POST["code_postal"].",".$_POST["zone_horaire"].")");

        echo "<h1>La ville $nom a bien été ajoutée dans la base</h1>";
    ?>
	<p><a href='ajouter_ville.php'> Retour </a></p>
</body>
</html>
