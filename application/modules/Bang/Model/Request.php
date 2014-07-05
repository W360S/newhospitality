<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Feedback.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Bang_Model_Request extends Core_Model_Item_Abstract {

    protected $_owner_type = 'user';
    protected $_parent_type = 'user';
    // protected $_searchColumns = array('feedback_title', 'feedback_description');
    protected $_parent_is_owner = true;

    public function truncate5Title() {
        $tmpBody = strip_tags($this->ad_title);
        return ( Engine_String::strlen($tmpBody) > 5 ? Engine_String::substr($tmpBody, 0, 5) . '..' : $tmpBody );
    }

    public function truncateOwner($owner_name) {
        $tmpBody = strip_tags($owner_name);
        return ( Engine_String::strlen($tmpBody) > 9 ? Engine_String::substr($tmpBody, 0, 9) . '..' : $tmpBody );
    }

}

?>