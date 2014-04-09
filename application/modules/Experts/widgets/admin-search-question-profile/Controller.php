<?php

class Experts_Widget_AdminSearchQuestionProfileController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $expert_id = Zend_Controller_Front::getInstance()->getRequest()->getParam("expert_id");
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'experts');
    $select = $categoryTable->select()
      ->order('priority ASC');
    $categories = $categoryTable->fetchAll($select);
    $this->view->categories = $categories;
    $this->view->expert_id = $expert_id;
  }
}