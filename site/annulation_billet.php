<html>
<head>
    <title>Annulation des billets</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <h1>Confirmation de l'annulation</h1>
    <?php
    //connexion à la BDD
    require_once('../model/db.php');
    global $db;

    if (empty($_POST['billets'])) {
        echo "<p>Vous n'avez sélectionné aucun billet.<p>";
    } else {
        foreach ($_POST['billets'] as $id_billet) {
            $result = $db->query("SELECT * FROM annulerBillet($id_billet)");
            $remboursement = $result->fetch();
            echo "<p>Le billet numéro $id_billet a bien été annulé. Votre compte sera crédité de $remboursement[0] euros.</p>";
        }
    }
    ?>

    <p><a href='accueil.html'>Retour</a></p>
</body>
</html>
