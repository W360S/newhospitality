<?php

class Resumes_ReferenceController extends Core_Controller_Action_Standard
{
    public function indexAction(){
        if( !$this->_helper->requireUser->isValid() ) return;
        $viewer = Engine_Api::_()->user()->getViewer();
        $this->view->form = $form = new Resumes_Form_Reference_Create();
        //get resume_id
        $resume_id= $this->_getParam('resume_id');
        $this->view->resume_id= $resume_id;
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id= $this->getRequest()->getPost('resume_id');
           
            //type submit
            $type= $this->getRequest()->getPost('type');
            $data = array(
                        'name' => $this->getRequest()->getPost('name'),
                        'resume_id' => $resume_id,
                        'title' => $this->getRequest()->getPost('title'),
                        'phone' => $this->getRequest()->getPost('phone'),
                        'email' => $this->getRequest()->getPost('email'),
                        'description' => $this->getRequest()->getPost('description'),
                        
                        'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $reference = Engine_Api::_()->getDbtable('references', 'resumes')->createRow();
            $reference->setFromArray($data);
            $reference->save();
            if($type=='save'){
                $this->dateAction(1);
            }
            
        }
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
    public function listReferenceAction(){
        $this->_helper->layout->disableLayout();
        //render view in order to display list experience
        $resume_id= $this->getRequest()->getPost('resume_id');
        $reference= Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
        $type= $this->getRequest()->getPost('type');
        if($type=='next'){
            if(count($reference)> 0){
                echo count($reference);
                exit;
            }
            else{
                echo 0;
                exit;
            }
        }
        $this->view->references= $reference;
    }
    public function resumeReferenceEditAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id= $this->getRequest()->getPost('resume_id');
            $ref_id= $this->getRequest()->getPost('ref_id');
            //type submit
            $type= $this->getRequest()->getPost('type');
            $data = array(
                        'name' => $this->getRequest()->getPost('name'),
                        'resume_id' => $resume_id,
                        'title' => $this->getRequest()->getPost('title'),
                        'phone' => $this->getRequest()->getPost('phone'),
                        'email' => $this->getRequest()->getPost('email'),
                        'description' => $this->getRequest()->getPost('description'),
                        
                        //'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $reference = Engine_Api::_()->getDbtable('references', 'resumes')->findRow($ref_id);
            $reference->setFromArray($data);
            $reference->save();
            if($type=='save'){
                $this->dateAction(1);
            }
            
        }
    }
    public function deleteReferenceAction(){
        if ($this->_request->isXmlHttpRequest()) {
            $refer_id= $this->getRequest()->getPost('refer_id');
            
			$db = Engine_Db_Table::getDefaultAdapter();
			$db->beginTransaction();

			try
			{
			     
                 $event = Engine_Api::_()->getItem('reference', $refer_id);
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