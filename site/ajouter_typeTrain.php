<html>
<head>
	<title>Créer un nouveau type de train</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="menu.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<form action='ajout_typeTrain.php' method='post'>
		Nom du nouveau type de train : <input type='text' name='nom'></input> <br><br>
		Nombre de places en première classe : <input type='number' min='0' name='nb_prem'></input> <br><br>
		Nombre de places en seconde classe : <input type='number' min='1' name='nb_sec'></input> <br><br>
		Vitesse maximum : <input type='number' min='1' name='vitesse'></input> <br><br>
		<input type='submit' name='squalala'></input>
	</form>

</body>
</html>
