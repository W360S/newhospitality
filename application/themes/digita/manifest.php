<?php
/**
 * SocialEngine
 *
 * @category   Application_Theme
 * @package    Digita
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: manifest.php 10064 2013-06-19 21:30:42Z john $
 * @author     Bryan
 */

return array(
  'package' => array(
    'type' => 'theme',
    'name' => 'digita',
    'version' => '4.6.0',
    'revision' => '$Revision: 10064 $',
    'path' => 'application/themes/digita',
    'repository' => '',
    'title' => 'Digita',
    'thumb' => 'digita.jpg',
    'author' => 'Webligo Developments',
    'changeLog' => array(
      '4.6.0' => array(
        'manifest.php' => 'Incremented version',
        'theme.css' => 'Fixed issue with user-select',
      ),
      '4.2.0' => array(
        'manifest.php' => 'Incremented version',
        'theme.css' => 'Fixed issue with feed comment option list',
      ),
      '4.1.8p1' => array(
        'manifest.php' => 'Incremented version',
        'theme.css' => 'Fixed issue with new pages in the layout editor',
      ),
      '4.1.8' => array(
        'manifest.php' => 'Incremented version',
        'mobile.css' => 'Added styles for HTML5 input elements',
        'theme.css' => 'Added styles for HTML5 input elements',
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
      'application/themes/digita',
    ),
  ),
  'files' => array(
    'theme.css',
    'constants.css',
  ),
) ?>