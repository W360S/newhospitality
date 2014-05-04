<?php

class Resumes_SkillController extends Core_Controller_Action_Standard
{
    public function indexAction(){
        if( !$this->_helper->requireUser->isValid() ) return;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Create form
        $this->view->form = $form = new Resumes_Form_Skill_Create();
        $languageTable = Engine_Api::_()->getDbtable('languages', 'resumes');
        
        foreach( $languageTable->fetchAll() as $language ) {
            $form->language_id->addMultiOption($language->language_id, $language->name);
        }
        $groupTable = Engine_Api::_()->getDbtable('groupSkills', 'resumes');
        //Zend_Debug::dump($groupTable->fetchAll());exit;
        foreach( $groupTable->fetchAll() as $group ) {
            $form->group_skill_id->addMultiOption($group->group_skill_id, $group->name);
        }
        //create form other skill
        $this->view->form_other= $form_other= new Resumes_Form_Skill_Other_Create();
        //get resume_id
        $resume_id= $this->_getParam('resume_id');
        $this->view->resume_id= $resume_id;
        
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id= $this->getRequest()->getPost('resume_id');
           
            //type submit
            $type= $this->getRequest()->getPost('type');
            $data = array(
                        'language_id' => $this->getRequest()->getPost('language_id'),
                        'resume_id' => $resume_id,
                        'group_skill_id' => $this->getRequest()->getPost('group_skill_id'),
                        
                        'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $skill = Engine_Api::_()->getDbtable('languageSkills', 'resumes')->createRow();
            $skill->setFromArray($data);
            $skill->save();
            if($type=='save'){
                $this->dateAction(1);
            }else{
                $this->dateAction(2);
            }
            
        }
        
        $this->_helper->content
                ->setContentName(41) // page_id
                // ->setNoRender()
                ->setEnabled();
        // Not post/invalid
        if( !$this->getRequest()->isPost() )      
        {
            //list language
            $languages= Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
            $this->view->languages= $languages;
            //list other skill
            $group_skills= Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
            $this->view->group_skill= $group_skills;
            //list reference
            $references= Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
            $this->view->references= $references;
            //update approved
            $resume = Engine_Api::_()->getItem('resume', $resume_id);
            $resume->approved= 2;//wait to approved
            $resume->save();
          return;
        }
        if( !$form->isValid($this->getRequest()->getPost()) )
        {
          return;
        }
    }
    public function dateAction($error){
    
        echo $error;
        exit;
    }
    public function listSkillAction(){
        $this->_helper->layout->disableLayout();
        //render view in order to display list experience
        $resume_id= $this->getRequest()->getPost('resume_id');
        $skills= Engine_Api::_()->getApi('core', 'resumes')->getListSkill($resume_id);
        $type= $this->getRequest()->getPost('type');
        if($type=='next'){
            if(count($skills)> 0){
                echo count($skills);
                exit;
            }
            else{
                echo 0;
                exit;
            }
        }
        //$this->view->skills= $skills;
         
        $languages= Engine_Api::_()->getApi('core', 'resumes')->getListLanguage();
        $group_skills= Engine_Api::_()->getApi('core', 'resumes')->getListGroupSkill();
        $arr= array();
        foreach($skills as $skill){
            foreach($languages as $language){
                if($skill->language_id==$language->language_id){
                    $arr[$skill->languageskill_id]['lang']=$language->name;
                }
                
            }
            foreach($group_skills as $group_skill){
                if($skill->group_skill_id==$group_skill->group_skill_id){
                    $arr[$skill->languageskill_id]['skill']=$group_skill->name;
                }
                
            }
        }
        $this->view->arr= $arr;
        
    }
    public function skillEditAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id= $this->getRequest()->getPost('resume_id');
            $skill_id= $this->getRequest()->getPost('skill_id');
            //type submit
            $type= $this->getRequest()->getPost('type');
            $data = array(
                        'language_id' => $this->getRequest()->getPost('language_id'),
                        'resume_id' => $resume_id,
                        'group_skill_id' => $this->getRequest()->getPost('group_skill_id'),
                        
                        //'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $skill = Engine_Api::_()->getDbtable('languageSkills', 'resumes')->findRow($skill_id);
            $skill->setFromArray($data);
            $skill->save();
            if($type=='save'){
                $this->dateAction(1);
            }else{
                $this->dateAction(2);
            }
            
        }
    }
    public function deleteSkillAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $skill_id= $this->getRequest()->getPost('skill_id');
            
			$db = Engine_Db_Table::getDefaultAdapter();
			$db->beginTransaction();

			try
			{
			     
                 $event = Engine_Api::_()->getItem('languageskill', $skill_id);
                 $event->delete();
                 $this->dateAction(1);
				 $db->commit();
			}

			catch( Exception $e )
			{
				$db->rollBack();
				throw $e;
			}

			
		}
    }
    //other skill
    public function resumeSkillAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id= $this->getRequest()->getPost('resume_id');
           
            //type submit
            $type= $this->getRequest()->getPost('type');
            $data = array(
                        'name' => $this->getRequest()->getPost('name_skill'),
                        'resume_id' => $resume_id,
                        'description' => $this->getRequest()->getPost('description'),
                        
                        'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $skill = Engine_Api::_()->getDbtable('skills', 'resumes')->createRow();
            $skill->setFromArray($data);
            $skill->save();
            if($type=='save'){
                $this->dateAction(1);
            }
            
        }
    }
    public function listSkillOtherAction(){
        $this->_helper->layout->disableLayout();
        //render view in order to display list experience
        $resume_id= $this->getRequest()->getPost('resume_id');
        $skills= Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
        $type= $this->getRequest()->getPost('type');
        if($type=='next'){
            if(count($skills)> 0){
                echo count($skills);
                exit;
            }
            else{
                echo 0;
                exit;
            }
        }
        $this->view->skills= $skills;
    }
    //save edit resume skill other
    public function resumeSaveSkillOtherAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id= $this->getRequest()->getPost('resume_id');
           
            //type submit
            $type= $this->getRequest()->getPost('type');
            $skill_id= $this->getRequest()->getPost('skill_id');
            $data = array(
                        'name' => $this->getRequest()->getPost('name_skill'),
                        'resume_id' => $resume_id,
                        'description' => $this->getRequest()->getPost('description'),
                        
                        //'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $skill = Engine_Api::_()->getDbtable('skills', 'resumes')->findRow($skill_id);
            $skill->setFromArray($data);
            $skill->save();
            if($type=='save'){
                $this->dateAction(1);
            }
            
        }
    }
    //delete skill other
    public function deleteSkillOtherAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $skill_id= $this->getRequest()->getPost('skill_other_id');
            
			$db = Engine_Db_Table::getDefaultAdapter();
			$db->beginTransaction();

			try
			{
			     
                 $event = Engine_Api::_()->getItem('skill', $skill_id);
                 $event->delete();
                 $this->dateAction(1);
				 $db->commit();
			}

			catch( Exception $e )
			{
				$db->rollBack();
				throw $e;
			}

			
		}
    }
}