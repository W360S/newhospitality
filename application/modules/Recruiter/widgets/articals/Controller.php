<?php
class Recruiter_Widget_ArticalsController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){           
        $table= Engine_Api::_()->getDbtable('articals', 'recruiter');
        $select= $table->select()->limit(3)->order('created DESC');
        $this->view->paginator= $table->fetchAll($select);
    }
}