<?php
class FileComponent extends Object {
   	var $controller = true;
 
	var $dirTags = array(
			'image filename' => 'Image: filename', 'album title' => 'Album: title', 'album id' => 'Album: id', 'album tags' => 'Album: tags', 'date captured' => 'Image: date captured', 'date uploaded' => 'Image: date uploaded', 'image number' => 'Image: number', 'image count' => 'Album: content count', 'tags' => 'Image: tags', 'place taken' => 'Album: place taken', 'date taken' => 'Album: date taken', 'contributor username' => 'Contributor: username', 'contributor email' => 'Contributor: email', 'contributor first name' => 'Contributor: first name', 'contributor last name' => 'Contributor: last name', 'contributor display name' => 'Contributor: display name'  
		);
			
	var $smartTags = array(
			'original album title' => 'Original album: title', 'original album id' => 'Original album: id',
			'original album tags' => 'Original album: tags'
		);
		
	var $iptcTags = array(
			'credit', 'caption', 'copyright', 'title', 'category', 'keywords',
			'byline', 'byline title', 'city', 'state', 'country', 'headline',
			'source', 'contact'
		);
	
	var $exifTags = array(
			'make', 'model', 'exposure', 'exposure mode', 'iso', 'aperture',
			'focal length', 'flash simple', 'flash', 'exposure bias', 'metering mode',
			'white balance', 'title', 'comment', 'latitude', 'longitude'
		);
		
    function startup (&$controller) {
        $this->controller = &$controller;
    }

	function uploadLimit() {
		$max_upload = ini_get('upload_max_filesize');
		$post_max = ini_get('post_max_size');

		$max_upload_n = explode('m', strtolower($max_upload));
		$max_upload_n = $max_upload_n[0];
		
		$post_max_n = explode('m', strtolower($post_max));
		$post_max_n = $post_max_n[0];
		
		$max = $max_upload;
		$post_max_broken = false;
		
		if ($post_max_n < $max_upload_n) { $max = $post_max; $post_max_broken = true; }
		return array($max, $post_max_broken);
	}
	////
	// Fetch account
	////
	function fetchAccount($action = 'dummy') {
		$cache_path = DIR_CACHE . DS . 'account.cache';
		$force_actions = array('preferences', 'activate');
		if (in_array($action, $force_actions)) {
			$account = array();
		} else {
			$account = unserialize(cache($cache_path, null, '+1 day'));
		}
		if (empty($account)) {
			$this->Account =& ClassRegistry::init('Account');
			$account = $to_cache = $this->Account->find('first', array('conditions' => array('not' => array('version' => null))));
			unset($to_cache['Account']['activation_key']);
			unset($to_cache['Account']['api_key']);
			cache($cache_path, serialize($to_cache));
		}
		$users = $this->fetchUsers();
		return array($account, $users);
	}
	
	function fetchUsers() {
		$cache_path_users = DIR_CACHE . DS . 'users.cache';
		$uarr = unserialize(cache($cache_path_users, null, '+1 year'));
		if (empty($uarr)) {
			$this->User =& ClassRegistry::init('User');
			$this->Image =& ClassRegistry::init('Image');
			$this->User->recursive = -1;
			$users = $this->User->findAll();
			$uarr = array();
			foreach($users as $u) {
				$count = $this->Image->find('count', array('conditions' => 'created_by = ' . $u['User']['id'], 'recursive' => -1));
				$uarr[$u['User']['id']] = array('usr' => $u['User']['usr'], 'display_name' => $u['User']['display_name'], 'display_name_fill' => $u['User']['display_name_fill'], 'first_name' =>  $u['User']['first_name'], 'anchor' => $u['User']['anchor'], 'last_name' =>  $u['User']['last_name'], 'externals' => $u['User']['externals'], 'anchor' => $u['User']['anchor'], 'image_count' => $count, 'profile' => $u['User']['profile'], 'email' => $u['User']['email']);
			}
			cache($cache_path_users, serialize($uarr));
		}
		return $uarr;
	}
	
