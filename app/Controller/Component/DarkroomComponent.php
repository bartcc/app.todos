<?php

class DarkroomComponent extends Object {

  var $controller = true;

  function startup(&$controller) {
    $this->controller = &$controller;
  }

  ////
  // Grab the extension of of any file
  ////
  private function returnExt($file) {
    $pos = strrpos($file, '.');
    return strtolower(substr($file, $pos + 1, strlen($file)));
  }

  ////
  // The workhorse develop function
  ////
  function develop($name, $filename, $new_w, $new_h, $quality, $sharpening, $square = false, $x, $y, $force = false) {
    //sleep(5);
    $old_mask = umask(0);

    $gd = $this->gdVersion();

    settype($gd, 'integer');

    $ext = $this->returnExt($name);
    // Find out what we are dealing with
    switch (true) {
      case preg_match("/jpg|jpeg|jpe|JPE|JPG|JPEG/", $ext):
        if (imagetypes() & IMG_JPG) {
          $src_img = imagecreatefromjpeg($name);
          $type = 'jpg';
        } else {
          return;
        }
        break;
      case preg_match("/png/", $ext):
        if (imagetypes() & IMG_PNG) {
          $src_img = imagecreatefrompng($name);
          $type = 'png';
        } else {
          return;
        }
        break;
      case preg_match("/gif|GIF/", $ext):
        if (imagetypes() & IMG_GIF) {
          $src_img = imagecreatefromgif($name);
          $type = 'gif';
        } else {
          return;
        }
        break;
    }

    if (!isset($src_img)) {
      return;
    };

    $old_x = imagesx($src_img);
    $old_y = imagesy($src_img);

    if ($new_w == $old_x && $new_h == $old_y && !$force) {
      imagedestroy($src_img);
      copy($name, $filename);
      return;
    }

    $original_aspect = $old_x / $old_y;
    $new_aspect = $new_w / $new_h;

    if ($square) {
      if ($original_aspect >= $new_aspect) {
        $thumb_w = ($new_h * $old_x) / $old_y;
        $thumb_h = $new_h;
        $pos_x = $thumb_w * ($x / 100);
        $pos_y = $thumb_h * ($y / 100);
      } else {
        $thumb_w = $new_w;
        $thumb_h = ($new_w * $old_y) / $old_x;
        $pos_x = $thumb_w * ($x / 100);
        $pos_y = $thumb_h * ($y / 100);
      }
      $crop_y = $pos_y - ($new_h / 2);
      $crop_x = $pos_x - ($new_w / 2);
      if ($crop_y < 0) {
        $crop_y = 0;
      } else if (($crop_y + $new_h) > $thumb_h) {
        $crop_y = $thumb_h - $new_h;
      }
      if ($crop_x < 0) {
        $crop_x = 0;
      } else if (($crop_x + $new_w) > $thumb_w) {
        $crop_x = $thumb_w - $new_w;
      }
    } else {
      $crop_y = 0;
      $crop_x = 0;

      if ($original_aspect >= $new_aspect) {
        if ($new_w > $old_x && !$force) {
          if ($water) {
            $this->watermark_original($name, $filename, $water_id, $water_location, $water_opacity);
          } else {
            imagedestroy($src_img);
            copy($name, $filename);
          }
          return;
        }
        $thumb_w = $new_w;
        $thumb_h = ($new_w * $old_y) / $old_x;
      } else {
        if ($new_h > $old_y && !$force) {
          imagedestroy($src_img);
          copy($name, $filename);
          return;
        }
        $thumb_w = ($new_h * $old_x) / $old_y;
        $thumb_h = $new_h;
      }
    }

    if ($gd != 2) {
      $dst_img_one = imagecreate($thumb_w, $thumb_h);
      imagecopyresized($dst_img_one, $src_img, 0, 0, 0, 0, $thumb_w, $thumb_h, $old_x, $old_y);
    } else {
      if ($type == 'png') {
        $dst_img_one = imagecreatetruecolor($thumb_w, $thumb_h);
        $trans_colour = imagecolorallocatealpha($dst_img_one, 0, 0, 0, 127);
        imagefill($dst_img_one, 0, 0, $trans_colour);
      } else {
        $dst_img_one = imagecreatetruecolor($thumb_w, $thumb_h);
      }
      imagecopyresampled($dst_img_one, $src_img, 0, 0, 0, 0, $thumb_w, $thumb_h, $old_x, $old_y);
    }

    if ($square) {
      if ($gd != 2) {
        $dst_img = imagecreate($new_w, $new_h);
        imagecopyresized($dst_img, $dst_img_one, 0, 0, $crop_x, $crop_y, $new_w, $new_h, $new_w, $new_h);
      } else {
        if ($type == 'png') {
          $dst_img = imagecreatetruecolor($new_w, $new_h);
          $trans_colour = imagecolorallocatealpha($dst_img, 0, 0, 0, 127);
          imagefill($dst_img, 0, 0, $trans_colour);
        } else {
          $dst_img = imagecreatetruecolor($new_w, $new_h);
        }
        imagecopyresampled($dst_img, $dst_img_one, 0, 0, $crop_x, $crop_y, $new_w, $new_h, $new_w, $new_h);
      }
    } else {
      $dst_img = $dst_img_one;
    }

    if ($type == 'png') {
      imagealphablending($dst_img, false);
      imagesavealpha($dst_img, true);
      imagepng($dst_img, $filename);
    } elseif ($type == 'gif') {
      imagegif($dst_img, $filename);
    } else {
      imagejpeg($dst_img, $filename, $quality);
    }

    if ($dst_img === $dst_img_one) {
      imagedestroy($dst_img);
    } else {
      imagedestroy($dst_img);
      imagedestroy($dst_img_one);
    }
    imagedestroy($src_img);
    umask($old_mask);
  }

