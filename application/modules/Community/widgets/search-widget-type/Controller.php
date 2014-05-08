<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Controller.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Community_Widget_SearchWidgetTypeController extends
    Engine_Content_Widget_Abstract
{
    public function indexAction()
    {
    	$this->getElement()->removeDecorator('Title');
        $searchApi = Engine_Api::_()->getApi('search', 'core');

        // Get available types
        $availableTypes = $searchApi->getAvailableTypes();
        if (is_array($availableTypes) && count($availableTypes) > 0)
        {
            $options = array();
            foreach ($availableTypes as $index => $type)
            {
                if(strtoupper($type) == 'AUTHORIZATION_LEVEL')
                    continue;
                if(strtoupper($type) == 'STATICS_CONTACT')
                    continue;
                if(strtoupper($type) == 'STATICS_FAQ')
                    continue;     
                if(strtoupper($type) == 'USER_BUSINESS_DETAIL')
                    continue;                        
                $options[$type] = strtoupper('ITEM_TYPE_' . $type);
            }
            $this->view->type = $options ;           
        }
        else
        {
            $this->view->type = array();
        }
    }
}
