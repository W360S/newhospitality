<?php
class Event_Widget_SearchMyEventsController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
        $request=  Zend_Controller_Front::getInstance()->getRequest();
        $category_id= $request->category_id;
        $tmp= $request->getParams();
        if(key_exists("amp;category_id",$tmp))
        {
            $category_id = $tmp["amp;category_id"];
        }
        $this->view->category_id= $category_id;
        
    }
}