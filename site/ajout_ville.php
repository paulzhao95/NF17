<html>
<head>
	<title>Ajouter une ville</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php
		include "../model/db.php";
		include '../model/auth.php';
		$db->query("INSERT INTO ville (nom,cp,zonehoraire) VALUES ('".$_POST["nom"]."',".$_POST["code_postal"].",".$_POST["zone_horaire"].")");
	?>
	<a href='ajouter_ville.php'> Retour </a>
</body>
</html>
