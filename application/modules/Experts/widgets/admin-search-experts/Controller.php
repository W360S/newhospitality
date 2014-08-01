<?php

class Experts_Widget_AdminSearchExpertsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $url = Zend_Controller_Front::getInstance()->getRequest();
    
    $arr_cats = array();
    if(intval($url->cat_id) !=0){
        $arr_cats = explode(",",$url->cat_id);
    }
    
    $this->view->order= $url->order;
    $this->view->arr_cats= $arr_cats;
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'experts');
    $select = $categoryTable->select()
      ->order('priority ASC');
    $categories = $categoryTable->fetchAll($select);
    $this->view->categories = $categories;
  }
}