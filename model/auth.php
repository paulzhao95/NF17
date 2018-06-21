<html>
<head>
<title>Test2</title>
</head> 
<body>

<?php

$php_username = isset($_SERVER['PHP_AUTH_USER'])?$_SERVER['PHP_AUTH_USER']:'Guest';

?>

Welcome <?php echo $_POST["firstname"]; ?><br>
Your name is: <?php echo $_POST["lastname"]; ?>

</body>
</html> 

