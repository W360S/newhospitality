<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: FriendsController.php 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */

/**
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Experts_UserToExpertsController extends Core_Controller_Action_User
{
  var $friends_enabled = false;

  public function init()
  {
    $ajaxContext = $this->_helper->getHelper('ContextSwitch');
    $ajaxContext
      ->addActionContext('suggest', 'json')
      ->initContext();

    // Try to set subject
    $user_id = $this->_getParam('user_id', null);
    if( $user_id && !Engine_Api::_()->core()->hasSubject() )
    {
      $user = Engine_Api::_()->getItem('user', $user_id);
      if( $user )
      {
        Engine_Api::_()->core()->setSubject($user);
      }
    }
    
  }
  
  // lay cac user trong he thong de chon lam ?
  public function suggestAction()
  {
    $data = array();
    if( $this->_helper->requireUser()->checkRequire() )
    {
      $viewer = Engine_Api::_()->user()->getViewer();
      $table = Engine_Api::_()->getItemTable('user');
      
      $select = Engine_Api::_()->getDbtable('users', 'user')->select();
      $experts = Engine_Api::_()->getDbtable('experts', 'experts')->fetchAll();
      $arr_exps = array();
      if(count($experts)){
        foreach($experts as $item){
            $arr_exps[] = intval($item->user_id);
        }
        $select->where('`'.$table->info('name')."`.`user_id` NOT IN (?)",$arr_exps);
      }
     
      
      if( $this->_getParam('includeSelf', false) ) {
        $data[] = array(
          'type' => 'user',
          'id' => $viewer->getIdentity(),
          'guid' => $viewer->getGuid(),
          'label' => $viewer->getTitle() . ' (you)',
          'photo' => $this->view->itemPhoto($viewer, 'thumb.icon'),
          'url' => $viewer->getHref(),
        );
      }

      if( 0 < ($limit = (int) $this->_getParam('limit', 10)) )
      {
        $select->limit($limit);
      }

      if( null !== ($text = $this->_getParam('search', $this->_getParam('value'))))
      {
        $select->where('`'.$table->info('name').'`.`username` LIKE ?', '%'. $text .'%');
        
      }
      $ids = array();
      foreach( $select->getTable()->fetchAll($select) as $friend )
      {
        $data[] = array(
          'type'  => 'user',
          'id'    => $friend->getIdentity(),
          'guid'  => $friend->getGuid(),
          'label' => $friend->getTitle(),
          'photo' => $this->view->itemPhoto($friend, 'thumb.icon'),
          'url'   => $friend->getHref(),
        );
      }
    
    }
    
    if( $this->_getParam('sendNow', true) )
    {
      return $this->_helper->json($data);
    }
    else
    {
      $this->_helper->viewRenderer->setNoRender(true);
      $data = Zend_Json::encode($data);
      $this->getResponse()->setBody($data);
    }
  }
  
}
