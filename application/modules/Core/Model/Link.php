<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Link.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Model_Link extends Core_Model_Item_Abstract
{
  public function getHref()
  {
    return Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
      'module' => 'core',
      'controller' => 'link',
      'action' => 'index',
      'id' => $this->link_id,
      'key' => $this->getKey(),
    ), 'default', true);
  }

  public function getKey()
  {
    return md5($this->link_id . $this->uri);
  }

  public function isDeletable()
  {
    return $this->authorization()->isAllowed(null, 'delete');
  }
}