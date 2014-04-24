<?php 
class Recruiter_Widget_SearchResumesController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $this->view->form= $form= new Recruiter_Form_Recruiter_Search();
        //Country
        //if no country then???
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries= $countryTable->fetchAll();
        foreach( $countries as $country ) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        //$country_id= $countries[0]->country_id;
        $country_id= 230;
        
        //if no country then???, so city???
        //City init
        
        $cities= Engine_Api::_()->getApi('core', 'resumes')->getCity($country_id);
        foreach( $cities as $city ) {
          $form->city_id->addMultiOption($city->city_id, $city->name);
        }
        $levelTable = Engine_Api::_()->getDbtable('levels', 'resumes');
        foreach( $levelTable->fetchAll() as $level ) {
            $form->level->addMultiOption($level->level_id, $level->name);
        }
        $levelDegreeTable = Engine_Api::_()->getDbtable('degrees', 'resumes');
        foreach( $levelDegreeTable->fetchAll() as $level ) {
            $form->degree->addMultiOption($level->degree_id, $level->name);
        }
        $languageTable = Engine_Api::_()->getDbtable('languages', 'resumes');
        
        foreach( $languageTable->fetchAll() as $language ) {
            $form->language->addMultiOption($language->language_id, $language->name);
        }
        //add industries
        $industryTable = Engine_Api::_()->getDbtable('industries', 'recruiter');
        $industries= $industryTable->fetchAll();
        foreach( $industries as $industry ) {
            $form->industry->addMultiOption($industry->industry_id, $industry->name);
        }
    }
}