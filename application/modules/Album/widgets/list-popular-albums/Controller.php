<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Album
 
 * @author     huynhnv
 */
class Album_Widget_ListPopularAlbumsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    // Don't render this if not authorized
    $viewer = Engine_Api::_()->user()->getViewer();
    if( !Engine_Api::_()->core()->hasSubject() ) {
      return $this->setNoRender();
    }

    // Get subject and check auth
    $subject = Engine_Api::_()->core()->getSubject();
    //Zend_Debug::dump($subject);exit();
    if( !$subject->authorization()->isAllowed($viewer, 'view') ) {
      return $this->setNoRender();
    }
    $table = Engine_Api::_()->getItemTable('album');
    $select = $table->select()
      ->where('search = ?', 1)
      ->order('view_count DESC')
      //->limit('4')
      ;

    $paginator = Zend_Paginator::factory($select);

    if( $paginator->getTotalItemCount() <= 0 ) {
      return $this->setNoRender();
    }

    $this->view->paginator = $paginator;

    
  }
}