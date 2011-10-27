<?php
class Tag extends AppModel {
	var $name = 'Tag';
	var $useDbConfig = 'director_spine';
	var $displayField = 'name';
	//The Associations below have been created with all possible keys, those that are not needed can be removed

	var $hasAndBelongsToMany = array(
		'Bitmap' => array(
			'className' => 'Bitmap',
			'joinTable' => 'bitmaps_tags',
			'foreignKey' => 'tag_id',
			'associationForeignKey' => 'bitmap_id',
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