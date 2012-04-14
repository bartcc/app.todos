<?php

App::uses('AppModel', 'Model');

class Tag extends AppModel {
	public $name = 'Tag';
	public $useDbConfig = 'director_spine';
	public $displayField = 'name';
 
 public $hasMany = array(
     'PhotosTag' => array('dependent' => true)
 );
 
}
?>