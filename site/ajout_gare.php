<html>
<head>
<title>Test2</title>
</head> 
<body>

<?php 
include '../model/db.php';
include '../model/auth.php';

$sth = $db->query("SELECT Nom FROM Gare;");
$donnee = $sth->fetch(PDO::FETCH_ASSOC);
echo $donnee["nom"];

?>




</body>
</html> 

