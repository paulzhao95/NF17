<html>
<head>
	<title>Créer un nouveau planning</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<form action='ajout_planning.php' method='post'>
		Nom du planning : <input type='text' name='nom' required></input> <br><br>
		Jours d'activité : Lundi <input type="checkbox" name="lundi" value="true"> </input>
		Mardi <input type="checkbox" name="mardi" value="true"> </input>
		Mercredi <input type="checkbox" name="mercredi" value="true"> </input>
		Jeudi <input type="checkbox" name="jeudi" value="true"> </input>
		Vendredi <input type="checkbox" name="vendredi" value="true"> </input>
		Samedi <input type="checkbox" name="samedi" value="true"> </input>
		Dimanche <input type="checkbox" name="dimanche" value="true"></input> <br><br>
		Date de début : <input type='date' name='date_debut'></input> <br><br>
		Date de fin : <input type='date' name='date_fin'></input> <br><br>
		<input type='submit' name='squalala'></input>
	</form>

</body>
</html>
