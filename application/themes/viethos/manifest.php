<?php return array (
  'package' => 
  array (
    'type' => 'theme',
    'name' => 'viethos',
    'version' => NULL,
    'revision' => '$Revision: 7242 $',
    'path' => 'application/themes/viethos',
    'repository' => 'socialengine.net',
    'meta' => 
    array (
      'title' => 'viethos',
      'thumb' => 'default_theme.jpg',
      'author' => 'huynhnv',
      'changeLog' => 
      array (
        '4.0.3' => 
        array (
          'manifest.php' => 'Incremented version',
          'theme.css' => 'Added styles for highlighted text in search',
        ),
        '4.0.2' => 
        array (
          'theme.css' => 'Added styles for delete comment link',
        ),
      ),
      'name' => 'viethos',
    ),
    'actions' => 
    array (
      0 => 'install',
      1 => 'upgrade',
      2 => 'refresh',
      3 => 'remove',
    ),
    'callback' => 
    array (
      'class' => 'Engine_Package_Installer_Theme',
    ),
    'directories' => 
    array (
      0 => 'application/themes/default',
    ),
  ),
  'files' => 
  array (
    0 => 'theme.css',
    1 => 'constants.css',
    2 => 'jquery.fancybox.css',
  ),
); ?>