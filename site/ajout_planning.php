<html>
<head>
	<title>Ajouter une gare</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php 
		include "../model/db.php";
		include '../model/auth.php';
		
		$jours = "ARRAY[";
		if(!isset($_POST["lundi"]))
		{
			$jours = $jours."false,";
		}
		else
		{
			$jours = $jours."true,";
		}
		if(!isset($_POST["mardi"]))
		{
			$jours = $jours."false,";
		}
		else
		{
			$jours = $jours."true,";
		}
		if(!isset($_POST["mercredi"]))
		{
			$jours = $jours."false,";
		}
		else
		{
			$jours = $jours."true,";
		}
		if(!isset($_POST["jeudi"]))
		{
			$jours = $jours."false,";
		}
		else
		{
			$jours = $jours."true,";
		}
		if(!isset($_POST["vendredi"]))
		{
			$jours = $jours."false,";
		}
		else
		{
			$jours = $jours."true,";
		}
		if(!isset($_POST["samedi"]))
		{
			$jours = $jours."false,";
		}
		else
		{
			$jours = $jours."true,";
		}
		if(!isset($_POST["dimanche"]))
		{
			$jours = $jours."false]";
		}
		else
		{
			$jours = $jours."true]";
		}
		$debut= "";
		$fin = "";
		if(isset($_POST["date_debut"]) and $_POST["date_debut"])
		{$debut = "'".$_POST["date_debut"]."'";}
		else {$debut = "NULL";}
		if(isset($_POST["date_fin"]) and $_POST["date_fin"])
		{$fin = "'".$_POST["date_fin"]."'";}
		else {$fin = "NULL";}

		$db->query("INSERT INTO Planning (Nom, Jours, Debut, Fin) VALUES ('".$_POST['nom']."',".$jours.",".$debut.",".$fin.")");			
	?>
	<a href='ajouter_gare.php'> Retour </a>
</body>
</html>
