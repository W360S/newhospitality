<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Modules.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Model_DbTable_Modules extends Engine_Db_Table
{
  protected $_modules;

  protected $_modulesAssoc = array();

  protected $_enabledModuleNames;

  public function getModule($name)
  {
    if( null === $this->_modules ) {
      $this->getModules();
    }

    if( !empty($this->_modulesAssoc[$name]) ) {
      return $this->_modulesAssoc[$name];
    }

    return null;
  }
  
  public function getModules()
  {
    if( null === $this->_modules ) {
      $this->_modules = $this->fetchAll();
      foreach( $this->_modules as $module ) {
        $this->_modulesAssoc[$module->name] = $module;
      }
    }

    return $this->_modules;
  }

  public function getModulesAssoc()
  {
    if( null === $this->_modules ) {
      $this->getModules();
    }
    
    return $this->_modulesAssoc;
  }

  public function hasModule($name)
  {
    return !empty($this->_modulesAssoc[$name]);
  }

  public function isModuleEnabled($name)
  {
    return in_array($name, $this->getEnabledModuleNames());
  }

  public function getEnabledModuleNames()
  {
    if( null === $this->_enabledModuleNames ) {
      $this->_enabledModuleNames = $this->select()
          ->from($this, 'name')
          ->where('enabled = ?', true)
          ->query()
          ->fetchAll(Zend_Db::FETCH_COLUMN);
    }

    return $this->_enabledModuleNames;
  }
}
