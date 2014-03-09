<?php
App::uses('AppController', 'Controller');

class UploadsController extends AppController {

  // Models needed for this controller
  public $name = 'Uploads';
  public $uses = array('Photo');

  function beforeFilter() {
    $this->disableCache();
    
    parent::beforeFilter();
  }

  public function image() {
    $this->autoRender = false;
    if($this->Auth->user()) {

      $user_id = $this->Auth->user('id');
      
      App::import('Component', 'File');
      
      $file = new FileComponent();
      
      if (!is_dir(PHOTOS)) {
        $file->makeDir(PHOTOS);
      }
      if (!is_dir(PHOTOS . DS . $user_id)) {
        $file->makeDir(PHOTOS . DS . $user_id);
      }

      if (!$this->request->is('post')) {
        exit;
      }

      if (!empty($this->request->params['form']['files'])) {
        $formfiles = $this->request->params['form']['files'];
        $the_files = $this->request->params['form']['files']['name'];
        $photos = array();
        foreach ($the_files as $key => $value) {

          $the_file = str_replace(" ", "_", $the_files[$key]);
          $the_file = ereg_replace("[^A-Za-z0-9._-]", "_", $the_file);
          $the_temp = $formfiles['tmp_name'][$key];

          $ext = $file->returnExt($the_file);

          if (in_array($ext, array('jpg', 'jpeg', 'jpe', 'gif', 'png'))) {
            
            if (is_uploaded_file($the_temp)) {

              $this->Photo->create();
              if($this->Photo->save()) {
                $id = $this->Photo->id;

                $path = PHOTOS . DS . $user_id . DS . $id;
                $lg_path = $path . DS . 'lg' . DS . $the_file;
                $lg_temp = $lg_path . '.tmp';

                if($file->makeDir($path) && $file->setFolderPerms($user_id, $id) && move_uploaded_file($the_temp, $lg_temp)) {

                  copy($lg_temp, $lg_path);
                  unlink($lg_temp);

                  list($meta, $captured) = $file->imageMetadata($lg_path);
//                  $this->log($meta, LOG_DEBUG);
                  $exposure = $file->parseMetaTags('exif:exposure', $meta);
                  $iso = $file->parseMetaTags('exif:iso', $meta);
                  $longitude = $file->parseMetaTags('exif:longitude', $meta);
                  $aperture = $file->parseMetaTags('exif:aperture', $meta);
                  $model = $file->parseMetaTags('exif:model', $meta);
                  $date = $file->parseMetaTags('exif:date time', $meta);
                  $title = $file->parseMetaTags('exif:title', $meta);
                  $bias = $file->parseMetaTags('exif:exposure bias', $meta);
                  $metering = $file->parseMetaTags('exif:metering mode', $meta);
                  $focal = $file->parseMetaTags('exif:focal length', $meta);
                  $software = $file->parseMetaTags('exif:software', $meta);
//                  $keywords = str_replace(' ', ',', urldecode($keywords));
//                  $keywords = ereg_replace("[^,A-Za-z0-9._-]", "", $keywords);

                  $this->request->data['Photo']['id'] = $id;
                  $this->request->data['Photo']['user_id'] = $user_id;
                  $this->request->data['Photo']['src'] = $the_file;
                  $this->request->data['Photo']['filesize'] = filesize($lg_path);
                  $this->request->data['Photo']['captured'] = $date;
                  $this->request->data['Photo']['software'] = $software;
                  $this->request->data['Photo']['exposure'] = $exposure;
                  $this->request->data['Photo']['iso'] = $iso;
                  $this->request->data['Photo']['longitude'] = $longitude;
                  $this->request->data['Photo']['aperture'] = $aperture;
                  $this->request->data['Photo']['model'] = $model;
                  $this->request->data['Photo']['order'] = -1;
                  $this->request->data['Photo']['title'] = "";

                }
              }
            }
          }
          // append to array
          $photos[] = $this->request->data;
        }// foreach
        
        if($this->Photo->saveAll($photos)) {
          $this->set('_serialize', $photos);
          $this->render(SIMPLE_JSON);
        }
      }
    }
  }
}

?>