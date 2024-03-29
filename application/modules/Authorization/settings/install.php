<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: install.php 9747 2012-07-26 02:08:08Z john $
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Authorization_Install extends Engine_Package_Installer_Module
{
  protected function _runCustomQueries()
  {
    $i = 0;

    // Hack to add 4.0.0rc1 -> 4.0.0rc2 during 4.0.0rc2 -> 4.0.0
    $db = $this->getDb();
    $data = $db->query('SELECT * FROM `engine4_core_menuitems` WHERE `name` = \'authorization_admin_main_manage\'')->fetch();
    if( empty($data) || empty($data['name']) ) {
      $contents = file_get_contents(dirname(__FILE__) . DIRECTORY_SEPARATOR . 'my-upgrade-4.0.0rc1-4.0.0rc2.sql');
      foreach( Engine_Package_Utilities::sqlSplit($contents) as $sqlFragment ) {
        //try {
          $db->query($sqlFragment);
          $i++;
        //} catch( Exception $e ) {
        //  return $this->_error('Query failed with error: ' . $e->getMessage());
        //}
      }
    }

    return $i;
  }
}