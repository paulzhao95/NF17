<html>
<head>
    <title>Choix du billet à annuler</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <?php
    //récupération des informations
    $usager = $_POST['id_voy'];

    //connexion à la BDD
    require_once('../model/db.php');
    global $db;

    //on relève la date
    date_default_timezone_set('Europe/Paris');
    $date = date("Y\-m\-d");

    //on sélectionne les billets à venir
    $result = $db->query("SELECT Date, Trajet, Classe, Place, Reservation.Id, Billet.Id FROM Billet INNER JOIN Reservation ON Billet.Reservation = Reservation.Id WHERE Voyageur = $usager AND Date >= '$date' AND Annule = false");
    $billets = $result->fetchAll();

    if ($billets == null) { //s'il n'y a pas de résultat pour cette recherche
        echo "<p>Vous n'avez aucun voyage à venir.</p>";
    } else {
        echo "<form action='annulation_billet.php' method='POST'>";
        echo "<p>Voici la liste des billets associés à votre compte. Sélectionnez ceux que vous voulez annuler.</p>";
        echo "<table><tr><td>Date du voyage</td>";
        echo "<td>Numéro de train</td>";
        echo "<td>Classe</td>";
        echo "<td>Numéro de place</td>";
        echo "<td>Numéro de réservation</td>";
        echo "<td>Numéro du billet</td>";
        echo "<td>À annuler</td></tr>";
        foreach ($billets as $billet) {
            echo "<tr><td>$billet[0]</td>";
            echo "<td>$billet[1]</td>";
            echo "<td>$billet[2]</td>";
            echo "<td>$billet[3]</td>";
            echo "<td>$billet[4]</td>";
            echo "<td>$billet[5]</td>";
            echo "<td><input type='checkbox' name='billets[]' value='$billet[5]'></td></tr>";
        }
        echo "</table>";
        echo "<input type='submit' value='Annuler ces billets'>";
        echo "</form>";
    }
    ?>

<br><a href='accueil.html'>Retour</a>
</body>
</html>
