<html>
<head>
	<title>Créer une nouvelle exception</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
<?php
	include '../model/auth.php';
	?>
	<form action='ajout_exception.php' method='post'>
		Nom de l'exception : <input type='text' name='nom' required></input> <br><br>
		L'exception ajoute une période d'activité ? <input type="checkbox" name="ajoute" value="true"> </input> <br><br>
		À quel planning s'applique l'exception ? <select name='planning'>
		<?php
			include "../model/db.php";
 
				
				$sql =  "SELECT nom FROM planning ORDER BY nom;";
		
				$query = $db->query($sql);

				//$query->debugDumpParams();

    		foreach($query as $row) {
				echo "<option value='".$row["nom"]."'>".$row["nom"]."</option> <br>";
  			}
		
		?>
		</select><br><br>
		Date de début : <input type='date' name='date_debut' required></input> <br><br>
		Date de fin : <input type='date' name='date_fin'></input> <br><br>
		<input type='submit' name='squalala'></input>
	</form>

</body>
</html>
