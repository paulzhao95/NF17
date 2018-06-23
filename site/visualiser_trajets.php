<html>
<head>
    <title>Trains correspondants à la recherche</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <h1>Trains correspondants à la recherche</h1>
    <?php
    //récupération des informations
    $villeDep = $_POST['villeDep'];
    $villeArr = $_POST['villeArr'];
    $date = $_POST['date'];

    //connexion à la BDD
    require_once('../model/db.php');
    global $db;

    //il faut trouver les trajets correspondants
    $tb_trajets = $db->query("SELECT * FROM trouverTrajet('$villeDep', '$villeArr', '$date')");
    $liste_trains = $tb_trajets->fetchAll();

    echo "<form action='prendre_billet.php' method='POST'>";

    echo "<table>";

    echo "<tr><td>Numéro de train</td>";
    echo "<td>Gare de départ</td>";
    echo "<td>Gare d'arrivée</td>";
    echo "<td>Horaire</td>";
    echo "<td>Seconde classe</td>";
    echo "<td>Première classe</td></tr>";

    foreach ($liste_trains as $train) {
      echo "<tr><td>$train[0]</td>";
      echo "<td>$train[1]</td>";
      echo "<td>$train[3]</td>";
      echo "<td>$train[2] - $train[4]</td>";
      echo "<td>$train[5]<br><input type='radio' name='trajet_choisi' value='$train[0]+$date+2' required></td>";
      if ($train[6] != NULL) {
        echo "<td>$train[6]<br><input type='radio' name='trajet_choisi' value='$train[0]+$date+1' required></td></tr>";
      }
    }

    echo "</table>";

    echo "<p>Je veux prendre <input type='number' name='nb_billet' min='1' required> billets pour l'usager numéro* <input type='text' name='id_voy'>.</p>";
    echo "<p>Je veux une assurance pour ce voyage <input type='checkbox' name='assurance' value='oui' checked></p>";
    echo "<p>Je paierai en espèces <input type='radio' name='paiement' value='especes' required> en chèque <input type='radio' name='paiement' value='cheque' required> en carte bancaire<input type='radio' name='paiement' value='carte_bleue' required></p>";

    echo "<input type='submit' value='Effectuer une réservation'>";
    echo "</form>";

    echo "<p>* Pour trouver votre numéro d'usager, cliquez sur <a href='chercher_usager.php'>accéder à mon compte</a>. Si vous n'en avez pas, <a href='creer_compte.html'>créez-en un</a>.</p>";

    ?>
</body>
</html>
