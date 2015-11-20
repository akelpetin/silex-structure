#!/usr/bin/env sh
# Set dependencies, require composer global
composer require symfony/config --no-update
composer require symfony/twig-bridge --no-update
composer require symfony/form --no-update
composer require symfony/security-csrf --no-update
composer require symfony/translation --no-update
composer require symfony/validator --no-update
composer require swiftmailer/swiftmailer --no-update
composer require twig/twig --no-update
composer install