<?php
$CONFIG = array (
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' =>
  array (
    'host' => 'redis',
    'password' => '',
    'port' => 6379,
  ),
  'upgrade.disable-web' => true,
  'passwordsalt' => '1ZcuKL5fO7HSAQi47LYGL2oX/cqufO',
  'secret' => 'xtU/qrcmg72SpVxvE3mjrNYx4AY3VPjBTY1s6WW5lMsOtg2N',
  'trusted_domains' =>
  array (
    0 => 'cloud.waterdreamer.net',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'pgsql',
  'version' => '33.0.3.2',
  'overwrite.cli.url' => 'https://cloud.waterdreamer.net',
  'dbname' => 'nextcloud',
  'dbhost' => 'cloud-db',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'oc_admin',
  'dbpassword' => '1gi1VKo2KCbJebFb3icBCSSPzMt46t',
  'instanceid' => 'och9di52h2fh',
  'installed' => true,
  'trusted_proxies' =>
  array (
    0 => 'cloud-site',
  ),
  'overwritehost' => 'cloud.waterdreamer.net',
  'overwriteprotocol' => 'https',
  'forwarded_for_headers' =>
  array(
    0 => 'HTTP_X_FORWARDED_FOR',
  ),
);
