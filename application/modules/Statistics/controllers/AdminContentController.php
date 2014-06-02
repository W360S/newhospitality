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
class Statistics_AdminContentController extends Core_Controller_Action_Admin
{

  public function indexAction()
  {
  
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_content');
    $page = $this->_getParam('page',1);
    $content_table = Engine_Api::_()->getDbtable('contents', 'statistics');
    $select= $content_table->select();
    $this->view->paginator = Zend_Paginator::factory($select);
    $this->view->paginator->setItemCountPerPage(30);
    $this->view->paginator->setCurrentPageNumber($page);
  }
  
  public function deleteSelectedAction()
  {
    $this->view->ids = $ids = $this->_getParam('ids', null);
    $confirm = $this->_getParam('confirm', false);
    $this->view->count = count(explode(",", $ids));

    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $ids_array = explode(",", $ids);
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      try
      {
          foreach( $ids_array as $id ){
            $news = Engine_Api::_()->getDbtable('contents', 'statistics')->find($id)->current();
            if( $news ) {
                $news->delete();
                $db->commit();
                /*
                if($news->photo_id){ 
                    Engine_Api::_()->news()->deleteFile($news->photo_id);
                }
                */
            }
          }
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
      $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }

  public function deleteAction()
  {
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->content_id=$id;
    // Check post
    if( $this->getRequest()->isPost())
    {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
        //$new = Engine_Api::_()->getItem('statistics_content', $id);
        $new= Engine_Api::_()->getItemTable('statistics_content')->find($id)->current();
        $new->delete();
        /*
        if($news->photo_id){ 
            Engine_Api::_()->news()->deleteFile($news->photo_id);
        }
        */
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
    $this->renderScript('admin-content/delete.tpl');
  }
}