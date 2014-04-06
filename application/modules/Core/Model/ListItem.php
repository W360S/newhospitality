<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: ListItem.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Model_ListItem extends Core_Model_Item_Abstract
{
  protected $_searchTriggers = false;
  
  public function getChild()
  {
    $type = $this->getParent()->child_type;
    return Engine_Api::_()->getItem($type, $this->child_id);
  }
}