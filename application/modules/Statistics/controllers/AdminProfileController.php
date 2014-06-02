<?php
 /**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Statistics
 
 * @version    1.0
 * @author     huynhnv
 * @status     done
 */
 class Statistics_AdminProfileController extends Core_Controller_Action_Admin{
    public function indexAction() {
    	
        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_profile');
        
        $statistic = Engine_Api::_()->getItemTable('statistics_content')->find($this->_getParam('id'))->current();
        //Zend_Debug::dump($new, 'new');exit();
        
        if($statistic!= null){
          $this->view->statistic = $statistic;
    
          //$this->view->bookMarkTags = $bookmark->tags()->getTagMaps();
          //$this->view->userTags = $bookmark->tags()->getTagsByTagger($bookmark->getOwner());
         
          //$tam= Engine_Api::_()->getItemTable('book_mark');
          if($statistic->category_id !=0) $this->view->category = $categories = Engine_Api::_()->getApi('setting', 'statistics')->getCategory($statistic->category_id);
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
                    ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_profile');
        if( !$this->_helper->requireUser()->isValid() ) return;
        // check if user has create rights
        //if( !$this->_helper->requireAuth()->setAuthParams('blog', null, 'create')->isValid()) return;
        
        //$this->view->navigation = $this->getNavigation();
        /* Create form */
        //Zend_Debug::dump(Engine_Api::_()->getItemTable('news_new')->fetchAll());
        $this->view->form = $form = new Statistics_Form_Admin_Content_Create();
        
        // If not post or form not valid, return
        if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
        {
          $table = Engine_Api::_()->getItemTable('statistics_content');
          $db = $table->getAdapter();
          $db->beginTransaction();
          //Zend_Debug::dump(Engine_Api::_()->getItemTable('news_new'), "dh");exit();
          try
          {
            // Create news
            $viewer = Engine_Api::_()->user()->getViewer();
            $values = array_merge($form->getValues(), array(
             
              'user_id' => $viewer->getIdentity(),
              
            ));
           
            $new = $table->createRow();
            $new->created= date('Y-m-d H:i:s');
            $new->modified= date('Y-m-d H:i:s');
            $new->setFromArray($values);
            $new->save();
            //end save form news
            // Add photo
            /*
            if( !empty($values['photo']) ) {
                //Zend_Debug::dump($form->photo, 'php');exit();
                $new->setPhotos($form->photo);
                $new->save();
            }    
            */
            // Commit
            $db->commit();                  
    
            // Redirect
            //$this->_forward('index', 'admin-content', 'statistics');
            $this->_redirect('/admin/statistics/content', array('exit'=>false));
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
                    ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_profile');
        
        if( !$this->_helper->requireUser()->isValid() ) return;

        $viewer = $this->_helper->api()->user()->getViewer();
        //Zend_Debug::dump($bookmark_id, 'vl');exit();
        //Zend_Debug::dump($this->_getParam('bookmark_id'));exit();
        //$new = Engine_Api::_()->getItem('statistics_content', $this->_getParam('content_id'));
        $new= Engine_Api::_()->getItemTable('statistics_content')->find($this->_getParam('content_id'))->current();
        if( !Engine_Api::_()->core()->hasSubject('contents') )
        {
          Engine_Api::_()->core()->setSubject($new);
        }
    
        if( !$this->_helper->requireSubject()->isValid() ) return;
        
        $this->view->form = $form = new Statistics_Form_Admin_Content_Edit();
        // Save blog entry
        if( !$this->getRequest()->isPost())
        {
          // etc
          $form->populate($new->toArray());
          return;
        }
    
        if( !$form->isValid($this->getRequest()->getPost()) )
        {
          return;
        }
        // Process
    
        // handle save for tags
        $values = $form->getValues();
    
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        try
        {
          $new->setFromArray($values);
          $new->modified = date('Y-m-d H:i:s');
          $new->save();
          /*
          if( !empty($values['photo']) ) {
                //Zend_Debug::dump($form->photo, 'php');exit();
                $new->setPhotos($form->photo);
                $new->save();
            }    
          */
    
          $db->commit();
          //$this->_forward('index', 'admin-content', 'statistics');
          $this->_redirect('/admin/statistics/content', array('exit'=>false));        
        }
        catch( Exception $e )
        {
          $db->rollBack();
          throw $e;
        }
    }
}