	////
	// Get all slideshows
	////
	function fetchShows() {
		$cache_path = DIR_CACHE . DS . 'shows.cache';
		$shows = cache($cache_path, null, '+1 year');
		if ($shows == 'noshow') {
			$shows = array();
		} elseif (empty($shows)) {
			$this->Slideshow =& ClassRegistry::init('Slideshow');
			$shows = $this->Slideshow->findAll();
			if (empty($shows)) { 
				cache($cache_path, 'noshow');
			} else {
				cache($cache_path, serialize($shows));
			}
		} else {
			$shows = unserialize($shows);
		}
		return $shows;
	}
	
	function scheduling() {
		$this->Image =& ClassRegistry::init('Image');
		$images = $this->Image->find('all', array('conditions' => 'start_on IS NOT NULL OR end_on IS NOT NULL', 'recursive' => -1));
		$now = time();
		$this->Image->begin();
		foreach($images as $image) {
			$active = $this->parseActive($image['Image']['start_on'], $image['Image']['end_on']);
			if ($active != $image['Image']['active']) {
				$this->Image->id = $image['Image']['id'];
				$this->Image->saveField('active', $active);
				$this->Image->Album->reorder($image['Image']['aid']);
			}
		}
		$this->Image->commit();
	}
	
	function parseActive($start, $end) {
		$active = 0;
		$now = time();
		if (is_numeric($start) && is_numeric($end)) {
			if ($start < $now && $now < $end) {
				$active = 1;
			}
		} else if (is_numeric($start)) {
			if ($now > $start) {
				$active = 1;
			} 
		} else {
			if ($now < $end) {
				$active = 1;
			}
		}
		return $active;
	}
	
	////
	// Generate random string
	////
	function randomStr($len = 6) {
		return substr(md5(uniqid(microtime())), 0, $len);
	}
	
	////
	// Central directory creation logic
	// Creates a directory if it does not exits
 	////
	function makeDir($dir) {
		if (!is_dir($dir)) {
			$parent_perms = $this->getPerms(dirname($dir));
			$f = new Folder();
			if ($f->create($dir, octdec($parent_perms))) {
				return true;
			} else if ($parent_perms == '0755') {
				if ($f->chmod($dir, 0777) && $f->create($dir)) {
					return true;
				}
			}
			return false;
		} else {
			return true;
		}
	}
	
	function getPerms($dir) {
		return substr(sprintf('%o', fileperms($dir)), -4);
	}
	
	////
	// Check for import folders
	////
	function checkImports() {
		if (is_dir(IMPORTS) && $handle = opendir(IMPORTS)) {
		    $folders = array();

		    while (false !== ($file = readdir($handle))) {
				$full_path = IMPORTS . DS . $file;
		        if (is_dir($full_path) && file_exists($full_path . DS . 'images.xml') && $file != '.' && $file != '..') {
					$folders[] = $file;
				}
		    }
		
		    closedir($handle);
			return $folders;
		} else {
			return array();
		}
	}
	
	
	////
	// Set permissions on a directory
	////
	function setPerms($dir) {
		if (!is_dir($dir)) {
			return $this->makeDir($dir);
		} elseif (is_writable($dir)) {
			return true;
		} else {
			$test_file = ($dir . DS . '___test___');
			$f = @fopen($test_file, 'a');
			if ($f === false) {
				$fd = new Folder();
				return $fd->chmod($dir, 0777);
			} else {
				fclose($f);
				@unlink($test_file);
				return true;
			}
		}
	}
	
	////
	// Make sure album-audio and album-thumb have the correct perms
	////
	function setOtherPerms() {
		if ($this->setPerms(AUDIO)) {
			return true;
		} else {
			return false;
		}
	}
	
	////
	// Create album subdirectories
	////
	function setAlbumPerms($id) {
		$path = ALBUMS . DS . 'album-' . $id;
		$lg = $path . DS . 'lg';
		$cache = $path . DS . 'cache';
	
		if ($this->setPerms($lg) && $this->setPerms($cache)) {
			return true;
		} else {
			return false;
		}
	}
	
	////
	// Process permissions for album subdirectories
	////
	function createAlbumDirs($id) {
		$path = 'album-' . $id;
		$path = ALBUMS . DS . $path;
		$lg = $path . DS . 'lg';
		$cache = $path . DS . 'cache';
		
		if ($this->makeDir($lg) && $this->makeDir($cache)) {
			return true;
		} else {
			return false;
		}
	}
	
