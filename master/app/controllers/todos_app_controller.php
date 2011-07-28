<?php
class TodosAppController extends AppController {

	var $name = 'TodosApp';
    var $uses = array();
    
    function beforeFilter() {
        $this->autoRender = true;
        $this->layout = 'todos_app_layout';
    }
    
    function index() {}

}
?>