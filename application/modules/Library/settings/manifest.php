<?php

return array(
  // Package -------------------------------------------------------------------
  'package' => array(
    'type' => 'module',
    'name' => 'library',
    'version' => '4.0.3',
    'revision' => '$Revision: 7250 $',
    'path' => 'application/modules/Library',
    'repository' => 'socialengine.net',
    'meta' => array(
      'title' => 'Library',
      'description' => 'Library',
      'author' => 'Webligo Developments',
      
    ),
    'actions' => array(
       'install',
       'upgrade',
       'refresh',
       'enable',
       'disable',
     ),
    'callback' => array(
      'path' => 'application/modules/Library/settings/install.php',
      'class' => 'Library_Installer',
    ),
    'directories' => array(
      'application/modules/Library',
    ),
    'files' => array(
      'application/languages/en/library.csv',
    ),
  ),
  
  // Items ---------------------------------------------------------------------
  'items' => array(
    'library',
    'library_book'
    
  ),
  
  // Routes --------------------------------------------------------------------
  'routes' => array(
    'library_edit' => array(
      'route' => 'admin/experts/manage-libraries/edit/book_id/:book_id',
      'defaults' => array(
        'module' => 'experts',
        'controller' => 'admin-manage-libraries',
        'action' => 'edit',
      ),
      'reqs' => array(
        'book_id' => '\d+'
      )
    ),
    
    'book_delete_image' => array(
      'route' => 'admin/experts/manage-libraries/delete/book_id/:book_id/photo_id/:photo_id',
      'defaults' => array(
        'module' => 'library',
        'controller' => 'admin-manage-libraries',
        'action' => 'delete-image',
      ),
      'reqs' => array(
        'book_id' => '\d+',
        'photo_id' => '\d+',
      )
    ),
    
   ),
);