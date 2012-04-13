<?php
header("Pragma: no-cache");
header("Cache-Control: no-store, no-cache, max-age=0, must-revalidate");
header('Content-Type: text/x-json; charset=utf-8');
header("X-JSON: ");
$json = compact('json');
$json = $json['json'];
$json = $js->object($json);
//$this->log($json, LOG_DEBUG);
echo $json;
?>