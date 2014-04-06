<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Chat
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: IndexController.php 7300 2010-09-06 07:19:10Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Chat
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @author     John
 */
class Chat_IndexController extends Core_Controller_Action_User
{
  public function indexAction()
  {
    // Get rooms
    $roomTable = Engine_Api::_()->getDbtable('rooms', 'chat');
    $select = $roomTable->select()
      ->where('public = ?', 1);

    $rooms = array();
    foreach( $roomTable->fetchAll($select) as $room ) {
      $rooms[$room->room_id] = $room->toRemoteArray();
    }
    $this->view->rooms = $rooms;
    
    $chat_room_id= $this->_getParam("room_id");
    if($chat_room_id){
        $this->view->chat_room_id= $chat_room_id;
    }
    $viewer = Engine_Api::_()->user()->getViewer();
    $this->view->isOperator = $viewer->authorization()->isAllowed('admin');
  }

  public function banAction()
  {
    
  }
  public function roomAction(){
        $this->_helper->layout->disableLayout();
       	//$this->_helper->viewRenderer->setNoRender();
        $viewer = Engine_Api::_()->user()->getViewer();
    	$this->view->user_id= $viewer->getIdentity();
   	    $table = Engine_Api::_()->getDbTable('rooms', 'chat');
		$select = $table->select()
			  ->from($table)
              ->order('user_count DESC')
			  ->limit(4);
	    $result = $table->fetchAll($select);
	    $this->view->rooms= $result;
  }
}