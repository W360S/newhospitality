<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    School 
 

 * @author     huynhnv
 * @status     done
 */
class School_AdminArticalController extends Core_Controller_Action_Admin
{
    public function indexAction(){
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
            ->getNavigation('school_admin_main', array(), 'school_admin_main_artical');
       
        $table = Engine_Api::_()->getDbtable('articals', 'school');
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
        $this->view->artical_id=$id;
        
        // Check post
        if( $this->getRequest()->isPost())
        {
          $db = Engine_Db_Table::getDefaultAdapter();
          $db->beginTransaction();
    
          try
          {
            
            $artical= Engine_Api::_()->getDbtable('articals', 'school')->find($id)->current();
            $school= Engine_Api::_()->getDbtable('schools', 'school')->find($artical->school_id)->current();
            $school->num_artical -=1;
            $school->save();
            //delete comments
            Engine_Api::_()->getApi('core', 'school')->deleteComment($id);
            //delete ratings
            Engine_Api::_()->getApi('core', 'school')->deleteRatingArtical($id);
            $artical->delete();
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
        $this->renderScript('admin-artical/delete.tpl');
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
            
            $artical= Engine_Api::_()->getDbtable('articals', 'school')->find($id)->current();
            $school= Engine_Api::_()->getDbtable('schools', 'school')->find($artical->school_id)->current();
            $school->num_artical -=1;
            $school->save();
            //delete comments
            Engine_Api::_()->getApi('core', 'school')->deleteComment($id);
            //delete ratings
            Engine_Api::_()->getApi('core', 'school')->deleteRatingArtical($id);
            $artical->delete();
          }
    
          $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }

  }
  public function editAction(){
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('school_admin_main', array(), 'school_admin_main_profile');
    if( !$this->_helper->requireUser()->isValid() ) return;
    $this->view->form = $form = new School_Form_Artical_Edit();
    $this->view->artical_id = $artical_id= $this->_getParam('artical_id');    
    $artical = Engine_Api::_()->getDbtable('articals', 'school')->find($artical_id)->current();
    /*
	$tableSchool= Engine_Api::_()->getDbtable('schools', 'school');
    $select= $tableSchool->select()->where('user_id =?', Engine_Api::_()->user()->getViewer()->getIdentity());
    $schools= $tableSchool->fetchAll($select);
    foreach($schools as $school){
        if($artical->school_id== $school->school_id){
            $form->school_id->setValue($school->school_id);
        }
        $form->school_id->addMultiOption($school->school_id, $school->name);
        
    }
    */
    $school_id_edit= $artical->school_id;
    
	if( !Engine_Api::_()->core()->hasSubject('school_artical') )
	{
	  Engine_Api::_()->core()->setSubject($artical);
	}

	if( !$this->_helper->requireSubject()->isValid() ) return;

	//Save entry
	if( !$this->getRequest()->isPost())
	{
	  // etc
	  $form->populate($artical->toArray());
	  return;
	}

	if( !$form->isValid($this->getRequest()->getPost()) )
	{
	  return;
	}

	// Process
	$values = $form->getValues();
	
	$db = Engine_Db_Table::getDefaultAdapter();
	$db->beginTransaction();
	try
	{     
      $artical->setFromArray($values);
      $artical->school_id= $school_id_edit;
      $artical->save();
      
	  $db->commit();
	  //return $this->_helper->redirector->gotoRoute(array('action'=>'manage', 'artical_id'=>null));
      $this->_forward('index', 'admin-artical', 'school');
    }
	catch( Exception $e )
	{
	  $db->rollBack();
	  throw $e;
	}
  }   
  //approved article
  public function approveAction(){
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->article_id=$id;
    $viewer= Engine_Api::_()->user()->getViewer();
    // Check post
    if( $this->getRequest()->isPost())
    {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
        
      try
      {
        $article = Engine_Api::_()->getItem('school_artical', $id);
        $article->approved= 1;
        $article->save();
        //school
        $school= Engine_Api::_()->getDbtable('schools', 'school')->find($article->school_id)->current();
        $school->num_artical+=1;
        $school->save();
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
          'messages' => array('Approve Success')
      ));
    }
    // Output
    $this->renderScript('admin-artical/approve.tpl');
  }
}