<html>
<head>
    <title>Ajouter un trajet</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <?php
    //récupération des informations
    $ligne = $_POST['ligne'];
    $prixsec = $_POST['prixsec'];
    $planning = $_POST['planning'];

    include "../model/db.php";
    include '../model/auth.php';
    if ($_POST['prixprem']) {
        $prixprem = $_POST['prixprem'];
    } else {
        $prixprem = "NULL";
    }

    $hd = $_POST['heured'].":".$_POST['minuted'].":".$_POST['seconded'];
    $ha = $_POST['heurea'].":".$_POST['minutea'].":".$_POST['secondea'];
    $result = $db->query("INSERT INTO Trajet (Ligne, HeureDepart, HeureArrivee, PrixPrem, PrixSec, Planning) VALUES ('$ligne', '$hd', '$ha', $prixprem, $prixsec, '$planning') RETURNING Id");
    $id = $result->fetch();

    echo "<h1>Le train numéro $id[0] sur la ligne $ligne, départ $hd a bien été ajouté à la base</h1>";
    ?>
    <p><a href='ajouter_trajet.php'>Retour</a></p>
</body>
</html>
