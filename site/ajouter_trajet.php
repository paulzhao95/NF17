<html>
<head>
	<title>Ajouter un trajet</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
<?php
    include '../model/auth.php';
    ?>
	<form action='ajout_trajet.php' method='post'>
		Ligne&nbsp: <select name='ligne'>
		<?php
            include "../model/db.php";


                $sql =  "SELECT id,NomGareDep,VilleGareDep,NomGareArr,VilleGareArr,TypeTrain FROM ligne;";

                $query = $db->query($sql);

                //$query->debugDumpParams();

            foreach ($query as $row) {
                echo "<option value='".$row["id"]."'>".$row["typetrain"]." de ".$row["nomgaredep"]." de la ville de ".$row["villegaredep"]." vers ".$row["nomgarearr"]." de la ville de ".$row["villegarearr"]."</option> <br>";
            }

        ?>
		</select><br><br>

		Heure du départ&nbsp: <input name='heured' type='number' min='0' max='23' required></input>:<input name='minuted' type='number' min='0' max='59' required></input>:<input name='seconded' type='number' min='0' max='59' required></input><br><br>
		Heure d'arrivée&nbsp: <input name='heurea' type='number' min='0' max='23' required></input>:<input name='minutea' type='number' min='0' max='59' required></input>:<input name='secondea' type='number' min='0' max='59' required></input><br><br>
		Prix première classe (si existante sinon 0)&nbsp: <input type='number' name='prixprem' min='0' step='0.01'> </input><br><br>
		Prix seconde classe&nbsp: <input type='number' name='prixsec' min='0' step='0.01' required> </input><br><br>
		Planning&nbsp: <select name='planning'>

		<?php
            include "../model/db.php";


                $sql =  "SELECT nom FROM planning;";

                $query = $db->query($sql);

                //$query->debugDumpParams();

            foreach ($query as $row) {
                echo "<option value='".$row["nom"]."'>".$row["nom"]."</option> <br>";
            }

        ?>
		</select><br><br>
		<input type='submit' name='squalala'></input>

	</form>

</body>
</html>
