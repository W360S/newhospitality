<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Controller.php 9812 2012-11-01 02:14:01Z matthew $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class User_Widget_HomeFriendsController extends Engine_Content_Widget_Abstract
{
  protected $_childCount;
  
  public function indexAction()
  {

    //General Friend settings
    $this->view->make_list = Engine_Api::_()->getApi('settings', 'core')->user_friends_lists;

    // Don't render this if not authorized
    $viewer = Engine_Api::_()->user()->getViewer();
    // Multiple friend mode
    $select = $viewer->membership()->getMembersOfSelect();
    $this->view->friends = $friends = $paginator = Zend_Paginator::factory($select);  

    // Set item count per page and current page number
    $paginator->setItemCountPerPage($this->_getParam('itemCountPerPage', 5));
    $paginator->setCurrentPageNumber($this->_getParam('page', 1));

    // Get stuff
    $ids = array();
    foreach( $friends as $friend ) {
      $ids[] = $friend->resource_id;
    }
    $this->view->friendIds = $ids;

    // Get the items
    $friendUsers = array();
    foreach( Engine_Api::_()->getItemTable('user')->find($ids) as $friendUser ) {
      $friendUsers[$friendUser->getIdentity()] = $friendUser;
    }
    $this->view->friendUsers = $friendUsers;

    // Get lists if viewing own profile
    
    

    // Do not render if nothing to show
    if( $paginator->getTotalItemCount() <= 0 ) {
      return $this->setNoRender();
    }

    // Add count to title if configured
    if( $this->_getParam('titleCount', false) && $paginator->getTotalItemCount() > 0 ) {
      $this->_childCount = $paginator->getTotalItemCount();
    }
  }

  public function getChildCount()
  {
    return $this->_childCount;
  }
}