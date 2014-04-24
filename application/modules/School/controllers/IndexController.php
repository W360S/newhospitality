<?php

class School_IndexController extends Core_Controller_Action_Standard
{
  public function indexAction()
  {
    $this->view->someVar = 'someVal';
  }
  //khoa chuc nang nay lai vi khong cho member tao:)
  /*
  public function createAction(){
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
            "modified"=> date('Y-m-d H:i:s')
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
		return $this->_helper->redirector->gotoRoute(array('action'=>'manage'));
	  }

	  catch( Exception $e )
	  {
		$db->rollBack();
		throw $e;
	  }
	}
  }
  public function editAction(){
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
	  return $this->_helper->redirector->gotoRoute(array('action'=>'manage', 'school_id'=>null));
    }
	catch( Exception $e )
	{
	  $db->rollBack();
	  throw $e;
	}
  }
  //manage 
   public function manageAction(){
        if( !$this->_helper->requireUser()->isValid() ) return;
        $user= Engine_Api::_()->user()->getViewer();
        
        $table = Engine_Api::_()->getItemTable('school_school');
        $select= $table->select()->where('user_id = ?', $user->getIdentity())->order('num_artical DESC')->order('created DESC')
                                
        ;
        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($page);
    }
     public function deleteAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $school_id= $this->getRequest()->getPost('school_id');
            $user_id= Engine_Api::_()->user()->getViewer()->getIdentity();
            $school = Engine_Api::_()->getDbtable('schools', 'school')->find($school_id)->current();
            $result=0;
            try{
                $result=1;
                //xoa artical related
                Engine_Api::_()->getApi('core','school')->deleteArtical($school_id, $user_id);
                //xoa activity
                $action= Engine_Api::_()->getApi('core', 'school')->deleteSchoolActivity($school_id);
                $action_id= $action->action_id;
                $action->delete();
                //xoa school
                //$school->delete();          
                Engine_Api::_()->getItem('school_school', $school_id)->delete();
                //xoa comments activity
                //Engine_Api::_()->getApi('core', 'school')->deleteCommentSchool($action_id);
            }
            catch(Exception $e ){
                throw $e;
            }
            echo $result;
            exit;
        }
    }
    */
    public function viewAction(){
        
        $school_id= $this->_getParam('id');
        //thiết lập title for page
        $subject = null;
        if( !Engine_Api::_()->core()->hasSubject() ){
            $subject = Engine_Api::_()->getItem('school_school', $school_id);
            if( $subject && $subject->getIdentity())
            {
              Engine_Api::_()->core()->setSubject($subject);
            }
        }
        
        $school= Engine_Api::_()->getDbtable('schools', 'school')->find($school_id)->current();
        $this->view->school= $school;
        //view count
        $viewer_id= Engine_Api::_()->user()->getViewer()->getIdentity();
        if($viewer_id != $school->user_id){
            $school->view_count++;
            $school->save();
        }
        $this->view->viewer_id= $viewer_id;
        // get other news
        $other_news = Engine_Api::_()->getApi('core', 'school')->getArticals($school_id);
        
        
        
        $this->view->other_new_articals =  $other_news['new'];
        //get comments
        $tableArticle= Engine_Api::_()->getDbtable('articals', 'school');
        $tableComment= Engine_Api::_()->getDbtable('comments', 'school');
        $rName= $tableComment->info('name');
        $aName= $tableArticle->info('name');
        $select= $tableComment->select()
                    ->setIntegrityCheck(false)
                    ->from($rName)
                    ->distinct()
                    
                    ->joinLeft($aName, $aName. ".artical_id = ". $rName . ".artical_id")  
                    ->where($aName.'.school_id =?', $school_id)             
                    ->limit(5)
                    ->order($rName.'.created DESC');
        $comments= $tableComment->fetchAll($select);
        //Zend_Debug::dump($comments);exit;
        $this->view->comments= $comments;
        
    }
    public function hotelSchoolAction(){
    $this->_helper->layout->disableLayout();
    if ($this->_request->isXmlHttpRequest()) {
       $table= Engine_Api::_()->getDbtable('schools', 'school');
        $select= $table->select()
                        ->order('view_count DESC')
                        ->limit(15)
                         ;
        $records= $table->fetchAll($select);
        $this->view->paginator= $paginator= Zend_Paginator::factory($records);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(3);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        $paginator->setPageRange(5);
    }
  }
  public function searchAction(){
    $url= Zend_Controller_Front::getInstance()->getRequest();
    $input_search= $input_search_temp= $url->getParam('input_search');
    $country_search= $country_search_temp= $url->getParam('country_id');
    if($input_search=='Enter your keyword') $input_search= "";
    $table_school = Engine_Api::_()->getDbtable('schools', 'school');
    $rName= $table_school->info('name');
    $tmp = $this->_getAllParams();
    $values= array();
    
    if(key_exists("amp;country_id",$tmp)){
        $country_search= $country_search_temp = $values['country_id']=$tmp['amp;country_id'];
    }
    if(key_exists("amp;input_search",$tmp)){
        $input_search= $input_search_temp = $values['input_search']=$tmp['amp;input_search'];
    }
    $values['input_search']= $input_search;
    $values['country_id']= $country_search;
    //co the viet gon hon nua neu xet mot trong hai truong country_search va input_search
    if(!empty($country_search) && empty($input_search)){
        $select = $table_school
                    ->select()
                    ->distinct()             
                    //->where('approved =?', 1)    
                    ->where('country_id =?', $country_search)
                    //->where('deadline >?', date('Y-m-d H:i:s'))                  
                    ;
    }  
    else if(empty($country_search) && empty($input_search)){
        $select = $table_school
                    ->select()
                    ->distinct()
                    //->where('approved =?', 1)                 
                    ;
    }
    else if(empty($country_search) && !empty($input_search)){
        $select = $table_school
                    ->select()
                    ->distinct()
                    //->where('approved =?', 1)   
                    ->where($rName.".name LIKE ? OR ".$rName.".intro LIKE ?", '%'.$input_search.'%')
                    ->order('created DESC')
                    ;
    }
    else if(!empty($input_search)&& !empty($country_search)){
        $select = $table_school
                    ->select()
                    ->distinct()
                    //->where('approved =?', 1)   
                    ->where('country_id =?', $country_search) 
                    ->where($rName.".name LIKE ? OR ".$rName.".intro LIKE ?", '%'.$input_search.'%')
                    ->order('created DESC')
                    ;
    }
    
    //Zend_Debug::dump($country_search_temp);
    $this->view->page = $page = $this->_getParam('page', 1);
    $paginator = $this->view->paginator = Zend_Paginator::factory($select);
    $paginator->setItemCountPerPage(10);
    $paginator->setCurrentPageNumber($page);
    $this->view->input_search= $input_search_temp;
    $this->view->country_search= $country_search_temp;
    $this->view->values= $values;
  }
  //view all articles of school
  public function viewAllAction(){
    $viewer_id= Engine_Api::_()->user()->getViewer()->getIdentity();
    $this->view->viewer_id= $viewer_id;
    $school_id = $this->_getParam('id');
    $school= Engine_Api::_()->getDbtable('schools', 'school')->find($school_id)->current();
    $this->view->school= $school;
    $table = Engine_Api::_()->getItemTable('school_artical');
    $select= $table->select()
		->where('school_id = ?', $school_id)
		->where('approved =?', 1)
		->order('comment_count DESC')
		->order('view_count DESC')
                            
    ;
    $this->view->page = $page = $this->_getParam('page', 1);
    $paginator = $this->view->paginator = Zend_Paginator::factory($select);
    $paginator->setItemCountPerPage(10);
    $paginator->setCurrentPageNumber($page);
    
  }
}
