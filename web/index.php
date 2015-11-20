<?php
require_once __DIR__ . '/../vendor/autoload.php';

require __DIR__ . '/../app/config.php';
$app = require __DIR__ . '/../app/app.php';
require __DIR__ . '/../app/controller.php';

$app->run();
