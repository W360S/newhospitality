<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Abstract.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
abstract class Core_Model_Abstract
{
  /**
   * @var string The module name of this model (say that 12 times fast)
   */
  protected $_moduleName;

  /**
   * Get the module this model belongs to
   * 
   * @return string The module name of this model 
   */
  public function getModuleName()
  {
    if( empty($this->_moduleName) )
    {
      $class = get_class($this);
      if (preg_match('/^([a-z][a-z0-9]*)_/i', $class, $matches)) {
        $prefix = $matches[1];
      } else {
        $prefix = $class;
      }
      $this->_moduleName = $prefix;
    }
    return $this->_moduleName;
  }

  /**
   * Magic caller
   *
   * @param string $method
   * @param array $arguments
   */
  public function __call($method, $arguments)
  {
    throw new Core_Model_Exception(sprintf('Unimplemented method %1$s in class %2$s', $method, get_class($this)));
  }
}