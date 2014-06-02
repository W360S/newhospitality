<?php

class Statistics_IndexController extends Core_Controller_Action_Standard
{
  public function indexAction()
  {
    return $this->_redirect("home/index");
  }
  
  public function contactUsAction()
  {
    $statistic_page = Engine_Api::_()->statistics()->getStatisticsPage('contact-us');
    $this->view->data = $statistic_page;
    $translate        = Zend_Registry::get('Zend_Translate');
   
    $this->view->form = $form = new Statistics_Form_Contact();

    if( !$this->getRequest()->isPost() )
    {
      return;
    }

    if( !$form->isValid($this->getRequest()->getPost()) )
    {
      return;
    }

    // Success! Process

    // Mail gets logged into database, so perform try/catch in this Controller
    $db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    try {
      // the contact form is emailed to the first SuperAdmin by default
      $users_table  = Engine_Api::_()->getDbtable('users', 'user');
      $users_select = $users_table->select()
        ->where('level_id = ?', 1)
        ->where('enabled >= ?', 1);
      $super_admin  = $users_table->fetchRow($users_select);

      $values        = $form->getValues();
      $mail_settings = array(
        'name'    => $values['name'],
        'email'   => $values['email'],
        'message' => $values['body'],
        );
      
      // send email
      Engine_Api::_()->getApi('mail', 'core')->sendSystem(
        $super_admin->email,
        'core_contact',
        $mail_settings);
        
      // save contact
      // Process
      $table = $this->_helper->api()->getDbtable('contacts', 'statistics');
      $contact = $table->createRow();
      $contact->created_date = date('Y-m-d H:i:s');
      $contact->setFromArray($form->getValues());
      $contact->save();

      // if the above did not throw an exception, it succeeded
      $db->commit();
      $this->view->status  = true;
      $this->view->message = $translate->_('Thank you for contacting us!');
    } catch ( Zend_Mail_Transport_Exception $e) {
      $db->rollBack();
      throw $e;
    }
    
    
  }
  
  public function aboutUsAction()
  {

    $statistic_page = Engine_Api::_()->statistics()->getStatisticsPage('about-us');
    $this->view->data = $statistic_page;
  }
  
  public function privacyAction()
  {
    $statistic_page = Engine_Api::_()->statistics()->getStatisticsPage('privacy');
    $this->view->data = $statistic_page;
    $this->view->privacy= "privacy";
  }
  
  public function termsOfServicesAction()
  {
    $statistic_page = Engine_Api::_()->statistics()->getStatisticsPage('terms-of-services');
    $this->view->data = $statistic_page;
    $this->view->term= "terms-of-services";
  }
  public function termsOfUseAction()
  {
    $statistic_page = Engine_Api::_()->statistics()->getStatisticsPage('terms-of-use');
    $this->view->data = $statistic_page;
    $this->view->term= "terms-of-use";
  }
  public function couponAction(){
    $statistic_page = Engine_Api::_()->statistics()->getStatisticsPage('coupon');
    $this->view->data = $statistic_page;
    $this->view->coupon= "coupon";
  }
  //function help
  public function helpAction(){
    $alias= $this->_getParam('slug');
    $category_table= Engine_Api::_()->getDbTable('categories', 'statistics');
    $select_category= $category_table->select()->where('alias =?', $alias);
    $category= $category_table->fetchRow($select_category);
    $category_id= $category->category_id;
    $content_table= Engine_Api::_()->getDbTable('contents', 'statistics');
    $select= $content_table->select()->where('category_id =?', $category_id)->order('priority ASC');
    $contents= $content_table->fetchAll($select);
    $this->view->contents= $contents;
    $this->view->category_id= $category_id;
    $this->view->alias= $alias;
  }
}
