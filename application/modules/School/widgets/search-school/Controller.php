<?php 
class School_Widget_SearchSchoolController extends Engine_Content_Widget_Abstract{
    //search school
    public function indexAction(){
        $this->view->form = $form = new School_Form_School_Search();
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries= $countryTable->fetchAll();
        foreach( $countries as $country ) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
    }
}