	////
	// Search a directory for a filename using a regular expression
	// Found in PHP docs: http://us3.php.net/manual/en/function.file-exists.php#64908
	////
	
	function regExpSearch($regExp, $dir, $regType='P', $case='') {
		$func = ( $regType == 'P' ) ? 'preg_match' : 'ereg' . $case;
		$open = opendir($dir);
		$files = array();
		while( ($file = readdir($open)) !== false ) {
			if ($func($regExp, $file) ) {
				$files[] = $file;
			}
		}
		return $files;
	}
	
	////
	// Grab the extension of of any file
	////
	function returnExt($file, $raw = false) {
		$pos = strrpos($file, '.');
		$ext = substr($file, $pos+1, strlen($file));
		if ($raw) {
			return $ext;
		} else {
			return strtolower($ext);
		}
	}

	////
	// Grab all files in a directory
	////
	function directory($dir, $filters = 'all') {
		if ($filters == 'accepted') { $filters = 'jpg,JPG,JPEG,jpeg,gif,GIF,png,PNG,swf,SWF,flv,FLV,f4v,F4V,mov,MOV,mp4,MP4,m4v,MV4,m4a,M4A,3gp,3GP,3g2,3G2'; }
		$handle = opendir($dir);
		$files = array();
		if ($filters == "all"):
			while (($file = readdir($handle))!==false):
				$files[] = $file;
			endwhile;
		endif;
		if ($filters != "all"):
			$filters = explode(",", $filters);
			while (($file = readdir($handle))!==false):
				for ($f=0; $f< sizeof($filters); $f++):
					$system = explode(".", $file);
					$count = count($system);
					if ($system[$count-1] == $filters[$f]):
						$files[] = $file;
					endif;
				endfor;
			endwhile;
		endif;
		closedir($handle);
		return $files;
	}
	
	////
	// Recursive Directory Removal
	////
	function rmdirr($dir) {
	   	$f = new Folder();
		$f->delete($dir);
	}

	////
	// Transform a string (e.g. 15MB) into an actual byte representation
	////
	function returnBytes($val) {
	   $val = trim($val);
	   $last = strtolower($val{strlen($val)-1});
	   switch($last) {
	       case 'g':
	           	$val *= 1024;
	       case 'm':
	           	$val *= 1024;
	       case 'k':
	           	$val *= 1024;
	   }
	   return $val;
	}
	
	function formLink($image, $album, $original = null, $watermark_array = array()) {
		if (is_null($original)) {
			$original = $album;
		}
		
		$src = $image['src'];
		
		if (isNotImg($src)) {
			return array('', 0);
		}
		
		$template = urldecode($album['link_template']);
		$arr = explode('__~~__', $template);
		$template = $arr[0];
		@$target = $arr[1];
		if (isset($arr[2])) {
			$diff_with = $arr[2];
		}

		$file_path = ALBUMS . DS . 'album-' . $original['id'] . DS . 'lg' . DS . $src;
		$path = DIR_HOST . '/' . ALBUM_DIR . '/album-' . $original['id'];
		
		$source = $path . '/lg/' . $src;
		$template = $this->_form($template, $file_path, $image, $album, $original);
		
		$rel_path = str_replace('/index.php?', '', $this->controller->base) . '/' . ALBUM_DIR . '/album-' . $original['id'] . '/lg/' . $src;
		
		$specs = getimagesize($file_path);
		
		$template = r('[full_hr_url]', $source, $template);
		$template = r('[rel_path]', $rel_path, $template);
		$template = r('[img_w]', $specs[0], $template);
		$template = r('[img_h]', $specs[1], $template);
		$template = r('[img_src]', $src, $template);
		$template = r('[img_title]', $image['title'], $template);
		$template = r('[img_caption]', $image['caption'], $template);
		$template = r('[album_name]', $album['name'], $template);
		$template = r('[album_id]', $album['id'], $template);
		$template = r('[true_album_id]', $original['id'], $template);
		$template = r('[img_id]', $image['id'], $template);
		
		$arr = unserialize($image['anchor']);
		if (empty($arr)) {
			$arr['x'] = $arr['y'] = 50;
		}
		
		if (empty($watermark_array)) {
			$watermark_array['watermark_id'] = $watermark_array['watermark_location'] = $watermark_array['watermark_opacity'] = 0;
		}
		
		$template = preg_replace('/\[width:(\d+),height:(\d+),crop:(\d),quality:(\d+),sharpening:(\d)\]/e', "__p(array('src' => '$src', 'album_id' => {$original['id']}, 'width' => \\1, 'height' => \\2, 'square' => \\3, 'quality' => \\4, 'sharpening' => \\5, 'anchor_x' => {$arr['x']}, 'anchor_y' => {$arr['y']}, 'watermark_id' => {$watermark_array['watermark_id']}, 'watermark_location' => {$watermark_array['watermark_location']}, 'watermark_opacity' => {$watermark_array['watermark_opacity']}))", $template);

		if (isset($diff_with) && $template == $diff_with) {
			$template = '';
		}
		return array($template, $target);
	}
	
