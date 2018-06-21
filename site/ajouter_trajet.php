<html>
<head>
	<title>Ajouter un trajet</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<form action='ajout_trajet.php' method='post'>
		Ligne : <select name='ligne'>
		<?php
			include "../model/db.php";
			include '../model/auth.php';
 
				
				$sql =  "SELECT id,NomGareDep,VilleGareDep,NomGareArr,VilleGareArr,TypeTrain FROM ligne;";
		
				$query = $db->query($sql);

				//$query->debugDumpParams();

    		foreach($query as $row) {
        echo "<option value='".$row["id"]."'>".$row["typetrain"]." de ".$row["nomgaredep"]." de la ville de ".$row["villegaredep"]." vers ".$row["nomgarearr"]." de la ville de ".$row["villegarearr"]."</option> <br>";
  			}
		
		?>
		</select><br><br>
		Heure du départ : <input name='heured' type='number' min='0' max='23'></input>:<input name='minuted' type='number' min='0' max='59'></input>:<input name='seconded' type='number' min='0' max='59'></input><br><br>
		Heure d'arrivée : <input name='heurea' type='number' min='0' max='23'></input>:<input name='minutea' type='number' min='0' max='59'></input>:<input name='secondea' type='number' min='0' max='59'></input><br><br>
		Prix première classe (si existante sinon 0) : <input type='number' name='prixprem' min='0' step='0.01'> </input><br><br>
		Prix seconde classe : <input type='number' name='prixsec' min='0' step='0.01'> </input><br><br>
		Planning : <select name='planning'>
		<?php
			include "../model/db.php";
			include '../model/auth.php';
 
				
				$sql =  "SELECT nom FROM planning;";
		
				$query = $db->query($sql);

				//$query->debugDumpParams();

    		foreach($query as $row) {
        echo "<option value='".$row["nom"]."'>".$row["nom"]."</option> <br>";
  			}
		
		?>
		</select><br><br>
		<input type='submit' name='squalala'></input>

	</form>

</body>
</html>
