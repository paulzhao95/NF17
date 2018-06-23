<html>
<head>
    <title>Creation d'un compte</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link href="style.css" rel="stylesheet" media="all" type="text/css">
</head>

<body>
    <?php
    //récupération des informations
    $prenom = $_POST['prenom'];
    $nom = $_POST['nom'];
    $tel = $_POST['num_tel'];
    $ville = $_POST['ville'];
    $cp = $_POST['cp'];
    $num = $_POST['num_rue'];
    $rue = $_POST['nom_rue'];
    $reponse = $_POST['reponse'];

    //connexion à la BDD
    require_once('../model/db.php');
    global $db;

    //on cherche si la ville existe
    $existe = $db->query("SELECT * FROM Ville WHERE Nom = '$ville'");
    if ($existe->fetch() == NULL) {
        //on ajoute dans la base
        $db->query("INSERT INTO ville (nom,cp,zonehoraire) VALUES ('$ville', $cp, 2)");
    }

    //on vérifie si le compte existe déjà
    $result = $db->query("SELECT Id FROM Voyageur WHERE Nom LIKE '$nom' AND Prenom LIKE '$prenom' AND NumeroTel = $tel");
    $homonyme = $result->fetch();

    if ($homonyme != NULL && $reponse=="blblb") { //s'il y a bien un résultat pour cette recherche
        echo "<p>Il y a une personne avec les mêmes nom, prénom et numéro de téléphone dans notre base. Son numéro est le $homonyme[0]. Est-ce vous&nbsp?</p>";

        echo "<form action='creation_compte.php' method='POST'>";

        echo "<input type='radio' name='reponse' value='oui'>Oui<br>";
        echo "<input type='radio' name='reponse' value='non'>Non<br>";
        echo "<input type='hidden' name ='prenom' value='$prenom'>";
        echo "<input type='hidden' name ='nom' value='$nom'>";
        echo "<input type='hidden' name ='num_tel' value=$tel>";
        echo "<input type='hidden' name ='ville' value=$ville>";
        echo "<input type='hidden' name ='cp' value=$cp>";
        echo "<input type='hidden' name ='num_rue' value=$num>";
        echo "<input type='hidden' name ='nom_rue' value=$rue>";

        echo "<br><input type='submit' value='Valider'>";
    }

    else if ($reponse != "oui") {
        $result = $db->query("INSERT INTO Voyageur (Nom, Prenom, NumeroTel, NumeroCarte, Ville, Adresse, TypeVoyageur) VALUES ('$nom', '$prenom', '$tel', NULL, '$ville', ($num, '$rue'), 'Occasionnel') RETURNING Id");
        $id = $result->fetch();
        echo "<p>$prenom $nom votre compte voyageur a bien été créé. Le numéro $id[0] vous a été attribué.</p>";
    }
    ?>

<br><a href='accueil.html'>Retour</a>
</body>
</html>