	function _date($format, $date, $tz = true) {
		setlocale(LC_TIME, explode(',', __('[#Set the locale to use for date translations. (http://php.net/setlocale) You can specify as many locales as you like and Director will use the first available from your list. Example: es_MX,es_ES,es_AR#]en_US', true)));
		if (strpos($date, '-') !== false) {
			$date = strtotime($date);
		}
		if ($tz) {
			$offset = $_COOKIE['dir_time_zone'];
			$date = $date + $offset;
		}
		return r('  ', ' ', strftime($format, $date));
	}
	
	
	function formTitle($image, $album, $original = null) {
		if (is_null($original)) {
			$original = $album;
		}
		$path = ALBUMS . DS . 'album-' . $original['id'] .  DS . 'lg' . DS . $image['src'];
		return $this->_form($album['title_template'], $path, $image, $album, $original);
	}
	
	
	function formCaption($image, $album, $original = null) {
		if (is_null($original)) {
			$original = $album;
		}
		$path = ALBUMS . DS . 'album-' . $original['id'] .  DS . 'lg' . DS . $image['src'];
		return $this->_form($album['caption_template'], $path, $image, $album, $original);
	}
	
	function parseMetaTags($template, $data, $empty = 'Unknown') {
		$bits = explode(':', $template);
		if ($bits[0] == 'iptc') {
			if (isset($data['IPTC'])) {
				$iptc = $data['IPTC'];
				switch($template) {
					case 'iptc:credit':
						@$tag = $iptc['2#110'];
						break;
					case 'iptc:category':
						@$tag = $iptc['2#050'];
						break;				
					case 'iptc:keywords':
						@$tag = $iptc['2#025'];
						if (is_array($tag)) {
							$tag = join(' ', $tag);
						}
						break;
					case 'iptc:byline':
						@$tag = $iptc['2#080'];
						if (is_array($tag)) {
							$tag = $tag[0];
					 	}
						if (strpos($tag, 'Picasa') !== false) {
							$tag = '';
						}
						break;
					case 'iptc:byline title':
						@$tag = $iptc['2#085'];
						break;
					case 'iptc:city':
						@$tag = $iptc['2#090'];
						break;	
					case 'iptc:state':
						@$tag = $iptc['2#095'];
						break;
					case 'iptc:country':
						@$tag = $iptc['2#101'];
						break;				
					case 'iptc:headline':
						@$tag = $iptc['2#105'];
						break;
					case 'iptc:title':
						@$tag = $iptc['2#005'];
						break;
					case 'iptc:source':
						@$tag = $iptc['2#115'];
						break;				
					case 'iptc:copyright':
						@$tag = $iptc['2#116']; 
						break;
					case 'iptc:contact':
						@$tag = $iptc['2#118'];
						break;
					case 'iptc:caption':
						@$tag = $iptc['2#120'];
						break;
				}
			}

			if (isset($tag)) {
				if (!empty($tag)) {
					if (is_array($tag)) {
						$tag = $tag[0];
				 	}
					if (function_exists('mb_detect_encoding')) {
						$encoding = mb_detect_encoding($tag);
					} else {
						$encoding = 'UTF-8';
					}
					if (is_string($tag)) {
						switch ($encoding) {
							case 'ASCII':
								// Nothing to do here, encoding will be handled
								// by api helper if needed
								break;
							default:
								if (is_callable('iconv')) {
									$encoding = '';
									# Weed out charsets
									foreach(array('UTF-8', 'CP1250', 'MacRoman') as $enc) {
										@$test = iconv($enc, $enc, $tag);
										if (md5($test) == md5($tag)) {
											$encoding = $enc;
											break;
										}
									}
									if ($encoding == 'CP1250' || $encoding == 'MacRoman') {
										$tag = iconv($encoding, "UTF-8", $tag);
									} else if (empty($encoding)) {
										$tag = utf8_encode($tag);
									}
								} else {
									if (utf8_encode(utf8_decode($tag)) != $tag) {
										$tag = utf8_encode($tag);
									}
								}
								break;
						}
						return $tag;
					} else {
						return '';
					}
				} else {
					return $empty;
				}
			} else {
				return '';
			}
		} else {
			if (isset($data['Exif']['EXIF'])) {
			$exif = $data['Exif']['EXIF'];
			switch($template) {
				case 'exif:make':
					return @$data['Exif']['IFD0']['Make'];
					break;
				case 'exif:title':
					return @$data['Exif']['IFD0']['ImageDescription'];
					break;
				case 'exif:comment':
					return @$data['Exif']['COMPUTED']['UserComment'];
					break;
				case 'exif:model':
					return @$data['Exif']['IFD0']['Model'];
					break;
				case 'exif:exposure':
					return @$exif['ExposureTime'];
					break;
				case 'exif:iso':
					return @$exif['ISOSpeedRatings'];
					break;
				case 'exif:aperture':
					return @$this->exif_frac2dec($exif['FNumber']);
					break;
				case 'exif:focal length':
					return @$this->exif_frac2dec($exif['FocalLength']);
					break;
				case 'exif:exposure mode':
					if (isset($exif['ExposureMode'])) {
						switch($exif['ExposureMode']) {
							case 0: return 'Easy shooting'; break;
							case 1: return 'Program'; break;
							case 2: return 'Tv-priority'; break;
							case 3: return 'Av-priority'; break;
							case 4: return 'Manual'; break;
							case 5: return 'A-DEP'; break;
							default: return 'Unknown'; break;
						}
					} else {
						return 'Unknown';
					}
					break;
				case 'exif:exposure bias':
					if (isset($exif['ExposureBiasValue'])) {
						list($n, $d) = explode('/', $exif['ExposureBiasValue']);
						if (!empty($n)) {
							return $exif['ExposureBiasValue'] . ' EV';
						} else {
							return '0 EV';
						}
						return $this->exif_frac2dec($exif['ExposureBiasValue']) . ' EV';
					} else {
						return 'Unknown';
					}
					break;	
				case 'exif:metering mode':
					if (isset($exif['MeteringMode'])) {
						switch($exif['MeteringMode']) {
							case 0: return 'Unknown'; break;
							case 1: return 'Average'; break;
							case 2: return 'Center Weighted Average'; break;
							case 3: return 'Spot'; break;
							case 4: return 'Multi-Spot'; break;
							case 5: return 'Multi-Segment'; break;
							case 6: return 'Partial'; break;
							case 255: return 'Other'; break;
						}
					} else {
						return 'Unknown';
					}
					break;
				case 'exif:white balance':
					if (isset($exif['WhiteBalance'])) {
						switch($exif['WhiteBalance']) {
							case 0: return 'Auto'; break;
							case 1: return 'Sunny'; break;
							case 2: return 'Cloudy'; break;
							case 3: return 'Tungsten'; break;
							case 4: return 'Fluorescent'; break;
							case 5: return 'Flash'; break;
							case 6: return 'Custom'; break;
							case 129: return 'Manual'; break;
						}
					} else {
						return 'Unknown';
					} 
					break;
				case 'exif:flash simple':
					if (isset($exif['Flash'])) {
						if (in_array($exif['Flash'], array(0,16,24,32))) {
							return 'Flash did not fire';
						} else {
							return 'Flash fired';
						}
					} else {
						return 'Unknown';
					}
					break;
				case 'exif:latitude':
				case 'exif:longitude':
					if (isset($data['Exif']['GPS'])) {
						$gps = $data['Exif']['GPS'];
						$type = ucwords(array_pop(explode(':', $template)));
						return $this->gps_convert($gps["GPS{$type}"], $gps["GPS{$type}Ref"]);
					}  else {
						return '';
					}
					break;
				case 'exif:flash':
					if (isset($exif['Flash'])) {
						switch($exif['Flash']) {
							case 0: return 'No Flash'; break;
							case 1: return 'Flash'; break;
							case 5: return 'Flash, strobe return light not detected'; break;
							case 7: return 'Flash, strob return light detected'; break;
							case 9: return 'Compulsory Flash'; break;
							case 13: return 'Compulsory Flash, Return light not detected'; break;
							case 16: return 'No Flash'; break;
							case 24: return 'No Flash'; break;
							case 25: return 'Flash, Auto-Mode'; break;
							case 29: return 'Flash, Auto-Mode, Return light not detected'; break;
							case 31: return 'Flash, Auto-Mode, Return light detected'; break;
							case 32: return 'No Flash'; break;
							case 65: return 'Red Eye'; break;
							case 69: return 'Red Eye, Return light not detected'; break;
							case 71: return 'Red Eye, Return light detected'; break;
							case 73: return 'Red Eye, Compulsory Flash'; break;
							case 77: return 'Red Eye, Compulsory Flash, Return light not detected'; break;
							case 79: return 'Red Eye, Compulsory Flash, Return light detected'; break;
							case 89: return 'Red Eye, Auto-Mode'; break;
							case 93: return 'Red Eye, Auto-Mode, Return light not detected'; break;
							case 95: return 'Red Eye, Auto-Mode, Return light detected'; break;
							default: return 'Unknown'; break;
						}
					} else {
						return 'Unknown';
					}
					break;
			}
			}
		}
	}
	
