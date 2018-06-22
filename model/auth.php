
<?php
//A include là où il faut s'authentifier
//$php_username = isset($_SERVER['PHP_AUTH_USER'])?$_SERVER['PHP_AUTH_USER']:'Guest';

session_start();
function login() {
    header("WWW-Authenticate: Basic"); 
    header("HTTP/1.0 401 Unauthorized");
    die; 
}
if (!isset($_SESSION["AUTH_SUCCESS"])) {
    $_SESSION["AUTH_SUCCESS"] = 0;
}
if ($_SESSION["AUTH_SUCCESS"] == 0) {
		include "../model/db.php";
		$sql =  "SELECT mdp FROM Gerants WHERE login = '".$_SERVER['PHP_AUTH_USER']."';";
		$query = $db->query($sql); 
		$row = $query->fetch(PDO::FETCH_ASSOC);   
    if(!isset($row["mdp"]) or $row["mdp"] != $_SERVER['PHP_AUTH_PW']) { 
        login();
    } else {
        $_SESSION["AUTH_SUCCESS"] = 1;
    }
}
if ($_SESSION["AUTH_SUCCESS"] == 0) {
    die("You have entered a wrong password/username.");
}

?>


