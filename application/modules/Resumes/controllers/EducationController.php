<?php

class Resumes_EducationController extends Core_Controller_Action_Standard
{
    public function indexAction(){
        if( !$this->_helper->requireUser->isValid() ) return;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Create form
        $this->view->form = $form = new Resumes_Form_Education_Create();
        // Populate form options
        //level
        $levelDegreeTable = Engine_Api::_()->getDbtable('degrees', 'resumes');
        foreach( $levelDegreeTable->fetchAll() as $level ) {
            $form->degree_level_id->addMultiOption($level->degree_id, $level->name);
        }
        //Country
        //if no country then???
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries= $countryTable->fetchAll();
        foreach( $countries as $country ) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        //get resume_id
        $resume_id= $this->_getParam('resume_id');
        $this->view->resume_id= $resume_id;
        //if save by ajax
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id= $this->getRequest()->getPost('resume_id');
            
            //type submit
            $type= $this->getRequest()->getPost('type');
            /*
            check table experience existed record (if submit with type is next);
            
            if($type=='next'){
                $work_experiences= Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
                
            }
            */
            //convert datetime
            /*
            $starttime = $this->getRequest()->getPost('starttime');
            $endtime = $this->getRequest()->getPost('endtime');
            //process starttime
            $starttime= explode('/', $starttime);
            $hour= $this->getRequest()->getPost('starttime_hour');
            $minute= $this->getRequest()->getPost('starttime_minute');
            $starttime_ampm= $this->getRequest()->getPost('starttime_ampm');
    
            if(empty($hour) || empty($minute) || empty($starttime_ampm)){
                $hour=$minute= 0;
                $starttime_ampm='AM';
            }
            if($starttime_ampm=='PM'){
                $hour+= 12;
            }
            //process endtime
            $endtime= explode('/', $endtime);
            $hour_end= $this->getRequest()->getPost('endtime_hour');
            $minute_end= $this->getRequest()->getPost('endtime_minute');
            $endtime_ampm= $this->getRequest()->getPost('endtime_ampm');
            if(empty($hour_end) || empty($minute_end) || empty($endtime_ampm)){
                $hour_end=$minute_end= 0;
                $endtime_ampm='AM';
            }
            if($endtime_ampm=='PM'){
                $hour_end+= 12;
            }
            //if not date then inform error to action dateAction();
            if(checkdate($starttime[0], $starttime[1], $starttime[2])==false || checkdate($endtime[0], $starttime[1], $starttime[2])==false){
                $this->_helper->layout->disableLayout();
                $this->dateAction(0); 
            };
            
            //Convert endtime
            */
            $starttime_month = $this->getRequest()->getPost('starttime_month');
            $starttime_year= $this->getRequest()->getPost('starttime_year');
            $starttime_day= $this->getRequest()->getPost('starttime_day');
            $starttime= $starttime_year.'-'.$starttime_month.'-'.$starttime_day;
            $endtime_month= $this->getRequest()->getPost('endtime_month');
            $endtime_year= $this->getRequest()->getPost('endtime_year');
            $endtime_day= $this->getRequest()->getPost('endtime_day');
            $endtime = $endtime_year.'-'.$endtime_month.'-'.$endtime_day;
            //if not date then inform error to action dateAction();
            if(checkdate($starttime_month, $starttime_day, $starttime_year)==false || checkdate($endtime_month, $endtime_day, $endtime_year)==false){
                $this->_helper->layout->disableLayout();
                $this->dateAction(0); 
            };
            $viewer= Engine_Api::_()->user()->getViewer();
            $oldTz = date_default_timezone_get();
        	date_default_timezone_set($viewer->timezone);
        	$start = strtotime($starttime);
        	$end = strtotime($endtime);
        	date_default_timezone_set($oldTz);
            
            if($start> $end){
                $this->_helper->layout->disableLayout();
                $this->dateAction(1);
            }
    
            //$starttime = date('Y-m-d', $start);
            //$endtime = date('Y-m-d', $end);
            $data = array(
                        'degree_level_id' => $this->getRequest()->getPost('degree_level_id'),
                        'resume_id' => $resume_id,
                        'school_name' => $this->getRequest()->getPost('school_name'),
                        'major' => $this->getRequest()->getPost('major'),
                        'country_id' => $this->getRequest()->getPost('country_id'),
                        'starttime' => $starttime,
                        'endtime' => $endtime,
                        'description' => $this->getRequest()->getPost('description'),
                        'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $education = Engine_Api::_()->getDbtable('educations', 'resumes')->createRow();
            $education->setFromArray($data);
            $education->save();
            if($type=='save'){
                $this->dateAction(2);
            }else{
                $this->dateAction(3);
            }
            
        }
        // Not post/invalid
        if( !$this->getRequest()->isPost() )      
        {
            //list work experience
            $works= Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
            $this->view->works= $works;
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
    public function listEducationAction(){
        $this->_helper->layout->disableLayout();
        //render view in order to display list experience
        $resume_id= $this->getRequest()->getPost('resume_id');
        $educations= Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
        $type= $this->getRequest()->getPost('type');
        if($type=='next'){
            if(count($educations)> 0){
                echo count($educations);
                exit;
            }
            else{
                echo 0;
                exit;
            }
        }
        $this->view->educations= $educations;
    }
    public function resumeEducationEditAction(){
        //if save by ajax
        if ($this->_request->isXmlHttpRequest()) {
            
            $edu_id= $this->getRequest()->getPost('edu_id');
            $resume_id= $this->getRequest()->getPost('resume_id');
            
            //type submit
            $type= $this->getRequest()->getPost('type');
            /*
            check table experience existed record (if submit with type is next);
            
            if($type=='next'){
                $work_experiences= Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
                
            }
            */
            //convert datetime
            /*
            $starttime = $this->getRequest()->getPost('starttime');
            $endtime = $this->getRequest()->getPost('endtime');
            //process starttime
            $starttime= explode('/', $starttime);
            $hour= $this->getRequest()->getPost('starttime_hour');
            $minute= $this->getRequest()->getPost('starttime_minute');
            $starttime_ampm= $this->getRequest()->getPost('starttime_ampm');
    
            if(empty($hour) || empty($minute) || empty($starttime_ampm)){
                $hour=$minute= 0;
                $starttime_ampm='AM';
            }
            if($starttime_ampm=='PM'){
                $hour+= 12;
            }
            //process endtime
            $endtime= explode('/', $endtime);
            $hour_end= $this->getRequest()->getPost('endtime_hour');
            $minute_end= $this->getRequest()->getPost('endtime_minute');
            $endtime_ampm= $this->getRequest()->getPost('endtime_ampm');
            if(empty($hour_end) || empty($minute_end) || empty($endtime_ampm)){
                $hour_end=$minute_end= 0;
                $endtime_ampm='AM';
            }
            if($endtime_ampm=='PM'){
                $hour_end+= 12;
            }
            //if not date then inform error to action dateAction();
            if(checkdate($starttime[0], $starttime[1], $starttime[2])==false || checkdate($endtime[0], $starttime[1], $starttime[2])==false){
                $this->_helper->layout->disableLayout();
                $this->dateAction(0); 
            };
            
            //Convert endtime
            
            $starttime=$starttime[2].'-'.$starttime[0].'-'.$starttime[1].''. $hour.':'.$minute;
            $endtime=$endtime[2].'-'.$endtime[0].'-'.$endtime[1].''. $hour_end.':'.$minute_end;
            */
            $starttime_month = $this->getRequest()->getPost('starttime_month');
            $starttime_year= $this->getRequest()->getPost('starttime_year');
            $starttime_day= $this->getRequest()->getPost('starttime_day');
            $starttime= $starttime_year.'-'.$starttime_month.'-'.$starttime_day;
            $endtime_month= $this->getRequest()->getPost('endtime_month');
            $endtime_year= $this->getRequest()->getPost('endtime_year');
            $endtime_day= $this->getRequest()->getPost('endtime_day');
            $endtime = $endtime_year.'-'.$endtime_month.'-'.$endtime_day;
            //if not date then inform error to action dateAction();
            if(checkdate($starttime_month, $starttime_day, $starttime_year)==false || checkdate($endtime_month, $endtime_day, $endtime_year)==false){
                $this->_helper->layout->disableLayout();
                $this->dateAction(0); 
            };
            $viewer= Engine_Api::_()->user()->getViewer();
            $oldTz = date_default_timezone_get();
        	date_default_timezone_set($viewer->timezone);
        	$start = strtotime($starttime);
        	$end = strtotime($endtime);
        	date_default_timezone_set($oldTz);
            
            if($start> $end){
                $this->_helper->layout->disableLayout();
                $this->dateAction(1);
            }
    
            //$starttime = date('Y-m-d', $start);
            //$endtime = date('Y-m-d', $end);
            $data = array(
                        'degree_level_id' => $this->getRequest()->getPost('degree_level_id'),
                        'resume_id' => $resume_id,
                        'school_name' => $this->getRequest()->getPost('school_name'),
                        'major' => $this->getRequest()->getPost('major'),
                        'country_id' => $this->getRequest()->getPost('country_id'),
                        'starttime' => $starttime,
                        'endtime' => $endtime,
                        'description' => $this->getRequest()->getPost('description'),
                        //'creation_date'=> date('Y-m-d H:i:s'),
                        'modified_date' =>date('Y-m-d H:i:s')             
                    );
            
            $education = Engine_Api::_()->getDbtable('educations', 'resumes')->findRow($edu_id);
            $education->setFromArray($data);
            $education->save();
            if($type=='save'){
                $this->dateAction(2);
            }else{
                $this->dateAction(3);
            }
            
        }
    }
    public function deleteEducationAction()
	{
		if ($this->_request->isXmlHttpRequest()) {
            $education_id= $this->getRequest()->getPost('education_id');
            
			$db = Engine_Db_Table::getDefaultAdapter();
			$db->beginTransaction();

			try
			{
			     
                 $event = Engine_Api::_()->getItem('education', $education_id);
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