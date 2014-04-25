<?php
/**
 * Viethospitality
 *
 * @category   Application_Extensions
 * @package    Recruiter search advanced job

 * @author     huynhnv
 */
class Recruiter_Form_Job_Advanced extends Engine_Form
{

  public function init()
  {
    $user = Engine_Api::_()->user()->getViewer();

    $this->setAttrib('id', 'recruiter_job_search_advanced_form')
      ->setMethod("POST")
      ->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array()))
      ;
    
    //position
    $this->addElement('Text', 'search_job', array(
      'label' => 'Keywords',
      //'required' => true,
      'maxlength' => 160,
      'validators' => array(
        array('NotEmpty', true),
        //array('StringLength', false, array(1, 21)),
      ),
      'filters' => array(
        'StripTags',
        new Engine_Filter_Censor(),
        new Engine_Filter_EnableLinks(),
      ),
    ));   
    $this->addElement('Radio', 'match', array(
      'label' => 'Job Must Match',
      'value'=> 1,
      'multiOptions' => array(
        '0'=> 'any of my keywords',
        '1'=> 'all of my keywords',
        '2'=> 'this exact phrase'
      )
      
    ));
    
     // Country - Province/city - location
    $this->addElement('Select', 'country_id', array(
      'label' => 'Location',
      'onchange'=>'javascript:list_city();',
      'multiOptions' => array(
        '0'=> 'All country'
      ),
    ));
    $this->addElement('Select', 'city_id', array(
      'label' => '',
      'multiOptions' => array(
        '0'=> 'All city'
      ),
    ));
    $this->getElement('city_id')->removeDecorator('label');
     // types
    $this->addElement('Select', 'type', array(
      'label' => 'Job Type',
      'multiOptions' => array(
      ),
    ));
   // Industries
    $this->addElement('MultiCheckbox', 'industries', array(
      'label' => 'Career',
      'allowEmpty' => false,
      //'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    $this->addElement('MultiCheckbox', 'categories', array(
      'label' => 'Industry',
      'allowEmpty' => false,
      //'required' => true,
      'filters' => array(
        new Engine_Filter_Censor(),
        'StripTags',
        new Engine_Filter_StringLength(array('max' => '63'))
    )));
    //submit
    $this->addElement('Button', 'submit', array(
      'label' => 'Search',
      'type' => 'submit',
      
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
     //submit
    $this->addElement('Button', 'cancel', array(
      'label' => 'Reset',
      'onclick'=> 'reset_search();',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));
    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons', array(
      'decorators' => array(
        'FormElements',
        'DivDivDivWrapper',
      ),
    ));
  }
}