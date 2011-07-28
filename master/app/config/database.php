<?php
class DATABASE_CONFIG {

    var $default = array(
		'driver' => 'mysql',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'axel',
		'password' => 'kakadax',
		'database' => 'todos_backbone',
		'prefix' => '',
	);
    
	var $todos_backbone = array(
		'driver' => 'mysql',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'axel',
		'password' => 'kakadax',
		'database' => 'todos_backbone',
	);
    
	var $todos_spine = array(
		'driver' => 'mysql',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'axel',
		'password' => 'kakadax',
		'database' => 'todos_spine',
	);
	
	var $contacts_spine = array(
		'driver' => 'mysql',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'axel',
		'password' => 'kakadax',
		'database' => 'contacts_spine',
	);
}
?>