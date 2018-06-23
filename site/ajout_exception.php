<html>
<head>
	<title>Créer une nouvelle exception</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php 
		include "../model/db.php";
		include '../model/auth.php';
		
		$ajoute = "";
		if(!isset($_POST["ajoute"]))
		{
			$ajoute = "false";
		}
		else
		{
			$ajoute = "true";
		}
		
		$fin = "";
		if(isset($_POST["date_fin"]) and $_POST["date_fin"])
		{$fin = "'".$_POST["date_fin"]."'";}
		else {$fin = "NULL";}
		echo "INSERT INTO Exception (Nom, Ajoute, Planning, DateDebut, DateFin) VALUES ('".$_POST['nom']."',".$ajoute.",'".$_POST['planning']."','".$_POST['date_debut']."',".$fin.")";
		$db->query("INSERT INTO Exception (Nom, Ajoute, Planning, DateDebut, DateFin) VALUES ('".$_POST['nom']."',".$ajoute.",'".$_POST['planning']."','".$_POST['date_debut']."',".$fin.")");			
	?>
	<a href='ajouter_gare.php'> Retour </a>
</body>
</html>
