 <?php
 /**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    News
 
 * @version    1.0
 * @author     huynhnv
 * @status     done
 */
 class Recruiter_AdminProfileController extends Core_Controller_Action_Admin{
    public function indexAction() {
    	
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('recruiter_admin_main', array(), 'recruiter_admin_main_profile');
        
        $new = Engine_Api::_()->getItem('artical', $this->_getParam('id'));
        //Zend_Debug::dump($new, 'new');exit();
        
        if($new!= null){
          $this->view->new = $new;
    
          //$this->view->bookMarkTags = $bookmark->tags()->getTagMaps();
          //$this->view->userTags = $bookmark->tags()->getTagsByTagger($bookmark->getOwner());
         
          //$tam= Engine_Api::_()->getItemTable('book_mark');
          if($new->category_id !=0) $this->view->category = $categories = Engine_Api::_()->news()->getCategory($new->category_id);
          //Zend_Debug::dump($categories,'cate');
        }    
        else{
            //$this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
              //      ->getNavigation('news_admin_main', array(), 'news_admin_main_manage');
              $this->renderScript('admin-profile/empty.tpl');
             
        }
    }
    public function createAction() {
    	
    	$this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('recruiter_admin_main', array(), 'recruiter_admin_main_profile');
        if( !$this->_helper->requireUser()->isValid() ) return;
        // check if user has create rights
        //if( !$this->_helper->requireAuth()->setAuthParams('blog', null, 'create')->isValid()) return;
        
        //$this->view->navigation = $this->getNavigation();
        /* Create form */
        //Zend_Debug::dump(Engine_Api::_()->getItemTable('news_new')->fetchAll());
        $this->view->form = $form = new Recruiter_Form_Artical_Create();
        
        // If not post or form not valid, return
        if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
        {
          $table = Engine_Api::_()->getItemTable('artical');
          $db = $table->getAdapter();
          $db->beginTransaction();
          //Zend_Debug::dump(Engine_Api::_()->getItemTable('news_new'), "dh");exit();
          try
          {
            // Create artical
            $viewer = Engine_Api::_()->user()->getViewer();
            $values = array_merge($form->getValues(), array(
             
              'user_id' => $viewer->getIdentity(),
              
            ));
           
            $artical = $table->createRow();
            $artical->created= date('Y-m-d H:i:s');
            $artical->modified= date('Y-m-d H:i:s');
            $artical->setFromArray($values);
            $artical->save();
            //end save form news
            // Add photo
            
            if( !empty($values['photo']) ) {
                //Zend_Debug::dump($form->photo, 'php');exit();
                $artical->setPhotos($form->photo);
                $artical->save();
            }    
            // Add tags
            $tags = preg_split('/[,]+/', $values['tags']);
            $artical->tags()->addTagMaps($viewer, $tags);
            // Commit
            $db->commit();                  
    
            // Redirect
            $this->_forward('artical', 'admin-manage', 'recruiter');
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
                    ->getNavigation('recruiter_admin_main', array(), 'recruiter_admin_main_profile');
        
        if( !$this->_helper->requireUser()->isValid() ) return;

        $viewer = $this->_helper->api()->user()->getViewer();
        //Zend_Debug::dump($bookmark_id, 'vl');exit();
        //Zend_Debug::dump($this->_getParam('bookmark_id'));exit();
        $artical = Engine_Api::_()->getItem('artical', $this->_getParam('artical_id'));
        //Zend_Debug::dump($new);exit();
        //$bookmark= Engine_Api::_()->getItemTable('book_mark')->find($this->_getParam('bookmark_id'))->current();
        if( !Engine_Api::_()->core()->hasSubject('artical') )
        {
          Engine_Api::_()->core()->setSubject($artical);
        }
    
        if( !$this->_helper->requireSubject()->isValid() ) return;
        
        $this->view->form = $form = new Recruiter_Form_Artical_Edit();
        // Save blog entry
        if( !$this->getRequest()->isPost())
        {
         
          // prepare tags
          $newTags = $artical->tags()->getTagMaps();
    
          $tagString = '';
          foreach( $newTags as $tagmap )
          {
            if( $tagString !== '' ) $tagString .= ', ';
            $tagString .= $tagmap->getTag()->getTitle();
          }
          $form->tags->setValue($tagString);
    
          // etc
          $form->populate($artical->toArray());
          return;
        }
    
        if( !$form->isValid($this->getRequest()->getPost()) )
        {
          return;
        }
        // Process
    
        // handle save for tags
        $values = $form->getValues();
        $tags = preg_split('/[,]+/', $values['tags']);
    
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        try
        {
          $artical->setFromArray($values);
          $artical->modified = date('Y-m-d H:i:s');
          $artical->save();
          if( !empty($values['photo']) ) {
                //Zend_Debug::dump($form->photo, 'php');exit();
                $artical->setPhotos($form->photo);
                $artical->save();
            }    
          // handle tags
          $artical->tags()->setTagMaps($viewer, $tags);
    
          $db->commit();
    
          $this->_forward('artical', 'admin-manage', 'recruiter');  
    
        }
        catch( Exception $e )
        {
          $db->rollBack();
          throw $e;
        }
    }
   
}
 