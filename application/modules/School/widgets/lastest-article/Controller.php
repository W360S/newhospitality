<?php 
class School_Widget_LastestArticleController extends Engine_Content_Widget_Abstract
{
    //top articles home
    public function indexAction(){
        $table= Engine_Api::_()->getDbtable('articals', 'school');
        $select= $table->select()
                    ->where('approved =?', 1)
                    ->limit(3)
                    ->order('created DESC')
                    ;
        $articles = $table->fetchAll($select);
        $this->view->articles= $articles;
    }
}