<?php
class Album extends AppModel {
	var $name = 'Album';
	var $useDbConfig = 'director_spine';
	var $displayField = 'name';
	var $validate = array(
		'name' => array(
			'notempty' => array(
				'rule' => array('notempty'),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			),
		)
	);
	//The Associations below have been created with all possible keys, those that are not needed can be removed

	var $hasAndBelongsToMany = array(
		'Image' => array(
			'className' => 'Image',
			'joinTable' => 'albums_images',
			'foreignKey' => 'album_id',
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
		),  
		'Gallery' => array(
			'className' => 'Gallery',
			'joinTable' => 'galleries_albums',
			'foreignKey' => 'album_id',
			'associationForeignKey' => 'gallery_id',
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