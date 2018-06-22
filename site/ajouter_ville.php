<html>
<head>
	<title>Ajouter une ville</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<form action='ajout_ville.php' method='post'>
		Nom de la ville&nbsp: <input type='text' name='nom' required></input> <br><br>
		Code postal&nbsp: <input type='number' min='0' max = '99999' name='code_postal' required></input><br><br>
		Zone horaire&nbsp: <input type='number' min = '-12' max = '12' name='zone_horaire' required></input><br><br><br>
		<input type='submit' name='squalala'></input>

	</form>

</body>
</html>