	function exif_frac2dec($str) {
		@list( $n, $d ) = explode( '/', $str );
		if ( !empty($d) )
			return $n / $d;
		return $str;
	}
	
	function _form($field, $path, $image, $album, $original = null) {
		if (strpos($field, ':contributor') !== false) {
			if (defined(ACCOUNT_ID)) {
				$users = $this->fetchUsers(ACCOUNT_ID);
			} else {
				$users = $this->fetchUsers();
			}
			$u = $users[$image['created_by']];
			$set_to = str_replace('[director:contributor username]', $u['usr'], $field);
			$set_to = str_replace('[director:contributor first name]', $u['first_name'], $set_to);
			$set_to = str_replace('[director:contributor last name]', $u['last_name'], $set_to);
			$set_to = str_replace('[director:contributor display name]', $u['display_name_fill'], $set_to);
			$set_to = str_replace('[director:contributor email]', $u['email'], $set_to);
		} else {
			$set_to = $field;
		}
		
		$set_to = str_replace('[director:image filename]', $image['src'], $set_to);
		$set_to = str_replace('[director:album name]', $album['name'], $set_to);
		$set_to = str_replace('[director:album title]', $album['name'], $set_to);
		$set_to = str_replace('[director:album id]', $album['id'], $set_to);
		$set_to = str_replace('[director:album tags]', $album['tags'], $set_to);
		$set_to = str_replace('[director:image number]', $image['seq'], $set_to);
		$set_to = str_replace('[director:image count]', $album['images_count'], $set_to);
		$set_to = str_replace('[director:tags]', $image['tags'], $set_to);
		
		
		if (!is_null($original)) {
			$set_to = str_replace('[director:original album title]', $original['name'], $set_to);
			$set_to = str_replace('[director:original album id]', $original['id'], $set_to);
			$set_to = str_replace('[director:original album tags]', $original['tags'], $set_to);
		} 
		
		$set_to = str_replace('[director:place taken]', $original['place_taken'], $set_to);
		$set_to = str_replace('[director:date taken]', $original['date_taken'], $set_to);
		
		if (strpos($field, '[director:date captured') !== false) {
			preg_match_all('/\[director:date captured(:.*?)?\]/', $field, $matches);
			for ($i = 0; $i < count($matches[0]); $i++) {
				$t = $matches[1][$i];
				if (empty($t)) {
					$t = '%m/%d/%Y %I:%M%p';
				} else {
					$t = ltrim($t, ':');
				}
				if (empty($image['captured_on'])) {
					$set_to = str_replace($matches[0][$i], '', $set_to);
				} else {
					$set_to = str_replace($matches[0][$i], $this->_date($t, $image['captured_on'], false), $set_to);
				}
			}		
		}
		
		if (strpos($field, '[director:date uploaded') !== false) {
			preg_match_all('/\[director:date uploaded(:.*?)?\]/', $field, $matches);
			for ($i = 0; $i < count($matches[0]); $i++) {
				$t = $matches[1][$i];
				if (empty($t)) {
					$t = '%m/%d/%Y %I:%M%p';
				} else {
					$t = ltrim($t, ':');
				}
				if (empty($image['created_on'])) {
					$set_to = str_replace($matches[0][$i], '', $set_to);
				} else {
					$set_to = str_replace($matches[0][$i], $this->_date($t, $image['created_on'], false), $set_to);
				}
			}		
		}
		
		list($data, $dummy) = $this->imageMetadata($path);
		foreach($this->iptcTags as $meta) {
			$value = $this->parseMetaTags("iptc:$meta", $data);
			@$set_to = str_replace("[iptc:$meta]", $value, $set_to);
		}
		
		
		foreach($this->exifTags as $meta) {
			$value = $this->parseMetaTags("exif:$meta", $data);
			$set_to = str_replace("[exif:$meta]", $value, $set_to);
		}
		
		return $set_to;
	}
	
