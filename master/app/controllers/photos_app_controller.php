<?php
class PhotosAppController extends AppController {

	var $name = 'PhotosApp';
    var $uses = array();
    
    function beforeFilter() {
        $this->autoRender = true;
        $this->layout = 'photos_app_layout';
    }
    
    function index() {}

}
?>