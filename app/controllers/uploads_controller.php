<?php

class UploadsController extends AppController {
	// Models needed for this controller
    var $name = 'Uploads';
	var $uses = array();

    function beforeFilter() {
        $this->disableCache();
        /*
         * using flash our session gets lost
         * we have to manually start it
         */
        if($this->Auth->action() == 'Uploads/avatar') {
            $this->Session->id($this->params['pass'][1]);
            $this->Session->start();
        }
        parent::beforeFilter();
    }

	function avatar($id) {
        $this->autoRender = false;

        App::import('Component', 'File');
		$file = new FileComponent();

		if (!is_dir(PRODUCTIMAGES . DS . 'tmp')) {
			$file->makeDir(PRODUCTIMAGES . DS . 'tmp');
		} else {
            $oldies = glob(PRODUCTIMAGES . DS . 'tmp' . DS . '*');
            foreach ($oldies as $o) {
                unlink($o);
            }
        }

        if(!empty($this->params['form']['Filedata'])) {
            if (strpos(strtolower(env('HTTP_USER_AGENT')), 'flash') === false || !$this->RequestHandler->isPost()) {
                exit;
            }
		}

		if(!empty($this->params['form']['Filedata'])) {
            $tmp = $this->params['form']['Filedata'];
            $ext = $file->returnExt($this->params['form']['Filedata']['name']);
            $fn = 'original.' . $ext;

            $the_temp = $this->params['form']['Filedata']['tmp_name'];
            $temp_path = PRODUCTIMAGES . DS . 'tmp' . DS . $fn;

            if (!is_dir(dirname($temp_path))) {
                $file->makeDir(dirname($temp_path));
            }
            if (in_array($ext, a('jpg', 'jpeg', 'jpe', 'gif', 'png'))) {
                if (is_uploaded_file($the_temp)) {
                    move_uploaded_file($the_temp, $temp_path);
                }

            }
        }
        exit(' ');
	}
}

?>