<?php

App::uses('AppModel', 'Model');

class Tag extends AppModel {
  
	public $name = 'Tag';
	public $displayField = 'name';
	//The Associations below have been created with all possible keys, those that are not needed can be removed

	public $hasMany = array(
		'PhotosTag'
	);

}
?>