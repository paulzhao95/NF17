<html>
<head>
	<title>Ajouter une ligne</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php
        include "../model/db.php";
        include '../model/auth.php';
        $g1 = explode(';', $_POST['gare_dep']);
        $g2 = explode(';', $_POST['gare_arr']);
        $db->query("INSERT INTO ligne (NomGareDep,VilleGareDep,NomGareArr,VilleGareArr,TypeTrain) VALUES ('".$g1[0]."','".$g1[1]."','".$g2[0]."','".$g2[1]."','".$_POST["type"]."')");
    ?>
	<a href='ajouter_ligne.php'>Retour</a>
</body>
</html>
