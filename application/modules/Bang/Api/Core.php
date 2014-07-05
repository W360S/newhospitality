<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Core.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Bang_Api_Core extends Core_Api_Abstract {
    
    public function getRequest($request_id) {
        $table = Engine_Api::_()->getDbtable('requests', 'bang');
        $select = $table->select()
                ->where('request_id = ?', $request_id)
                ->limit(1);
        return $table->fetchRow($select);
    }
    
    public function getRequests(){
        return Engine_Api::_()->getDbtable('requests', 'bang')->fetchAll();
    }
}

?>
