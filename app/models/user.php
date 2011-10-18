<?php
class User extends AppModel {
  
	var $name = 'User';
	var $useDbConfig = 'director_spine';

	var $belongsTo = array(
		'Group' => array(
			'className' => 'Group',
			'foreignKey' => 'group_id',
			'conditions' => '',
			'fields' => '',
			'order' => ''
		)
	);
}
?>