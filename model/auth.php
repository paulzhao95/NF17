
<?php
//A include là où il faut s'authentifier
//$php_username = isset($_SERVER['PHP_AUTH_USER'])?$_SERVER['PHP_AUTH_USER']:'Guest';

if (!isset($_SERVER['PHP_AUTH_USER'])) {
    header('WWW-Authenticate: Basic realm="Personnel autorise"');
    header('HTTP/1.0 401 Unauthorized');
    echo "<a href='../site/menu_scf.php'> Retour au menu </a>";
    exit;
} else {
			include "../model/db.php";
 
				
				$sql =  "SELECT mdp FROM Gerants WHERE login = '".$_SERVER['PHP_AUTH_USER']."';";
				
				$query = $db->query($sql,PDO::FETCH_ASSOC);
				$row = $query->fetch($query);
				//$query->debugDumpParams();
				if($row["mdp"] == $_SERVER['PHP_AUTH_PW'])
				{
					echo "Problème lors de l'identification.<br><br><a href='../site/menu_scf.php'> Retour au menu </a>";
					exit;
				}
				else
				{
					echo "<p>Connecté en tant que {$_SERVER['PHP_AUTH_USER']}</p><br><br>";
				}
}

?>


