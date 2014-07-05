<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Feedbacks.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Bang_Model_DbTable_Requests extends Engine_Db_Table {

    protected $_name = 'bang_requests';
    protected $_rowClass = 'Bang_Model_Request';

}

?>