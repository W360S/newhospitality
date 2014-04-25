<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: IndexController.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Group_IndexController extends Core_Controller_Action_Standard
{

  public function init()
  {

    if( !$this->_helper->requireAuth()->setAuthParams('group', null, 'view')->isValid() )
        return;

    $this->getNavigation();

    $id = $this->_getParam('group_id', $this->_getParam('id', null));
    if( $id ) {
        
      $group = Engine_Api::_()->getItem('group', $id);
      if( $group ) {
        Engine_Api::_()->core()->setSubject($group);
      }
    }
  }

  public function browseAction()
  {
    // Navigation
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
            ->getNavigation('group_main');

    // Form
    $this->view->formFilter = $formFilter = new Group_Form_Filter_Browse();
    $defaultValues = $formFilter->getValues();

    $viewer = Engine_Api::_()->user()->getViewer();
    if( !$viewer || !$viewer->getIdentity() ) {
      $formFilter->removeElement('view');
    }

    // Populate options
    foreach( Engine_Api::_()->getDbtable('categories', 'group')->fetchAll() as $row ) {
      $formFilter->category_id->addMultiOption($row->category_id, $row->title);
    }

    // Populate form data
    $tmp = $this->_getAllParams();
    if(key_exists("amp;order",$tmp))
    {
        $tmp["order"]= $tmp["amp;order"];
    }
    if(key_exists("amp;view",$tmp))
    {
        $tmp["view"]= $tmp["amp;view"];
    }
    
    //Zend_Debug::dump($values);
    if($this->_getParam('category') && !(key_exists("category_id", $tmp))){
        $tmp['category_id']= $this->_getParam('category');
    }
    
    if( $formFilter->isValid($tmp) ) {
      $this->view->formValues = $values = $formFilter->getValues();
    } else {
      $formFilter->populate($defaultValues);
      $this->view->formValues = $values = array();
    }

    // Prepare data
    $viewer = $this->_helper->api()->user()->getViewer();
    $this->view->formValues = $values = $formFilter->getValues();
    
    if( $viewer->getIdentity() && @$values['view'] == 1 ) {
      $values['users'] = array();
      foreach( $viewer->membership()->getMembersInfo(true) as $memberinfo ) {
        $values['users'][] = $memberinfo->user_id;
      }
    }

    $values['search'] = 1;
    
    // check to see if request is for specific user's listings
    $user_id = $this->_getParam('user');
    if( $user_id ) $values['user_id'] = $user_id;

    $this->view->paginator = $paginator = $this->_helper->api()->getApi('core', 'group')
            ->getGroupPaginator($values);
    $paginator->setItemCountPerPage(10);
    $paginator->setCurrentPageNumber($this->_getParam('page'));
    //$this->view->category_id= 
    
    $this->_helper->content
                ->setContentName(33) // page_id
                // ->setNoRender()
                ->setEnabled();
  }

  public function createAction()
  {
    if( !$this->_helper->requireUser->isValid() )
        return;
    if( !$this->_helper->requireAuth()->setAuthParams('group', null, 'create')->isValid() )
        return;

    // Create form
    $this->view->form = $form = new Group_Form_Create();

    // Populate with categories
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'group');
    $select = $categoryTable->select()
      ->order('priority ASC');
    foreach($categoryTable->fetchAll($select) as $row ) {
      $form->category_id->addMultiOption($row->category_id, $row->title);
    }

    if( count($form->category_id->getMultiOptions()) <= 1 ) {
      $form->removeElement('category_id');
    }

    // Check method/data validitiy
    if( !$this->getRequest()->isPost() ) {
      return;
    }

    if( !$form->isValid($this->getRequest()->getPost()) ) {
      return;
    }

    // Process
    $values = $form->getValues();
    $viewer = $this->_helper->api()->user()->getViewer();
    $values['user_id'] = $viewer->getIdentity();

    $db = Engine_Api::_()->getDbtable('groups', 'group')->getAdapter();
    $db->beginTransaction();

    try {
      // Create group
      $table = $this->_helper->api()->getDbtable('groups', 'group');
      $group = $table->createRow();
      $group->setFromArray($values);
      $group->save();

      // Add owner as member
      $group->membership()->addMember($viewer)
          ->setUserApproved($viewer)
          ->setResourceApproved($viewer);

      // Set photo
      if( !empty($values['photo']) ) {
        $group->setPhoto($form->photo);
      }

      // Process privacy
      $auth = Engine_Api::_()->authorization()->context;
      
      $roles = array('officer', 'member', 'registered', 'everyone');

      $viewMax = array_search($values['auth_view'], $roles);
      $commentMax = array_search($values['auth_comment'], $roles);
      $photoMax = array_search($values['auth_photo'], $roles);
      $inviteMax = array_search($values['auth_invite'], $roles);

      $officerList = $group->getOfficerList();

      foreach( $roles as $i => $role ) {
        if( $role === 'officer' ) {
          $role = $officerList;
        }
        $auth->setAllowed($group, $role, 'view', ($i <= $viewMax));
        $auth->setAllowed($group, $role, 'comment', ($i <= $commentMax));
        $auth->setAllowed($group, $role, 'photo', ($i <= $photoMax));
        $auth->setAllowed($group, $role, 'invite', ($i <= $inviteMax));
      }
      
      // Create some auth stuff for all officers
      $auth->setAllowed($group, $officerList, 'photo.edit');
      $auth->setAllowed($group, $officerList, 'topic.edit');

      // Add auth for invited users
      $auth->setAllowed($group, 'member_requested', 'view', 1);

      // Add action
      $activityApi = Engine_Api::_()->getDbtable('actions', 'activity');
      $action = $activityApi->addActivity($viewer, $group, 'group_create');
      if( $action ) {
        $activityApi->attachActivity($action, $group);
      }

      // Commit
      $db->commit();

      // Redirect
      return $this->_helper->redirector->gotoRoute(array('id' => $group->getIdentity()), 'group_profile', true);
    } catch( Engine_Image_Exception $e ) {
      $db->rollBack();
      $form->addError(Zend_Registry::get('Zend_Translate')->_('The image you selected was too large.'));
    } catch( Exception $e ) {
      $db->rollBack();
      throw $e;
    }
  }

  public function listAction()
  {
    
  }

  public function manageAction()
  {
    // Navigation
    //    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
    //      ->getNavigation('group_main');
    // Form
    $this->view->formFilter = $formFilter = new Group_Form_Filter_Manage();
    $this->view->formValues = $values = $formFilter->getValues();
    // Populate options
    foreach( Engine_Api::_()->getDbtable('categories', 'group')->fetchAll() as $row ) {
      $formFilter->category_id->addMultiOption($row->category_id, $row->title);
    }
    $tmp= $this->_getAllParams();
    if(key_exists("amp;category_id",$tmp))
    {
        $tmp["category_id"]= $tmp["amp;category_id"];
    }
    if(key_exists("amp;view",$tmp))
    {
        $tmp["view"]= $tmp["amp;view"];
    }
    if(key_exists("amp;text",$tmp))
    {
        $tmp["text"]= $tmp["amp;text"];
    }
    $values['text']= $tmp['text'];
    $values['view']= $tmp['view'];
    $values['category_id']= $tmp['category_id'];
    // Populate form data
    if( $formFilter->isValid($this->_getAllParams()) ) {
      $formValues = $values = $formFilter->getValues();
    } else {
      $formFilter->populate($defaultValues);
      $formValues = $values = array();
    }

    $viewer = $this->_helper->api()->user()->getViewer();
    $membership = Engine_Api::_()->getDbtable('membership', 'group');
    $select = $membership->getMembershipsOfSelect($viewer);
    $category_id= $values['category_id'];
    
    $table = Engine_Api::_()->getItemTable('group');
    $tName = $table->info('name');
    if( $values['view'] == 2 ) {
      $select->where("`{$tName}`.`user_id` = ?", $viewer->getIdentity());
    }
    if( !empty($values['text']) ) {
      $select->where(
          $table->getAdapter()->quoteInto("`{$tName}`.`title` LIKE ?", '%' . $values['text'] . '%') . ' OR ' .
          $table->getAdapter()->quoteInto("`{$tName}`.`description` LIKE ?", '%' . $values['text'] . '%')
      );
    }
    
    if(!empty($category_id)){
       $select->where('category_id = ?', $category_id);
       $this->view->category_id= $category_id;
    }
    $this->view->paginator = $paginator = Zend_Paginator::factory($select);
    $this->view->text = $values['text'];
    $this->view->view = $values['view'];
    $this->view->formValues= $formValues;
    
    $paginator->setCurrentPageNumber($this->_getParam('page'));
    
  }

  public function getNavigation()
  {
    $this->view->navigation = $navigation = new Zend_Navigation();
    $navigation->addPage(array(
      'label' => 'All Groups',
      'route' => 'group_general',
      'action' => 'browse',
      'controller' => 'index',
      'module' => 'group'
    ));

    if( Engine_Api::_()->user()->getViewer()->getIdentity() ) {
      $navigation->addPages(array(
        array(
          'label' => 'My Groups',
          'route' => 'group_general',
          'action' => 'manage',
          'controller' => 'index',
          'module' => 'group'
        ),
        array(
          'label' => 'Create New Group',
          'route' => 'group_general',
          'action' => 'create',
          'controller' => 'index',
          'module' => 'group'
        )
      ));
    }

    return $navigation;
  }

}
