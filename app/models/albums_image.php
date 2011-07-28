<?php
class AlbumsImage extends AppModel {
	var $name = 'AlbumsImage';
	var $useDbConfig = 'photos_backbone';
	//The Associations below have been created with all possible keys, those that are not needed can be removed

	var $belongsTo = array(
		'Albums' => array(
			'className' => 'Albums',
			'foreignKey' => 'albums_id',
			'conditions' => '',
			'fields' => '',
			'order' => ''
		),
		'Images' => array(
			'className' => 'Images',
			'foreignKey' => 'images_id',
			'conditions' => '',
			'fields' => '',
			'order' => ''
		)
	);
}
?>