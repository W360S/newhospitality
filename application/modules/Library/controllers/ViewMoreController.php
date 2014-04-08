<?php
class Library_ViewMoreController extends Core_Controller_Action_Standard
{
  public function otherBookAction(){
    $page = $this->_getParam('page');
    $viewer = Engine_Api::_()->user()->getViewer();
    
    //$this->view->notifications = $notifications = Engine_Api::_()->getDbtable('notifications', 'activity')->getNotificationsPaginator($viewer);
    
     $select = $this->select()
      ->where('user_id = ?', $user->getIdentity())
      ->where('`type` IN(?)', $enabledNotificationTypes)
      ->order('date DESC')
      ;

    $this->view->notifications = Zend_Paginator::factory($select);
    
    $notifications->setCurrentPageNumber($page);

    if( $notifications->getCurrentItemCount() <= 0 || $page > $notifications->getCurrentPageNumber() ) {
      $this->_helper->viewRenderer->setNoRender(true);
      return;
    }

    // Force rendering now
    $this->_helper->viewRenderer->postDispatch();
    $this->_helper->viewRenderer->setNoRender(true);
  }
  
}