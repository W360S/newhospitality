<?php 
class School_AdminProfileController extends Core_Controller_Action_Admin{
    
    public function indexAction(){
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('school_admin_main', array(), 'school_admin_main_profile');
        
        $content = Engine_Api::_()->getItem('school_school', $this->_getParam('id'));
        
        if($content== null){
          
              $this->renderScript('admin-profile/empty.tpl');
             
        }
    }
    public function createAction(){
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('school_admin_main', array(), 'school_admin_main_profile');
        if( !$this->_helper->requireUser()->isValid() ) return;
        $this->view->form = $form = new School_Form_School_Create();
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries= $countryTable->fetchAll();
        foreach( $countries as $country ) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
    	{
    	  $db = Engine_Api::_()->getDbtable('schools', 'school')->getAdapter();
          $db->beginTransaction();
    	  
    	  try
    	  {
    		// Create book
    		$viewer = Engine_Api::_()->user()->getViewer();
    	    $table = $this->_helper->api()->getDbtable('schools', 'school');
    		$school = $table->createRow();
    		$values = $form->getValues();
           
            $data = array(
                "name"=>$values['name'], 
                "user_id" => Engine_Api::_()->user()->getViewer()->getIdentity(),
                "intro"=> $values['intro'],
                "country_id"=> $values['country_id'],
                "website"=>$values['website'],
                "address"=> $values['address'],
                "email"=> $values['email'],
                "fax"=> $values['fax'],
                "phone"=> $values['phone'],
                "created"=>date('Y-m-d H:i:s'),
                "modified"=> date('Y-m-d H:i:s'),
                "code"=>"SCL"."-".time()
            );
    		
            $school->setFromArray($data);
    		$result_school = $school->save();
    		//end save form book
    		
            // Add photo
    		if( !empty($values['photo']) ) {
    		    $school->setPhotos($form->photo);
    			$school->save();
    		}
            //add activity
            $owner= $this->_helper->api()->user()->getViewer();
            $action = Engine_Api::_()->getDbtable('actions', 'activity')->addActivity($owner, $school, 'school_new');
            if($action!=null){
              Engine_Api::_()->getDbtable('actions', 'activity')->attachActivity($action, $school);
            }
            $actionTable = Engine_Api::_()->getDbtable('actions', 'activity');
              foreach( $actionTable->getActionsByObject($school) as $action ) {
                $actionTable->resetActivityBindings($action);
              }
    		// Commit
    		$db->commit();
    
    		// Redirect
    		//return $this->_helper->redirector->gotoRoute(array('action'=>'manage'));
             $this->_forward('index', 'admin-manage', 'school');
    	  }
    
    	  catch( Exception $e )
    	  {
    		$db->rollBack();
    		throw $e;
    	  }
    	}
    }
    public function editAction(){
    	//$this->view->navigation= $this->getNavigation();
    	$this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('school_admin_main', array(), 'school_admin_main_profile');
        if( !$this->_helper->requireUser()->isValid() ) return;
        $this->view->form = $form = new School_Form_School_Edit();
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries= $countryTable->fetchAll();
        foreach( $countries as $country ) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        $this->view->school_id = $school_id= $this->_getParam('school_id');
        
        
        
        $school = Engine_Api::_()->getDbtable('schools', 'school')->find($school_id)->current();
    	
    	if( !Engine_Api::_()->core()->hasSubject('school') )
    	{
    	  Engine_Api::_()->core()->setSubject($school);
    	}
    
    	if( !$this->_helper->requireSubject()->isValid() ) return;
    
    	//Save entry
    	if( !$this->getRequest()->isPost())
    	{
    	  // etc
    	  $form->populate($school->toArray());
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
    	 
          // update photo
          if( !empty($values['photo']) ) {
            // get old data
            $old_photo_data = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($school->photo_id);
            Engine_Api::_()->getApi('core', 'school')->deleteImages($old_photo_data);
            
            $school->setPhotos($form->photo);
          }
          
          
          $school->setFromArray($values);
          
          $school->save();
    	  $db->commit();
    	  //return $this->_helper->redirector->gotoRoute(array('action'=>'manage', 'school_id'=>null));
          $this->_forward('index', 'admin-manage', 'school');
        }
    	catch( Exception $e )
    	{
    	  $db->rollBack();
    	  throw $e;
    	}
     }
     public function createArticleAction(){
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('school_admin_main', array(), 'school_admin_main_profile');
        if( !$this->_helper->requireUser()->isValid() ) return;
        $this->view->form = $form = new School_Form_Artical_Create();
        $tableSchool= Engine_Api::_()->getDbtable('schools', 'school');
        $select= $tableSchool->select()->where('user_id =?', Engine_Api::_()->user()->getViewer()->getIdentity());
        /*
        $schools= $tableSchool->fetchAll($select);
        foreach($schools as $school){
            $form->school_id->addMultiOption($school->school_id, $school->name);
        }
        */
        $this->view->school_id = $school_id= $this->_getParam('school_id');
        if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
    	{
    	  $db = Engine_Api::_()->getDbtable('articals', 'school')->getAdapter();
          $db->beginTransaction();
    	  
    	  try
    	  {
    		// Create book
    		$viewer = Engine_Api::_()->user()->getViewer();
    	    $table = $this->_helper->api()->getDbtable('articals', 'school');
    		$artical = $table->createRow();
    		$values = $form->getValues();
           
            $data = array(
                "title"=>$values['title'], 
                "user_id" => Engine_Api::_()->user()->getViewer()->getIdentity(),
                "school_id"=> $school_id,
                "content"=> $values['content'],
                "created"=> date('Y-m-d H:i:s'),
                "modified"=> date('Y-m-d H:i:s'),
                "rating"=> 0,
                "total"=> 0,
                "approved"=> 1
            );
    		
            $artical->setFromArray($data);
    		$artical->save();
    		//increate num artical
            $school= Engine_Api::_()->getDbtable('schools', 'school')->find($school_id)->current();
            $school->num_artical+=1;
            $school->save();
    		// Commit
    		$db->commit();
    
    		// Redirect
    		//return $this->_helper->redirector->gotoRoute(array('action'=>'manage'));
            $this->_forward('index', 'admin-artical', 'school');
    	  }
    
    	  catch( Exception $e )
    	  {
    		$db->rollBack();
    		throw $e;
    	  }
    	}
     }
 }