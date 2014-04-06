<?php
/**
 * SocialEngine
 * @author     quangnvh
 */

class Group_Widget_FeaturedController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
	$table = Engine_Api::_()->getItemTable('group');
	//Zend_Debug::dump($table->info('name'), 'table');exit();
	$groupTable = Engine_Api::_()->getDbtable('groups', 'group');
	
	$select = $groupTable->select()
		  ->from($groupTable->info('name'))
		  ->order('member_count DESC')
		  ->limit(24);		  
    $result = $select->query()->fetchAll();
    if(count($result)){
        foreach($result as $key => $item){
           $file= Engine_Api::_()->getDbtable('files', 'storage')->listPhotoFriends($item['photo_id']);
           //Zend_debug::dump($file->storage_path); exit;
           if($file){
            $result[$key]['img_url']= $file->storage_path;
           }
        }
    }
	//Zend_Debug::dump($result);exit();
	
    $this->view->group1 = $result;
  }
}