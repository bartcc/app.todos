<?php
Configure::write('debug', 0);

header("Pragma: no-cache");
header("Cache-Control: no-store, no-cache, max-age=0, must-revalidate");
header('Content-Type: text/x-json; charset=utf-8');
header("X-JSON: ");

//  $this->log($_item, LOG_DEBUG);
echo json_encode($_serialize);
