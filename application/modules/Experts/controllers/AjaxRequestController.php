 <?php

class Experts_AjaxRequestController extends Core_Controller_Action_Standard
{
  
  public function selectedExpertsAction(){
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       
        $array_cat = $this->_request->getParam("cats");
        
        $answerName             = Engine_Api::_()->getDbtable('answers', 'experts')->info('name'); 
        $expertsName            = Engine_Api::_()->getDbtable('experts', 'experts')->info('name');
        $expertsCategoriesName  = Engine_Api::_()->getDbtable('expertscategories', 'experts')->info('name');
        $usersName              = Engine_Api::_()->getDbtable('users', 'user')->info('name');
         
        $experts_select = Engine_Api::_()->getDbtable('answers', 'experts')->select()
          ->setIntegrityCheck(false)
          ->from($answerName, new Zend_Db_Expr('engine4_experts_answers.user_id,engine4_experts_experts.*, 
                                                count(question_id) as answered,
                                                engine4_users.* 
                                               ')
                )
          ->joinLeft($expertsName,'engine4_experts_answers.user_id=engine4_experts_experts.user_id',array())
          ->joinLeft($usersName,'engine4_users.user_id=engine4_experts_answers.user_id',array())
          ->group('engine4_experts_answers.user_id')
          ->order('answered desc')
          ->limit(15);
        if(empty($array_cat)){
            $experts_select->where('engine4_experts_answers.user_id in (?)', 
                    new Zend_Db_Expr('select engine4_experts_experts.user_id 
                                      from engine4_experts_expertscategories
                                      LEFT JOIN engine4_experts_experts
                                      ON engine4_experts_expertscategories.expert_id=engine4_experts_experts.expert_id')
            );
        } else {
            $experts_select->where('engine4_experts_answers.user_id in (?)', 
                    new Zend_Db_Expr('select engine4_experts_experts.user_id 
                                      from engine4_experts_expertscategories
                                      LEFT JOIN engine4_experts_experts
                                      ON engine4_experts_expertscategories.expert_id=engine4_experts_experts.expert_id
                                      where  engine4_experts_expertscategories.category_id in ('.$array_cat.')')
            );
        }

        // $answersTable = Engine_Api::_()->getDbTable('experts', 'experts');
        // $answersSelect = $answersTable->select()
        // ->setIntegrityCheck(false)
        // ->from($expertsName, new Zend_Db_Expr('
        //                             engine4_experts_experts.*,
        //                             engine4_users.* 
        //                             '))
        // ->joinLeft($answerName,'engine4_experts_answers.user_id=engine4_experts_experts.user_id',array())
        // ->joinLeft($usersName,'engine4_users.user_id=engine4_experts_experts.user_id',array())
        // ->joinLeft($expertsCategoriesName,'engine4_experts_expertscategories.expert_id=engine4_experts_experts.expert_id',array())
        // ->where('engine4_experts_expertscategories.category_id in (?)', $array_cat)
        // ->limit(55);

        $selectdExperts = Engine_Api::_()->getDbTable('answers', 'experts')->select()
        ->setIntegrityCheck(false)
        ->from($expertsCategoriesName, new Zend_Db_Expr('
          engine4_experts_expertscategories.expert_id,
          count(answer_id) as answered,
          count(question_id) as questioned,
          engine4_experts_expertscategories.*,
          engine4_experts_experts.*,
          engine4_experts_answers.*,
          engine4_users.* 
          '))
        ->joinLeft($expertsName,'engine4_experts_experts.expert_id=engine4_experts_expertscategories.expert_id',array() )
        ->joinLeft($answerName,'engine4_experts_answers.user_id=engine4_experts_experts.user_id',array())
        ->joinLeft($usersName,'engine4_users.user_id=engine4_experts_experts.user_id',array())
        ->where('engine4_experts_expertscategories.category_id in ('.$array_cat.')',array())
        ->group('engine4_experts_experts.user_id');

        //print_r($selectdExperts->assemble());
        //die;

        $data = Engine_Api::_()->getDbTable('answers', 'experts')->fetchAll($selectdExperts);

        $this->view->data = $data;
        $this->renderScript('_selectedexpertswidget.tpl');
    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }
  
  public function getExpertsFromCatsAction(){
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
        
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $array_cat = $this->_request->getParam("cats");
        $arr_cats = array();
        $arr_cats = explode(",",$array_cat);
        
        $catsExpertsName = Engine_Api::_()->getDbtable('expertscategories', 'experts')->info('name'); 
        $expertsName = Engine_Api::_()->getDbtable('experts', 'experts')->info('name');
        $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
         
        $experts_select = Engine_Api::_()->getDbtable('expertscategories', 'experts')->select()
          ->setIntegrityCheck(false)
          ->from($catsExpertsName, new Zend_Db_Expr('engine4_experts_expertscategories.expert_id,engine4_experts_experts.*,engine4_users.user_id,engine4_users.displayname'))
          ->joinLeft($expertsName,'engine4_experts_experts.expert_id = engine4_experts_expertscategories.expert_id',array())
          ->joinLeft($usersName,'engine4_users.user_id = engine4_experts_experts.user_id',array())
          ->where('engine4_experts_expertscategories.category_id in (?)', $arr_cats)
          ->where('engine4_experts_experts.user_id != ?', $user_id)
          ->group('engine4_experts_expertscategories.expert_id')
          ->order('engine4_experts_experts.created_date desc');
        $data = Engine_Api::_()->getDbTable('expertscategories', 'experts')->fetchAll($experts_select);
        
        $this->view->data = $data;
        $this->renderScript('_getexpertscatswidget.tpl');
    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }
  
}