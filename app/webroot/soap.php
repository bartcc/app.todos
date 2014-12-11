<?php
 /**
 * @desc Gibt die aktuelle Serverzeit zurück
 * @return int
 */
 function getServerTime()
 {
	 return time();
 }

ini_set("soap.wsdl_cache_enabled", "0");
$server = new SoapServer("webservice1.wsdl");
?>