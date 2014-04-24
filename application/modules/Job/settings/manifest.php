<?php return array (
  'package' => 
  array (
    'type' => 'module',
    'name' => 'job',
    'version' => '4.0.0',
    'path' => 'application/modules/Job',
    'meta' => 
    array (
      'title' => 'Jobs',
      'description' => 'About jobs',
      'author' => 'huynhnv',
    ),
    'callback' => 
    array (
      'class' => 'Engine_Package_Installer_Module',
    ),
    'actions' => 
    array (
      0 => 'install',
      1 => 'upgrade',
      2 => 'refresh',
      3 => 'enable',
      4 => 'disable',
    ),
    'directories' => 
    array (
      0 => 'application/modules/Job',
    ),
    'files' => 
    array (
      0 => 'application/languages/en/job.csv',
    ),
  ),
); ?>