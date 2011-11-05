<?php

class UploadsController extends AppController {

  // Models needed for this controller
  var $name = 'Uploads';
  var $uses = array('Photo');

  function beforeFilter() {
    $this->disableCache();
    
    parent::beforeFilter();
  }

  function image() {
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
      
  //    if (!is_dir(PHOTOS . DS . 'tmp')) {
  //      $file->makeDir(PHOTOS . DS . 'tmp');
  //    } else {
  //      $oldies = glob(PHOTOS . DS . 'tmp' . DS . '*');
  //      foreach ($oldies as $o) {
  //        unlink($o);
  //      }
  //    }

      if (!$this->RequestHandler->isPost()) {
        exit;
      }

      if (!empty($this->params['form']['files'])) {
        $formfiles = $this->params['form']['files'];
        $the_files = $this->params['form']['files']['name'];
        $photos = array();
        foreach ($the_files as $key => $value) {

          $the_file = str_replace(" ", "_", $the_files[$key]);
          $the_file = ereg_replace("[^A-Za-z0-9._-]", "_", $the_file);
          $the_temp = $formfiles['tmp_name'][$key];

          $ext = $file->returnExt($the_file);

          if (in_array($ext, a('jpg', 'jpeg', 'jpe', 'gif', 'png'))) {
            
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
                  $this->log($meta, LOG_DEBUG);
                  $exposure = $file->parseMetaTags('exif:exposure', $meta);
                  $iso = $file->parseMetaTags('exif:iso', $meta);
                  $longitude = $file->parseMetaTags('exif:longitude', $meta);
                  $aperture = $file->parseMetaTags('exif:aperture', $meta);
                  $make = $file->parseMetaTags('exif:make', $meta);
                  $model = $file->parseMetaTags('exif:model', $meta);
//                  $keywords = str_replace(' ', ',', urldecode($keywords));
//                  $keywords = ereg_replace("[^,A-Za-z0-9._-]", "", $keywords);

                  $this->data['Photo']['id'] = $id;
                  $this->data['Photo']['user_id'] = $user_id;
                  $this->data['Photo']['src'] = $the_file;
                  $this->data['Photo']['filesize'] = filesize($lg_path);
                  $this->data['Photo']['captured'] = (int) $captured;
                  $this->data['Photo']['exposure'] = $exposure;
                  $this->data['Photo']['iso'] = $iso;
                  $this->data['Photo']['longitude'] = $longitude;
                  $this->data['Photo']['aperture'] = $aperture;
                  $this->data['Photo']['make'] = $make;
                  $this->data['Photo']['model'] = $model;

                }
              }
            }
          }
          // append to array
          $photos[] = $this->data;
        }// foreach
        
        if($this->Photo->saveAll($photos)) {
          $json =  $photos;
          $this->set(compact('json'));
          $this->render(SIMPLE_JSON);
          
        }
      }
    }
  }

}

?>