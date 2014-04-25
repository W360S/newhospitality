<?php 
class School_Widget_ManageSchoolController extends Engine_Content_Widget_Abstract
{
    //manage school home
    public function indexAction(){
        $user= Engine_Api::_()->user()->getViewer();
        if(!$user->getIdentity()){
            $this->setNoRender();
        }
        $tableSchool= Engine_Api::_()->getDbtable('schools', 'school');
        $tableArticle= Engine_Api::_()->getDbtable('articals', 'school');
        $selectSchool= $tableSchool->select()->where('user_id =?', $user->getIdentity());
        $selectArticle= $tableArticle->select()->where('user_id =?', $user->getIdentity());
        $schools= $tableSchool->fetchAll($selectSchool);
        $articles= $tableArticle->fetchAll($selectArticle);
        $this->view->schools= count($schools);
        $this->view->articles= count($articles);
    }
}