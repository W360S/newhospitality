<?php
/**
 * SocialEngine
 *
 * @category   Application_Theme
 * @package    Default
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: manifest.php 9378 2011-10-13 22:50:30Z john $
 * @author     Alex
 */
return array(
  'package' => array(
    'type' => 'theme',
    'name' => 'newhospitality',
    'version' => '4.6.0',
    'revision' => '$Revision: 9378 $',
    'path' => 'application/themes/newhospitality',
    'repository' => '',
    'title' => 'Modern',
    'thumb' => 'theme.jpg',
    'author' => 'Bang',
    'changeLog' => array(
      '4.6.0' => array(
        'manifest.php' => 'Incremented version',
        'theme.css' => 'Fixed issue with user-select',
      ),
      
    ),
    'actions' => array(
      'install',
      'upgrade',
      'refresh',
      'remove',
    ),
    'callback' => array(
      'class' => 'Engine_Package_Installer_Theme',
    ),
    'directories' => array(
      'application/themes/newhospitality',
    ),
  ),
  'files' => array(
    'theme.css',
    'constants.css',
  ),
) ?>