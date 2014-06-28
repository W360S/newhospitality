<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: ImageController.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_ImageController extends Core_Controller_Action_Standard
{
	public function init()
  {
    if( !Engine_Api::_()->core()->hasSubject() ) {
    	if( 0 !== ($image_id = (int) $this->_getParam('image_id')) &&
          null !== ($image = Engine_Api::_()->getItem('feedback_image', $image_id)) ) {
        	Engine_Api::_()->core()->setSubject($image);
      	}

      	else if( 0 !== ($feedback_id = (int) $this->_getParam('feedback_id')) &&
          null !== ($feedback = Engine_Api::_()->getItem('feedback', $feedback_id)) ) {
        	Engine_Api::_()->core()->setSubject($feedback);
      	}
    }
	
	}

	public function viewAction()
  { 
		$this->view->image = $image = Engine_Api::_()->core()->getSubject();
    $this->view->feedback = $feedback = $image->getCollection();
    
    $viewer_id = $this->_helper->api()->user()->getViewer()->getIdentity();
	
    $table = Engine_Api::_()->getDbtable('feedbacks', 'feedback');
    $tableName = $table->info('name');
    $select = $table->select()
    				->from($tableName, array('owner_id', 'feedback_private'))
    				->where('feedback_id = ?', $feedback->feedback_id);
    $resultFeedback = $table->fetchAll($select)->toArray();
    
		if($resultFeedback['0']['feedback_private'] == 'private' && empty($viewer_id)) {
			return $this->_forward('requireauth', 'error', 'core');
		}
		
  	if(!empty($viewer_id)) {
	  	$user_level = Engine_Api::_()->user()->getViewer()->level_id;
		}
		else {
			$user_level = 0;
		}
    if($resultFeedback['0']['feedback_private'] == 'private' && $resultFeedback['0']['owner_id'] != $viewer_id && $user_level != 1) {
    	return $this->_forward('requireauth', 'error', 'core');
    }
    
  }
	
  public function uploadAction()
  {  
    $feedback = Engine_Api::_()->core()->getSubject();
    if( isset($_GET['ul']) || isset($_FILES['Filedata']) ) return $this->_forward('upload-image', null, null, array('format' => 'json', 'feedback_id'=>(int) $feedback->getIdentity()));

    $viewer = Engine_Api::_()->user()->getViewer();
    $feedback = Engine_Api::_()->getItem('feedback', (int) $feedback->getIdentity());

    $album = $feedback->getSingletonAlbum();

    $this->view->feedback_id = $feedback->feedback_id;
    $this->view->form = $form = new Feedback_Form_Image_Upload();
    $form->file->setAttrib('data', array('feedback_id' => $feedback->getIdentity()));

    if( !$this->getRequest()->isPost() ) {
    	return;
    }

    if( !$form->isValid($this->getRequest()->getPost()) ) {
    	return;
    }

    $table = Engine_Api::_()->getItemTable('feedback_image');
    $db = $table->getAdapter();
    $db->beginTransaction();

    try {
    	$values = $form->getValues();
      $params = array(
        'feedback_id' => $feedback->getIdentity(),
        'user_id' => $viewer->getIdentity(),
      );

      $api = Engine_Api::_()->getDbtable('actions', 'activity');
      $action = $api->addActivity(Engine_Api::_()->user()->getViewer(), $feedback, 'feedback_image_upload', null, array('count' => count($values['file'])));

      $count = 0;
      foreach( $values['file'] as $image_id ) {
        $image = Engine_Api::_()->getItem("feedback_image", $image_id);
        if( !($image instanceof Core_Model_Item_Abstract) || !$image->getIdentity() ) continue;
        
        $image->collection_id = $album->album_id;
        $image->album_id = $album->album_id;
        $image->save();

        if ($feedback->image_id == 0) {
          $feedback->image_id = $image->file_id;
          $feedback->save();
        }

        if( $action instanceof Activity_Model_Action && $count < 8 ) {
        	$api->attachActivity($action, $image, Activity_Model_Action::ATTACH_MULTI);
        }
        $count++;
      }

      $db->commit();
    }

    catch( Exception $e ) {
      	$db->rollBack();
      	throw $e;
    }
    $show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;
		if(empty($feedback->owner_id) && !empty($show_browse)) {
			$browse_url = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('success_msg' => 1), 'feedback_browse');
			$this->_redirectCustom($browse_url);
		}
		elseif(!empty($feedback->owner_id)) {
			$this->_redirectCustom($feedback);
		}	
		else{
			$url = $this->_helper->url->url(array(), 'core_home');
			$this->_redirectCustom($url);
		}
  }

  public function uploadImageAction()
  { 
    $feedback = Engine_Api::_()->getItem('feedback', (int) $this->_getParam('feedback_id'));

    //GET VIEWER INFORMATION
    $viewer = Engine_Api::_()->user()->getViewer();
    $viewer_id = $viewer->getIdentity();
    
  	// GET USER LEVEL
    if(!empty($viewer_id)) {     
	  	$user_level = Engine_Api::_()->user()->getViewer()->level_id;
    }
    
    //OWNER OR SUPERADMIN CAN UPLOAD PICTURES
    if($feedback->owner_id != $viewer_id && !empty($feedback->owner_id) && $user_level != 1) {
    	return $this->_forward('requireauth', 'error', 'core');
    }
    
    if(!empty($viewer_id)) {
	    if( !$this->_helper->requireUser()->checkRequire() ) {
	    	$this->view->status = false;
	      $this->view->error = Zend_Registry::get('Zend_Translate')->_('Max file size limit exceeded (probably).');
	      return;
	    }
    }
    if( !$this->getRequest()->isPost() ) {
    	$this->view->status = false;
      $this->view->error = Zend_Registry::get('Zend_Translate')->_('Invalid request method');
      return;
    }

    $values = $this->getRequest()->getPost();
    if( empty($values['Filename']) ) {
    	$this->view->status = false;
      $this->view->error = Zend_Registry::get('Zend_Translate')->_('No file');
      return;
    }

    if( !isset($_FILES['Filedata']) || !is_uploaded_file($_FILES['Filedata']['tmp_name']) ) {
    	$this->view->status = false;
      $this->view->error = Zend_Registry::get('Zend_Translate')->_('Invalid Upload');
      return;
    }

    $db = Engine_Api::_()->getDbtable('images', 'feedback')->getAdapter();
    $db->beginTransaction();

    try {
    	$viewer = Engine_Api::_()->user()->getViewer();
      $album = $feedback->getSingletonAlbum();

      $params = array(
        'collection_id' => $album->getIdentity(),
        'album_id' => $album->getIdentity(),

        'feedback_id' => $feedback->getIdentity(),
        'user_id' => $viewer->getIdentity(),
      );
      
      $feedback->total_images++;
      $feedback->save();
      
      $image_id = Engine_Api::_()->feedback()->createImage($params, $_FILES['Filedata'])->image_id;

      if(!$feedback->image_id) {
        $feedback->image_id = $image_id;
        $feedback->save();
      }

     	$this->view->status = true;
      $this->view->name = $_FILES['Filedata']['name'];
      $this->view->image_id = $image_id;

      $db->commit();
    }

    catch( Exception $e ) {
    	$db->rollBack();
      	$this->view->status = false;
      	$this->view->error = Zend_Registry::get('Zend_Translate')->_('An error occurred.');
      	return;
    }
  }

  //ACTION FOR DELET IMAGE
  public function removeAction()
  { 
  	//GET VIEWER INFORMATION
    $viewer = Engine_Api::_()->user()->getViewer();
    $this->view->viewer_id = $viewer_id = $viewer->getIdentity();
    $feedback_id = (int) $this->_getParam('feedback_id');
    
    $this->view->feedback = $feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
    
    if( $this->getRequest()->isPost() && $this->getRequest()->getPost('confirm') == true ) {
    
	    $image_id= (int) $this->_getParam('image_id');
	    $image = Engine_Api::_()->getItem('feedback_image', $image_id);
	    
	    $db = $image->getTable()->getAdapter();
	    $db->beginTransaction();
	    
    // GET USER LEVEL
    if(!empty($viewer_id)) {     
	  	$user_level = Engine_Api::_()->user()->getViewer()->level_id;
    }
	    
			if(($viewer_id == $image->user_id && $viewer_id != 0) || $user_level == 1) {
		    try {
		      $image->delete();
		      $db->commit();
		    }
		
		    catch( Exception $e ){
		      $db->rollBack();
		      throw $e;
		    }
		    
		    //ASSIGN TOTAL VOTES TO total_votes IN  feedback TABLE
		   	$feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
		   	$feedback->total_images-- ;
		   	$feedback->save();
			}
	    return $this->_redirect("feedbacks/$feedback->owner_id/$feedback_id/$feedback->feedback_slug");
		}
  }

}
?>