<?php

App::uses('AppModel', 'Model');

class Gallery extends AppModel {

  public $name = 'Gallery';
  public $displayField = 'name';
  
  public $hasMany = array(
      'GalleriesAlbum'
  );

// The Associations below have been created with all possible keys, those that are not needed can be removed
//	var $hasAndBelongsToMany = array(
//		'Album' => array(
//			'className' => 'Album',
//			'joinTable' => 'galleries_albums',
//			'foreignKey' => 'gallery_id',
//			'associationForeignKey' => 'album_id',
//			'unique' => true,
//			'conditions' => '',
//			'fields' => '',
//			'order' => '',
//			'limit' => '',
//			'offset' => '',
//			'finderQuery' => '',
//			'deleteQuery' => '',
//			'insertQuery' => ''
//		)
//	);
}

?>