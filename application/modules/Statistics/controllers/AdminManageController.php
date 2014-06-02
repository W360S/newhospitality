<?php

class Statistics_AdminManageController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_manage');
     
    //$page = $this->_getParam('page',1);
    $this->view->paginator = Engine_Api::_()->statistics()->getStatisticsPaginator();
    
    $this->view->paginator->setItemCountPerPage(10);
    $this->view->paginator->setCurrentPageNumber($this->_getParam('page'));
    //Zend_Debug::dump($navigation); exit;
  }
  
  public function viewAction()
  {
    $this->_helper->layout->setLayout('admin-simple');
    if( !$this->_helper->requireUser()->isValid() ) return;
    $statistics = Engine_Api::_()->statistics()->getItem($this->_getParam('statistic_id'));
    $this->view->statistics = $statistics;
  }
  
  public function createAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_manage');
    if( !$this->_helper->requireUser()->isValid() ) return;
    //if( !$this->_helper->requireAuth()->setAuthParams('statistic', null, 'create')->isValid()) return;
    //$this->_helper->layout->setLayout('admin-simple');
    // Prepare form
    $this->view->form = $form = new Statistics_Form_Admin_Create();
   
    // Check post/form
    if( !$this->getRequest()->isPost() ) {
      return;
    }
    if( !$form->isValid($this->getRequest()->getPost()) ) {
      return;
    }
    // Process
    $db = Engine_Api::_()->getDbtable('statistics', 'statistics')->getAdapter();
    $db->beginTransaction();
    
    try
    {
      // Create statistics page
      $viewer = Engine_Api::_()->user()->getViewer();
      $values = array_merge($form->getValues(), array(
        'owner_type' => $viewer->getType(),
        'owner_id' => $viewer->getIdentity(),
      ));
      
      $table = $this->_helper->api()->getDbtable('statistics', 'statistics');
      $statistics = $table->createRow();
      $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($values['title']);
      $statistics->setFromArray($values);
      $statistics->alias= $slug;
      $statistics->save();
      $db->commit(); 
      //return $this->_helper->redirector->gotoRoute(array('action' => 'manage'));
      //$this->_forward('index', 'admin-manage', 'statistics');
      $this->_redirect('/admin/statistics/manage', array('exit'=>false));
    }
    catch( Exception $e )
    {
      $db->rollBack();
      throw $e;
    }
  }
  
  public function editAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_manage');
    if( !$this->_helper->requireUser()->isValid() ) return;
    
    $viewer = $this->_helper->api()->user()->getViewer();
    
    $this->view->statistic_id = $this->_getParam('statistic_id');
    $statistics = Engine_Api::_()->statistics()->getItem($this->_getParam('statistic_id'));
   
    // Prepare form
    $this->view->form = $form = new Statistics_Form_Admin_Edit();
    // Populate form
    $form->populate($statistics->toArray());
   
    // Check post/form
    if( !$this->getRequest()->isPost() ) {
      return;
    }
    if( !$form->isValid($this->getRequest()->getPost()) ) {
      return;
    }

    // Process
    $db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    
    try
    {
      $values = $form->getValues();
      $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($values['title']);
      $statistics->setFromArray($values);
      $statistics->alias= $slug;
      $statistics->save();
      $db->commit();
      //return $this->_helper->redirector->gotoRoute(array('action' => 'manage'));
      //$this->_forward('index', 'admin-manage', 'statistics');
      $this->_redirect('/admin/statistics/manage', array('exit'=>false));
    }
    catch( Exception $e )
    {
      $db->rollBack();
      throw $e;
    }

    
  }
  
  public function deleteAction()
  {
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->statistics_id=$id;
    // Check post
    if( $this->getRequest()->isPost())
    {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
        $statistics = Engine_Api::_()->statistics()->getItem($id);
        $statistics->delete();
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
  
  // Manage contact
  public function listContactAction(){
    
    //$page = $this->_getParam('page',1);
    $this->view->paginator = Engine_Api::_()->statistics()->getContactsPaginator();
    $this->view->paginator->setItemCountPerPage(10);
    $this->view->paginator->setCurrentPageNumber($this->_getParam('page'));
  }
  
  // view contact
  public function viewContactAction(){
    
    $this->_helper->layout->setLayout('admin-simple');
    if( !$this->_helper->requireUser()->isValid() ) return;
    $contact = Engine_Api::_()->getDbtable('contacts', 'statistics')->find($this->_getParam('contact_id'))->current();
    $this->view->contact = $contact;
  }
  
  public function deleteSelectedContactAction()
  {
    $this->view->ids = $ids = $this->_getParam('ids', null);
    $confirm = $this->_getParam('confirm', false);
    $this->view->count = count(explode(",", $ids));

    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
        
      $ids_array = explode(",", $ids);
      
      foreach( $ids_array as $id ){
        $contact = Engine_Api::_()->getDbtable('contacts', 'statistics')->find($id)->current();
        if( $contact ) $contact->delete();
      }

      $this->_helper->redirector->gotoRoute(array('action' => 'list-contact'));
    }

  }
  
  public function sendEmailSelectedContactAction()
  {
    $this->view->contact_ids = $contact_ids = $this->_getParam('contact_ids', null);
    $confirm = $this->_getParam('confirm', false);
    $this->view->count = count(explode(",", $contact_ids));

    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $from = "admin@viethospitality.com";
      $from_name = "Viethospitality admin";
      $subject = "[Thank for contact us]" + $this->_getParam('name');
      $body = $this->_getParam('body');
      
      $contact_ids_array = explode(",", $contact_ids);
      $emails = array();
      foreach( $contact_ids_array as $contact_ids ){
        $contact = Engine_Api::_()->getDbtable('contacts', 'statistics')->find($contact_ids)->current();
        $emails[] =  $contact['email'];
      }
      
      $this->_sendmail($from, $from_name, $subject, $body, $emails);
      $this->_helper->redirector->gotoRoute(array('action' => 'list-contact'));
    }

  }
  
  public function _sendmail($from, $from_name=null,$subject, $body, $emails){
    // temporarily enable queueing if requested
    $temporary_queueing = Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing;
    if (isset($values['queueing']) && $values['queueing']) {
      Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing = 1;
    }

    $mailApi = Engine_Api::_()->getApi('mail', 'core');

    $mail = $mailApi->create();
    $mail
      ->setFrom($from, $from_name)
      ->setSubject($subject)
      ->setBodyHtml($body)
      ;

    
    foreach( $emails as $email ) {
      $mail->addTo($email);
    }

    $mailApi->send($mail);

    $mailComplete = $mailApi->create();
    $mailComplete
      ->addTo(Engine_Api::_()->user()->getViewer()->email)
      ->setFrom($from, $from_name)
      ->setSubject('Mailing Complete: '.$subject)
      ->setBodyHtml('Your email blast to your members has completed.  Please note that, while the emails have been
        sent to the recipients\' mail server, there may be a delay in them actually receiving the email due to
        spam filtering systems, incoming mail throttling features, and other systems beyond SocialEngine\'s control.')
      ;
    $mailApi->send($mailComplete);

    // emails have been queued (or sent); re-set queueing value to original if changed
    if (isset($values['queueing']) && $values['queueing']) {
      Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing = $temporary_queueing;
    }
  }
  
  public function deleteContactAction(){
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->contact_id=$id;
    // Check post
    if( $this->getRequest()->isPost())
    {
      
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
        $contact = Engine_Api::_()->getDbtable('contacts', 'statistics')->find($id)->current();
        if( $contact ) $contact->delete();
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
    $this->renderScript('admin-manage/delete-contact.tpl');
  }
  
  
  
}
