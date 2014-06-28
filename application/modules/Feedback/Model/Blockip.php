<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Blockip.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_Model_Blockip extends Core_Model_Item_Abstract
{
 
	public function getTable()
	{
    if( is_null($this->_table) ) {
      $this->_table = Engine_Api::_()->getDbtable('blockips', 'feedback');
    }

    return $this->_table;
	}

 	public function isOwner($owner)
  {
    if( $owner instanceof Core_Model_Item_Abstract ) {
      return ( $this->getIdentity() == $owner->getIdentity() && $this->getType() == $owner->getType() );
    }
		else if( is_array($owner) && count($owner) === 2 ) {
      return ( $this->getIdentity() == $owner[1] && $this->getType() == $owner[0] );
    }
    else if( is_numeric($owner) ) {
      return ( $owner == $this->getIdentity() );
    }

    return false;
  }

  public function getOwner()
  {
    return $this;
  }
}
?>