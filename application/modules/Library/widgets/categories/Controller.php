<?php
class Library_Widget_CategoriesController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
        $cat_id = Zend_Controller_Front::getInstance()->getRequest()->getParam("cat_id");
        $arr_cats = array();
        if(intval($cat_id) !=0){
            $arr_cats = explode(",",$cat_id);
        }
        
        if(count($arr_cats) == 1){
            $cat_id = $arr_cats[0];
        } else {
            $cat_id = 0;
        }
        $this->view->cat_id = $cat_id;
        $this->view->data = Engine_Api::_()->library()->getCategories();
    }
}