	function imageMetadata($path) {
		$meta = array();
		$captured_on = null;
		$meta_s = null;
		
		if (!isNotImg(basename($path))) {
			$meta = array();
			if (is_callable('iptcparse')) {
				getimagesize($path, $info);
				if (!empty($info['APP13'])) {
					$meta['IPTC'] = iptcparse($info['APP13']);
				}
				if (!empty($iptc['2#055'][0]) && !empty($iptc['2#060'][0])) {
					$captured_on = strtotime($iptc['2#055'][0] . ' ' . $iptc['2#060'][0]);
				}
			}
			
			if (eregi('\.jpg|\.jpeg', basename($path)) && is_callable('exif_read_data')) {
				@$exif_data = exif_read_data($path, 0, true);
				$meta['Exif'] = $exif_data;
				if (isset($meta['Exif']['EXIF']['DateTimeDigitized'])) {
					$dig = $meta['Exif']['EXIF']['DateTimeDigitized'];
				} else if (isset($meta['Exif']['EXIF']['DateTimeOriginal'])) {
					$dig = $meta['Exif']['EXIF']['DateTimeOriginal'];
				}
				if (isset($dig)) {
					$bits = explode(' ', $dig);
					$captured_on = strtotime(str_replace(':', '-', $bits[0]) . ' ' . $bits[1]);
				}
			}
		}
		return array($meta, $captured_on);			
	}
	
	function _divide($str) {
		$bits = explode('/', $str);
		$dec = $bits[0] / $bits[1];
		return $dec;
	}
	
	function gps_convert($arr, $quadrant) {
		$d = $this->_divide($arr[0]);
		$m = $this->_divide($arr[1]);
		$s = $this->_divide($arr[2]);
		$dec = ((($s/60)+$m)/60) + $d;
		if (strtolower($quadrant) == 's' || strtolower($quadrant) == 'w') {
			$dec = -$dec;	
		}
		return $dec;
	}
	
	function ffmpeg() {
		if (function_exists('exec') && (DS == '/' || (DS == '\\' && FFMPEG_PATH_FINAL != 'ffmpeg'))) {
			exec(FFMPEG_PATH_FINAL . ' -version  2>&1', $out);
			if (empty($out)) {
				return false;
			} else {
				if (strpos($out[0], 'FFmpeg') !== false) {
					return true;
				} else {
					return false;
				}
			}
		}
		return false;
	}
}

?>