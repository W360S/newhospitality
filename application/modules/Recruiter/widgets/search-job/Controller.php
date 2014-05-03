<?php
/*
@author: huynhnv
@function: industry job

*/ 
class Recruiter_Widget_SearchJobController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        
        $this->view->form= $form= new Recruiter_Form_Job_Search();
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
        //industries
        
        $industryTable = Engine_Api::_()->getDbtable('industries', 'recruiter');
        $industries= $industryTable->fetchAll();
        foreach( $industries as $industry ) {
            $form->industry->addMultiOption($industry->industry_id, $industry->name);
        }
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'recruiter');
        $categories= $categoryTable->fetchAll();
        foreach( $categories as $category ) {
            $form->category->addMultiOption($category->category_id, $category->name);
        }
        /*
        //position
        $positionTable = Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $positions= $positionTable->fetchAll();
        foreach( $positions as $position ) {
            $form->position->addMultiOption($position->job_id, $position->position);
        }
        */
    }
}