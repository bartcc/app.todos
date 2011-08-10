<?php
class TasksApp1Controller extends AppController {

	var $name = 'TasksApp1';
    var $uses = array();
    
    function beforeFilter() {
        $this->autoRender = true;
        $this->layout = 'tasks_1_layout';
    }
    
    function index() {}

}
?>