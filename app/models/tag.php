<?php
class Tag extends AppModel {
	var $name = 'Tag';
	var $useDbConfig = 'director_spine';
	var $displayField = 'name';
	//The Associations below have been created with all possible keys, those that are not needed can be removed

	var $hasAndBelongsToMany = array(
		'Image' => array(
			'className' => 'Image',
			'joinTable' => 'images_tags',
			'foreignKey' => 'tag_id',
			'associationForeignKey' => 'image_id',
			'unique' => true,
			'conditions' => '',
			'fields' => '',
			'order' => '',
			'limit' => '',
			'offset' => '',
			'finderQuery' => '',
			'deleteQuery' => '',
			'insertQuery' => ''
		)
	);

}
?>