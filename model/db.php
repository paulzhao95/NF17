<?php

// This file is to be included in every model.

$db_info_path = 'model/db_info.php';
if(file_exists($db_info_path) && is_readable($db_info_path))
	require_once($db_info_path);
else
{
	die('<b>Fatal error:</b> ' . $db_info_path . ' doesn\'t exist or is unreadable.<br />');
}

if(!isset($db_info) || empty($db_info))
{
		die('<b>Fatal error:</b> $db_info isn\'t set in ' . $db_info_path . '. It should be following the structure below:
			<pre>
Array
{
	[driver] => &lt;database driver&gt;
	[host] => &lt;database host&gt;
	[base] => &lt;database name&gt;
	[user] => &lt;username to authentify with&gt;
	[password] => &lt;password to authentify with&gt;
}
			</pre>Please create the array and try again.');
}

try
{
	$db = new PDO($db_info['driver'] . ':host=' . $db_info['host'] . ';port=' . $db_info['port'] . ';dbname=' . $db_info['base']/* . ';charset=utf8'*/, $db_info['user'], $db_info['password']);
}
catch(Exception $e)
{
	die($e->getMessage());
}

