<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    Library
 * @version    1
 * @author     huynhnv
 * @function: List book in mypage
 */
class Library_Widget_MyBookshelfController extends Engine_Content_Widget_Abstract{
	
	public function indexAction(){
        
        
	    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if( !$user_id ) {
            return $this->setNoRender();
        }
		$this->view->cnt = Engine_Api::_()->library()->bookShelfCount($user_id);
	}
}