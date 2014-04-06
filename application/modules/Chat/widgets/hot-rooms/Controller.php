<?php
class Chat_Widget_HotRoomsController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
    	$viewer = Engine_Api::_()->user()->getViewer();
    	$this->view->user_id= $viewer->getIdentity();
    	 $table = Engine_Api::_()->getDbTable('rooms', 'chat');
		//Zend_Debug::dump($table->info('name'), 'table');exit();
		//$groupTable = Engine_Api::_()->getDbtable('news', 'news');
		
		$select = $table->select()
			  ->from($table)
              ->order('user_count DESC')
			  ->limit(4);
			  //->where('level_id =?', 1);
			  
	    $result = $table->fetchAll($select);
        
	    $this->view->rooms= $result;
	    //Zend_Debug::dump($result);exit();
        
    }
    
}