<?php return array(
  'package' => array(
    'type' => 'library',
    'name' => 'scaffold',
    'version' => '4.5.0',
    'revision' => '$Revision: 10033 $',
    'path' => 'application/libraries/Scaffold',
    'repository' => '',
    'title' => 'CSS Scaffold',
    'author' => 'Webligo Developments',
    'changeLog' => array(
      '4.5.0' => array(
        'manifest.php' => 'Incremented version',
        'views/scaffold_error.php' => 'Fixed potential XSS',
      ),
      '4.1.1' => array(
        'manifest.php' => 'Incremented version',
        'modules/Absolute_Urls.php' => 'Added hack to send expires flush counter to images in the stylesheets'
      ),
      '4.0.3' => array(
        'libraries/Scaffold/Scaffold.php' => 'Fix for open_basedir warning',
        'manifest.php' => 'Incremented version',
      ),
      '4.0.2' => array(
        'libraries/Scaffold/Scaffold.php' => 'Fix for open_basedir warning',
        'manifest.php' => 'Incremented version',
      ),
    ),
    'directories' => array(
      'application/libraries/Scaffold',
    )
  )
) ?>