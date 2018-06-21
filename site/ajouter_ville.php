<html>
<head>
	<title>Ajouter une ville</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<form action='ajout_ville.php' method='post'>
		Nom de la ville : <input type='text' name='nom'></input> <br><br>
		Code postal : <input type='number' min='0' max = '99999' name='code_postal'></input><br><br>
		Zone horaire : <input type='number' min = '-12' max = '12' name='zone_horaire'></input><br><br><br>
		<input type='submit' name='squalala'></input>

	</form>

</body>
</html>
