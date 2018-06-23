<html>
<head>
	<title>Ajouter un trajet</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php
		include "../model/db.php";
		include '../model/auth.php';
		if($_POST['prixprem'])
		{
			$prixprem = $_POST['prixprem'];
		}
		else
		{
			$prixprem = "NULL";
		}

		$hd = $_POST['heured'].":".$_POST['minuted'].":".$_POST['seconded'];
		$ha = $_POST['heurea'].":".$_POST['minutea'].":".$_POST['secondea'];
		$db->query("INSERT INTO trajet (Ligne, HeureDepart, HeureArrivee, PrixPrem, PrixSec, Planning) VALUES
		('".$_POST['ligne']."','".$hd."','".$ha."',".$prixprem.",".$_POST['prixsec'].",'".$_POST['planning']."')");
	?>
	<a href='ajouter_trajet.php'>Retour</a>
</body>
</html>
