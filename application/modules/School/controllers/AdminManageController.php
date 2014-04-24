<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    School 
 

 * @author     huynhnv
 * @status     done
 */
class School_AdminManageController extends Core_Controller_Action_Admin
{
    public function indexAction(){
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
            ->getNavigation('school_admin_main', array(), 'school_admin_main_manage');
       
        $table = Engine_Api::_()->getDbtable('schools', 'school');
        $select= $table->select()
                    ->order('created DESC')
                    ;  
      
        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        //Zend_Debug::dump($paginator);exit;
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($page);
    }
     public function deleteAction()
    {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->school_id= $school_id= $id;
        
        // Check post
        if( $this->getRequest()->isPost())
        {
          $db = Engine_Db_Table::getDefaultAdapter();
          $db->beginTransaction();
    
          try
          {
            
            $school= Engine_Api::_()->getDbtable('schools', 'school')->find($id)->current();
            $user_id= $school->user_id;
            Engine_Api::_()->getApi('core','school')->deleteArtical($id, $user_id);
            //xoa activity
            $action= Engine_Api::_()->getApi('core', 'school')->deleteSchoolActivity($id);
            $action_id= $action->action_id;
            if($action){
				$action->delete();
			}
            //xoa school
            //$school->delete();
            
            Engine_Api::_()->getItem('school_school', $school_id)->delete();
            //Engine_Api::_()->getApi('core', 'school')->deleteCommentSchool($action_id);
            $db->commit();
          }
    
          catch( Exception $e )
          {
            $db->rollBack();
            throw $e;
          }
    
    
          $this->_forward('success', 'utility', 'core', array(
              'smoothboxClose' => 10,
              'parentRefresh'=> 10,
              'messages' => array('')
          ));
        }
        // Output
        $this->renderScript('admin-manage/delete.tpl');
  }
  public function deleteselectedAction()
  {
        $this->view->ids = $ids = $this->_getParam('ids', null);
        $confirm = $this->_getParam('confirm', false);
        $this->view->count = count(explode(",", $ids));
    
        // Save values
        if( $this->getRequest()->isPost() && $confirm == true )
        {
          $ids_array = explode(",", $ids);
          foreach( $ids_array as $id ){
            
             $school= Engine_Api::_()->getDbtable('schools', 'school')->find($id)->current();
             $user_id= $school->user_id;
             Engine_Api::_()->getApi('core','school')->deleteArtical($id, $user_id);
             //xoa activity
             $action= Engine_Api::_()->getApi('core', 'school')->deleteSchoolActivity($id);
             if($action){
                $action_id= $action->action_id;
                $action->delete();
             }
             
             //$school->delete();
             
             Engine_Api::_()->getItem('school_school', $school->school_id)->delete();
             //Engine_Api::_()->getApi('core', 'school')->deleteCommentSchool($action_id);
          }
    
          $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }

  }   
}