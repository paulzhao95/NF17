<html>
<head>
	<title>Ajouter une gare</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
	<?php
        include "../model/db.php";
        include '../model/auth.php';
        $db->query("INSERT INTO gare (nom,adresse,ville) VALUES ('".$_POST['nom']."',(".$_POST['numero_rue'].",'".$_POST['rue']."'),'".$_POST['ville']."')");

        echo "<h1>La gare a bien été ajoutée dans la base</h1>";
    ?>
	<p><a href='ajouter_gare.php'>Retour</a></p>
</body>
</html>
