<html>
<head>
    <title>Recherche d'un train</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <h1>Choisir une ville de départ, une ville d'arrivée et une date</h1>
    <?php
    //connexion à la BDD
    require_once('../model/db.php');
    global $db;

    //récupération des gares
    $villes = $db->query('SELECT Nom FROM Ville');

    //création d'un formulaire
    echo "<form action='visualiser_trajets.php' method='POST'>";

    echo "<table>";

    echo "<tr><td>Ville de départ&nbsp:</td>";
    //affichage de tous les élèves dans une liste déroulante
    echo "<td><select name='villeDep' size='4' required>";
    while ($row_ville = pg_fetch_row($villes)) {
        echo "<option value='$row_ville[0]'>$row_ville[0]</option>";
    }
    echo "</select></td></tr>";

    echo "<tr><td>Ville d'arrivée'&nbsp:</td>";
    //affichage de tous les élèves dans une liste déroulante
    echo "<td><select name='villeArr' size='4' required>";
    while ($row_ville = pg_fetch_row($villes)) {
        echo "<option value='$row_ville[0]'>$row_ville[0]</option>";
    }
    echo "</select></td></tr>";

    echo "<tr><td>Date&nbsp:</td>";

    echo "<td><input type='date' name='date'></td></tr><br>";

    echo "</table>";

    echo "<br><input type='submit' value='Afficher les trains correspondants'>";
    echo "</form>";
    mysqli_close($connect);
    ?>
</body>
