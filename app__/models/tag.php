<?php
class Tag extends AppModel {
	var $name = 'Tag';
	var $useDbConfig = 'director_spine';
	var $displayField = 'name';
	//The Associations below have been created with all possible keys, those that are not needed can be removed

	var $hasAndBelongsToMany = array(
		'Photo' => array(
			'className' => 'Photo',
			'joinTable' => 'photos_tags',
			'foreignKey' => 'tag_id',
			'associationForeignKey' => 'photo_id',
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