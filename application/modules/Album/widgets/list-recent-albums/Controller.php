<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Album
 
 * @author     huynhnv
 */
class Album_Widget_ListRecentAlbumsController extends Engine_Content_Widget_Abstract
{
  public function indexAction(){
  	
    // Don't render this if not authorized
    $viewer = Engine_Api::_()->user()->getViewer();
    /*
    if( !Engine_Api::_()->core()->hasSubject() ) {
      return $this->setNoRender();
    }
    

    // Get subject and check auth
    $subject = Engine_Api::_()->core()->getSubject();
    //Zend_Debug::dump($subject);exit();
    if( !$subject->authorization()->isAllowed($viewer, 'view') ) {
      return $this->setNoRender();
    }
    */
    $table = Engine_Api::_()->getItemTable('album');
    $select = $table->select()
      ->where('search = ?', 1)
      ->order('album_id DESC')
      ->limit('20')
      ;

    $paginator = Zend_Paginator::factory($select);
    //Zend_Debug::dump($paginator);exit();
    if( $paginator->getTotalItemCount() <= 0 ) {
      return $this->setNoRender();
    }
	$paginator->setItemCountPerPage(20);
    $this->view->paginator = $paginator;
  }
}