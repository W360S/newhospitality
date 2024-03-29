<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Payment
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Packages.php 9747 2012-07-26 02:08:08Z john $
 * @author     John Boehr <j@webligo.com>
 */

/**
 * @category   Application_Core
 * @package    Payment
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Payment_Model_DbTable_Packages extends Engine_Db_Table
{
  protected $_rowClass = 'Payment_Model_Package';

  public function getEnabledPackageCount()
  {
    return $this->select()
      ->from($this, new Zend_Db_Expr('COUNT(*)'))
      ->where('enabled = ?', 1)
      ->query()
      ->fetchColumn()
      ;
  }

  public function getEnabledNonFreePackageCount()
  {
    return $this->select()
      ->from($this, new Zend_Db_Expr('COUNT(*)'))
      ->where('enabled = ?', 1)
      ->where('price > ?', 0)
      ->query()
      ->fetchColumn()
      ;
  }
}