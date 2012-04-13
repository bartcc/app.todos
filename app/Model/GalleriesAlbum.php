<?php

class GalleriesAlbum extends AppModel {

  public $name = 'GalleriesAlbum';
  public $useDbConfig = 'director_spine';
  
  public $belongsTo = array(
      'Gallery', 'Album'
  );

  //The Associations below have been created with all possible keys, those that are not needed can be removed
//	var $hasAndBelongsToMany = array(
//		'Album' => array(
//			'className' => 'Album',
//			'joinTable' => 'albums_photos',
//			'foreignKey' => 'photo_id',
//			'associationForeignKey' => 'album_id',
//			'unique' => true,
//			'conditions' => '',
//			'fields' => '',
//			'order' => 'AlbumsPhoto.order DESC',
//			'limit' => '',
//			'offset' => '',
//			'finderQuery' => '',
//			'deleteQuery' => '',
//			'insertQuery' => ''
//		),
//		'Tag' => array(
//			'className' => 'Tag',
//			'joinTable' => 'photos_tags',
//			'foreignKey' => 'photo_id',
//			'associationForeignKey' => 'tag_id',
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