  ////
  // Check GD
  ////
  private function gdVersion() {
    return $this->_gd();
  }

  private function _gd() {
    if (function_exists('gd_info')) {
      $gd = gd_info();
      $version = preg_replace('/(^\w*\s*\W*)(\d+){1,}(.*)$/', '$2', $gd['GD Version']);
      //$this->log("GD Version: " . $version, LOG_DEBUG);
      //$version = ereg_replace('[[:alpha:][:space:]()]+', '', $gd['GD Version']);
      settype($version, 'integer');
      return $version;
    } else {
      return 0;
    }
  }

  ////
  // Rotate image
  ////
  function rotate($name, $r) {
    $dest = $name;
    $old_mask = umask(0);
    $gd = $this->gdVersion();

    if ($gd >= 3) {
      $r = -$r;
      $cmd = MAGICK_PATH_FINAL . " \"$name\" -rotate $r \"$dest\"";
      exec($cmd);
    } else {
      $ext = $this->returnExt($name);
      // Find out what we are dealing with
      switch (true) {
        case preg_match("/jpg|jpeg|jpe|JPG|JPEG|JPE/", $ext):
          if (imagetypes() & IMG_JPG) {
            $src_img = imagecreatefromjpeg($name);
            $type = 'jpg';
          } else {
            return;
          }
          break;
        case preg_match("/png/", $ext):
          if (imagetypes() & IMG_PNG) {
            $src_img = imagecreatefrompng($name);
            $type = 'png';
          } else {
            return;
          }
          break;
        case preg_match("/gif|GIF/", $ext):
          if (imagetypes() & IMG_GIF) {
            $src_img = imagecreatefromgif($name);
            $type = 'gif';
          } else {
            return;
          }
          break;
      }

      if (!isset($src_img)) {
        return;
      };

      $new = imagerotate($src_img, $r, 0);

      if ($type == 'png') {
        imagepng($new, $dest);
      } elseif ($type == 'gif') {
        imagegif($new, $dest);
      } else {
        imagejpeg($new, $dest, 95);
      }

      imagedestroy($src_img);
      imagedestroy($new);
    }
    umask($old_mask);
  }

  ////
  // Check GD
  ////
  function gdVersion_() {
    if (function_exists('exec') && (DS == '/' || (DS == '\\' && MAGICK_PATH_FINAL != 'convert')) && !FORCE_GD) {
      exec(MAGICK_PATH_FINAL . ' -version', $out);
      @$test = $out[0];
      if (!empty($test) && strpos($test, ' not ') === false) {
        $bits = explode(' ', $test);
        $version = $bits[2];
        if (version_compare($version, '6.0.0', '>')) {
          return 4;
        } else {
          return 3;
        }
      } else {
        return $this->_gd();
      }
    } else {
      return $this->_gd();
    }
  }

}

?>