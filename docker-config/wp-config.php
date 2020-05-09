<?php

$table_prefix  = getenv('TABLE_PREFIX') ?: 'wp_';

# to read env variables and define them as constants.
foreach ($_ENV as $key => $value) {
    $capitalized = strtoupper($key);
    if (!defined($capitalized)) {
        define($capitalized, $value);
    }
}

/** Database Charset to use in creating database tables. */
#define( 'DB_CHARSET', 'utf8' );
#define( 'DB_HOST', getenv('DB_HOST') );

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}

#* Defines constants and global variables here that can override those in wp-loader.php and default-constants.php
# WP_CONTENT_DIR is defined in wp-load.php and default-constants.php
#define('WP_CONTENT_DIR', ABSPATH . 'wp-content');

require_once(ABSPATH . 'wp-secrets.php');

require_once(ABSPATH . 'wp-settings.php');