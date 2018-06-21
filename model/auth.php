
<?php
//A include là où il faut s'authentifier
//$php_username = isset($_SERVER['PHP_AUTH_USER'])?$_SERVER['PHP_AUTH_USER']:'Guest';

if (!isset($_SERVER['PHP_AUTH_USER'])) {
    header('WWW-Authenticate: Basic realm="Personnel autorise"');
    header('HTTP/1.0 401 Unauthorized');
    echo "<a href='../site/menu_scf.php'> Retour au menu </a>";
    exit;
} else {
    echo "<p>Bonjour, {$_SERVER['PHP_AUTH_USER']}.</p>";
    echo "<p>Votre mot de passe est {$_SERVER['PHP_AUTH_PW']}.</p>";
}

?>


